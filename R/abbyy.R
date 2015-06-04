"
Code for Using Abbyy Fine Cloud OCR SDK API from R

Part of abbyyR R package

To get app_id and app_password, go to:
http://ocrsdk.com/

@author: Gaurav Sood
"


#' Sets Application ID and Password
#'
#' Sets Application ID and Password. Needed for interfacing with Abbyy FineReader Cloud OCR SDK
#' @param appdetails: a vector of app_id, app_password. Get these from http://ocrsdk.com/. Set them before you use other functions.
#' @keywords Sets Application ID and Password
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/getApplicationInfo/}
#' @examples
#' setapp(c("app_id", "app_password"))

setapp <- function(appdetails=NULL){
    if(!is.null(appdetails))
        options(AbbyyAppId = appdetails[1], AbbyyAppPassword=appdetails[2])
    else
        return(getOption('AbbyyAppId'))    
}

#' Get Application Info
#'
#' Get Information about the Application including details like: Name of the Application, No. of pages remaining (given the money), No. of fields remaining (given the money), and when the application credits expire. The function automatically prints these out. It also stores these in a list.
#' @keywords Get Application Information
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/getApplicationInfo/}
#' @references \url{http://ocrsdk.com/schema/appInfo-1.0.xsd}
#' @examples
#' getAppInfo()

getAppInfo <- function(){
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	res <- httr::GET(paste0("http://",app_id,":",app_pass,"@cloud.ocrsdk.com/getApplicationInfo"))
	httr::stop_for_status(res)
	appinfo <- XML::xmlToList(httr::content(res))[[1]]

	cat("Name of Application: ", appinfo$name, "\n", sep = "")
  	cat("No. of Pages Remaining: ", appinfo$pages, "\n", sep = "")
  	cat("No. of Fields Remaining: ", appinfo$fields, "\n", sep = "")
  	cat("Application Credits Expire on: ", appinfo$expires, "\n", sep = "")
  	cat("Type: ", appinfo$type, "\n", sep = "")
  	return(invisible(appinfo))
}

#' List Tasks
#'
#' List all the tasks in the application. You can specify a date range and whether or not you want to include deleted tasks. 
#' The function prints Total number of tasks, Task IDs, and No. of Finished Tasks. 
#' The function returns a data.frame with the following columns: id (task id), registrationTime, statusChangeTime, status (Submitted, Queued, InProgress, Completed, ProcessingFailed, Deleted, NotEnoughCredits), filesCount (No. of files), credits, resultUrl (URL for the processed file)
#' @param fromDate; not required;  format: yyyy-mm-ddThh:mm:ssZ
#' @param toDate; not required;  format: yyyy-mm-ddThh:mm:ssZ
#' @param excludeDeleted; not required; default='false'
#' @keywords List Tasks
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/getApplicationInfo/}
#' @examples
#' listTasks(fromDate=NULL,toDate=NULL,excludeDeleted='false')

listTasks <- function(fromDate=NULL,toDate=NULL, excludeDeleted='false'){
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	querylist = list(fromDate = fromDate, toDate = toDate, excludeDeleted=excludeDeleted)
	res <- httr::GET(paste0("http://",app_id,":",app_pass,"@cloud.ocrsdk.com/listTasks"), query=querylist)
	httr::stop_for_status(res)
	tasklist <- XML::xmlToList(httr::content(res))

	# Converting list to a data.frame
	lenitem <- sapply(tasklist, length) # length of each list item
	resdf <- do.call(rbind.data.frame, tasklist) # collapse to a data.frame, wraps where lenitems < longest list (7)
	names(resdf) <- c("id", "registrationTime", "statusChangeTime", "status", "filesCount", "credits", "resultUrl") # names for the df
	row.names(resdf) <- 1:nrow(resdf)	# row.names for the df
	resdf[lenitem == 6,7] <- NA 		# Fill NAs where lenitems falls short

	# Print some important things
	cat("Total No. of Tasks: ", nrow(resdf), "\n")
	cat("No. of Finished Tasks: ", sum(lenitem==7), "\n")
  	cat("Task IDs: \n", paste(resdf$id, collapse='\n '), "\n")

  	# Return the data.frame
	return(invisible(resdf))
}

#' List Finished Tasks
#'
#' List all the finished tasks in the application. 
#' From Abbyy FineReader: The tasks are ordered by the time of the end of processing. No more than 100 tasks can be returned at one method call. 
#' The function prints No. of Finished Tasks, Task IDs of finished tasks
#' The function returns a data.frame with the following columns: id (task id), registrationTime, statusChangeTime, status (Submitted, Queued, InProgress, Completed, ProcessingFailed, Deleted, NotEnoughCredits), filesCount (No. of files), credits, resultUrl (URL for the processed file)
#' @keywords Finished Tasks
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/listFinishedTasks/}
#' @examples
#' listFinishedTasks()

listFinishedTasks <- function(){
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	res <- httr::GET(paste0("http://",app_id,":",app_pass,"@cloud.ocrsdk.com/listFinishedTasks"))
	httr::stop_for_status(res)
	tasklist <- XML::xmlToList(httr::content(res))
	resdf <- do.call(rbind.data.frame, tasklist) # collapse to a data.frame, wraps where lenitems < longest list (7)
	names(resdf) <- c("id", "registrationTime", "statusChangeTime", "status", "filesCount", "credits", "resultUrl") # names for the df
	row.names(resdf) <- 1:nrow(resdf)	# row.names for the df

	# Print some important things
	cat("No. of Finished Tasks: ", sum(lenitem==7), "\n")
  	cat("Task IDs: \n", paste(resdf$id, collapse='\n '), "\n")

	return(invisible(resdf))
}

#' Get Task Status
#'
#' This function gets task status for a particular task ID.
#' The function prints the status of the task by default.
#' The function returns a data.frame with all the task details: id (task id), registrationTime, statusChangeTime, status (Submitted, Queued, InProgress, Completed, ProcessingFailed, Deleted, NotEnoughCredits), filesCount (No. of files), credits, resultUrl (URL for the processed file if applicable)
#' @param taskId
#' @keywords Task Status
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/getTaskStatus/}
#' @examples
#' getTaskStatus(taskId="task_id")

getTaskStatus <- function(taskId=NULL){
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	if(is.null(taskId)) stop("Must specify taskId")
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	querylist = list(taskId = taskId)
	res <- httr::GET(paste0("http://",app_id,":",app_pass,"@cloud.ocrsdk.com/getTaskStatus"), query=querylist)
	httr::stop_for_status(res)
	taskdetails <- XML::xmlToList(httr::content(res))
	
	resdf <- do.call(rbind.data.frame, taskdetails) # collapse to a data.frame
	names(resdf) <- c("id", "registrationTime", "statusChangeTime", "status", "filesCount", "credits", "resultUrl")[1:length(resdf)] # names for the df, adjust for <7
	row.names(resdf) <- 1:nrow(resdf)	# row.names for the df

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")

	return(invisible(resdf))
}

#' Delete Task
#'
#' This function deletes a particular task and associated data. From Abbyy "If you try to delete the task that has already been deleted, the successful response is returned."
#' The function by default prints the status of the task you are trying to delete. It will show up as 'deleted' if successful
#' The function returns a data.frame with all the details of the task you are trying to delete: id (task id), registrationTime, statusChangeTime, status (Submitted, Queued, InProgress, Completed, ProcessingFailed, Deleted, NotEnoughCredits), filesCount (No. of files), credits, resultUrl (URL for the processed file if applicable)
#' @param taskId
#' @keywords Delete Task
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/deleteTask/}
#' @examples
#' deleteTask(taskId="task_id")

deleteTask <- function(taskId=NULL){
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	if(is.null(taskId)) stop("Must specify taskId")
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	querylist = list(taskId = taskId)
	res <- httr::GET(paste0("http://",app_id,":",app_pass,"@cloud.ocrsdk.com/deleteTask"), query=querylist)
	httr::stop_for_status(res)
	deletedTaskdetails <- XML::xmlToList(httr::content(res))
	
	resdf <- do.call(rbind.data.frame, deletedTaskdetails) # collapse to a data.frame
	names(resdf) <- c("id", "registrationTime", "statusChangeTime", "status", "filesCount", "credits", "resultUrl")[1:length(resdf)] # names for the df, adjust for <7
	row.names(resdf) <- 1:nrow(resdf)	# row.names for the df

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")

	return(invisible(resdf))
}

#' Submit Image
#'
#' Adds image to the existing task or creates a new task for the uploaded image. The new task isn't processed till processDocument or processFields is called.
#' The function returns a data.frame with all the details of the submitted image: id (task id), registrationTime, statusChangeTime, status (Submitted, Queued, InProgress, Completed, ProcessingFailed, Deleted, NotEnoughCredits), filesCount (No. of files), credits
#' @param taskId - assigns image to the task ID specified. If empty string is passed, a new task is created. 
#' @param pdfPassword - Optional. If the pdf is password protected, put the password here.
#' @keywords Submit Image
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/submitImage/}
#' @examples
#' submitImage(file_path="/images/image1.png",taskId="task_id",pdfPassword="pdf_password")

submitImage <- function(file_path=NULL, taskId="", pdfPassword=NULL){
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	if(is.null(file_path)) stop("Must specify file_path")
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	querylist = list(taskId = taskId, pdfPassword=pdfPassword)
	res <- httr::POST(paste0("http://",app_id,":",app_pass,"@cloud.ocrsdk.com/submitImage"), query=querylist, body=httr::upload_file(file_path))
	httr::stop_for_status(res)
	submitdetails <- XML::xmlToList(httr::content(res))
	
	resdf <- do.call(rbind.data.frame, submitdetails) # collapse to a data.frame
	names(resdf) <- c("id", "registrationTime", "statusChangeTime", "status", "filesCount", "credits", "resultUrl")[1:length(resdf)] # names for the df, adjust for <7
	row.names(resdf) <- 1:nrow(resdf)	# row.names for the df

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")

	return(invisible(resdf))
}

#' Process Image
#'
#' This function processes an image
#' @param language; optional, default: English
#' @param profile;   optional, default: documentConversion
#' @param textType;  optional, default: normal
#' @param imageSource;  optional, default: auto
#' @param correctOrientation;  optional, default: true
#' @param correctSkew;  optional, default: true
#' @param readBarcodes;  optional, default: 
#' @param exportFormat;  optional, default: txt
#' @param pdfPassword;  optional, default: NULL
#' @param description;  optional, default: ""
#' @keywords Process Image
#' @export
#' @references \url{http://ocrsdk.com/documentation/specifications/image-formats/}
#' @references \url{http://ocrsdk.com/documentation/apireference/processImage/}
#' @examples
#' processImage(file_path="file_path", language="English", profile="documentConversion",textType="normal", imageSource="auto", correctOrientation="true", correctSkew="true", readBarcodes,exportFormat="txt",description="", pdfPassword="")

processImage <- function(file_path=NULL, language="English", profile="documentConversion",textType="normal", imageSource="auto", correctOrientation="true", 
						correctSkew="true",readBarcodes="false",exportFormat="txt", description="", pdfPassword=""){
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	if(is.null(file_path)) stop("Must specify file_path")
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	querylist = list(file_path=file_path, language=language, profile=profile,textType=textType, imageSource=imageSource, correctOrientation=correctOrientation, 
						correctSkew=correctSkew,readBarcodes,exportFormat="txt", description="", pdfPassword="")
	res <- httr::POST(paste0("http://",app_id,":",app_pass,"@cloud.ocrsdk.com/processImage"), query=querylist, body=httr::upload_file(file_path))
	httr::stop_for_status(res)
	processdetails <- XML::xmlToList(httr::content(res))
	
	resdf <- do.call(rbind.data.frame, processdetails) # collapse to a data.frame
	names(resdf) <- names(processdetails[[1]])[1:length(resdf)] # names for the df, adjust for <7
	row.names(resdf) <- 1:nrow(resdf)	# row.names for the df

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")

	return(invisible(resdf))
}

#' Process Remote Image
#'
#' This function gets Information about a particular application
#' @param language; optional, default: English
#' @param profile;   optional, default: documentConversion
#' @param textType;  optional, default: normal
#' @param imageSource;  optional, default: auto
#' @param correctOrientation;  optional, default: true
#' @param correctSkew;  optional, default: true
#' @param readBarcodes;  optional, default: 
#' @param exportFormat;  optional, default: txt
#' @param pdfPassword;  optional, default: NULL
#' @param description;  optional, default: ""
#' @keywords Process Remote Image
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/processRemoteImage/}
#' @examples
#' processRemoteImage(img_url="img_url")

processRemoteImage <- function(img_url=NULL, language="English", profile="documentConversion",textType="normal", imageSource="auto", correctOrientation="true", 
						correctSkew="true",readBarcodes="false",exportFormat="txt", description="", pdfPassword=""){
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	if(is.null(img_url)) stop("Must specify img_url")
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	querylist = list(img_url=img_url, language=language, profile=profile,textType=textType, imageSource=imageSource, correctOrientation=correctOrientation, 
						correctSkew=correctSkew,readBarcodes,exportFormat="txt", description="", pdfPassword="")
	res <- httr::POST(paste0("http://",app_id,":",app_pass,"@cloud.ocrsdk.com/processRemoteImage?source=",img_url))
	httr::stop_for_status(res)
	processdetails <- XML::xmlToList(httr::content(res))
	
	resdf <- do.call(rbind.data.frame, processdetails) # collapse to a data.frame
	names(resdf) <- names(processdetails[[1]])[1:length(resdf)] # names for the df, adjust for <7
	row.names(resdf) <- 1:nrow(resdf)	# row.names for the df

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")

	return(invisible(resdf))
}

#' Process Document 
#'
#' This function processes several images for the same task and results in a multi-page document. 
#' For instance, upload pages of the book individually via submitImage to the same task. And then process it via ProcessDocument to get a multi-page pdf.
#' @param taskId - Only tasks with Submitted, Completed or NotEnoughCredits status can be processed using this function.
#' @keywords Process Document 
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/processDocument/}
#' @examples
#' processDocument(taskId = "task_id")

processDocument <- function(taskId = NULL){
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	querylist = list(taskId = taskId)
	res <- httr::GET(paste0("http://",app_id,":",app_pass,"@cloud.ocrsdk.com/processDocument"), query=querylist)
	httr::stop_for_status(res)
	processdetails <- XML::xmlToList(httr::content(res))
	
	resdf <- do.call(rbind.data.frame, processdetails) # collapse to a data.frame
	names(resdf) <- names(processdetails[[1]])[1:length(resdf)] # names for the df, adjust for <7
	row.names(resdf) <- 1:nrow(resdf)	# row.names for the df

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")

	return(invisible(resdf))
}

#' Process Business Card
#'
#' This function gets Information about a particular application
#' @param app_id - get this from http://ocrsdk.com/. Set it before you use the package.
#' @param app_password - get this from http://ocrsdk.com/. Set it before you use the package. 
#' @keywords Application Information
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/processBusinessCard/}
#' @examples
#' processBusinessCard(language="English", profile="documentConversion",textType="normal", imageSource="auto", correctOrientation="true", correctSkew="true", readBarcodes,exportFormat="txt",description="", pdfPassword="", file_path="file_path")

processBusinessCard <- function(file_path=NULL){
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	if(is.null(file_path)) stop("Must specify file_path")
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	querylist = list(taskId = taskId)
	res <- httr::GET(paste0("http://",app_id,":",app_pass,"@cloud.ocrsdk.com/processBusinessCard"), query=querylist, body=upload_file(file_path))
	httr::stop_for_status(res)
	return(res)
}

#' Process Text Field
#'
#' This function gets Information about a particular application
#' @param app_id - get this from http://ocrsdk.com/. Set it before you use the package.
#' @param app_password - get this from http://ocrsdk.com/. Set it before you use the package. 
#' @keywords Application Information
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/processTextField/}
#' @examples
#' processTextField(language="English", profile="documentConversion",textType="normal", imageSource="auto", correctOrientation="true", correctSkew="true", readBarcodes,exportFormat="txt",description="", pdfPassword="", file_path="file_path")

processTextField <- function(file_path=NULL){
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	if(is.null(file_path)) stop("Must specify file_path")
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	querylist = list(taskId = taskId)
	res <- httr::GET(paste0("http://",app_id,":",app_pass,"@cloud.ocrsdk.com/processTextField"), query=querylist, body=upload_file(file_path))
	httr::stop_for_status(res)
	return(res)
}

#' Process Bar Code Field
#'
#' This function gets Information about a particular application
#' @param app_id - get this from http://ocrsdk.com/. Set it before you use the package.
#' @param app_password - get this from http://ocrsdk.com/. Set it before you use the package. 
#' @keywords Application Information
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/processBarcodeField/}
#' @examples
#' processBarcodeField()

processBarcodeField <- function(file_path=NULL){
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	if(is.null(file_path)) stop("Must specify file_path")
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	querylist = list(taskId = taskId)
	res <- httr::GET(paste0("http://",app_id,":",app_pass,"@cloud.ocrsdk.com/processBarcodeField"), query=querylist, body=upload_file(file_path))
	httr::stop_for_status(res)
	return(res)
}

#' processCheckmarkField Method
#'
#' This function gets Information about a particular application
#' @param app_id - get this from http://ocrsdk.com/. Set it before you use the package.
#' @param app_password - get this from http://ocrsdk.com/. Set it before you use the package. 
#' @keywords Application Information
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/processCheckmarkField/}
#' @examples
#' processCheckmarkField()

processCheckmarkField <- function(file_path=NULL){
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	if(is.null(file_path)) stop("Must specify file_path")
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	querylist = list(taskId = taskId)
	res <- httr::GET(paste0("http://",app_id,":",app_pass,"@cloud.ocrsdk.com/processCheckmarkField"), query=querylist, body=upload_file(file_path))
	httr::stop_for_status(res)
	return(res)
}

#' Process Fields
#'
#' This function gets Information about a particular application
#' @param app_id - get this from http://ocrsdk.com/. Set it before you use the package.
#' @param app_password - get this from http://ocrsdk.com/. Set it before you use the package. 
#' @keywords Application Information
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/processFields/}
#' @examples
#' processFields()

processFields <- function(file_path=NULL){
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	if(is.null(file_path)) stop("Must specify file_path")
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	querylist = list(taskId = taskId)
	res <- httr::GET(paste0("http://",app_id,":",app_pass,"@cloud.ocrsdk.com/processFields"))
	httr::stop_for_status(res)
	return(res)
}

#' Process MRZ: Extract data from Machine Readable Zone
#'
#' Extract data from Machine Readable Zone in an Image
#' @param app_id - get this from http://ocrsdk.com/. Set it before you use the package.
#' @param app_password - get this from http://ocrsdk.com/. Set it before you use the package. 
#' @keywords Application Information
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/processMRZ/}
#' @examples
#' processMRZ(file_path="file_path")

processMRZ <- function(file_path=NULL){
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	if(is.null(file_path)) stop("Must specify file_path")
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	querylist = list(taskId = taskId)
	res <- httr::GET(paste0("http://",app_id,":",app_pass,"@cloud.ocrsdk.com/processMRZ"), query=querylist, body=upload_file(file_path))
	httr::stop_for_status(res)
	tasklist <- XML::xmlToList(httr::content(res))
	return(res)
}

#' Process Photo ID
#'
#' This function gets Information about a particular application
#' @param app_id - get this from http://ocrsdk.com/. Set it before you use the package.
#' @param app_password - get this from http://ocrsdk.com/. Set it before you use the package. 
#' @keywords Application Information
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/processPhotoId/}
#' @examples
#' processPhotoId(file_path="file_path", idType="auto", imageSource="auto", correctOrientation="true", correctSkew="true", description="", pdfPassword="")

processPhotoId <- function(file_path=NULL, idType="auto", imageSource="auto", correctOrientation="true", correctSkew="true", description="", pdfPassword=""){
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	if(is.null(file_path)) stop("Must specify file_path")
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	querylist = list(idType=idType, imageSource=imageSource, correctOrientation=correctOrientation, correctSkew=correctSkew, description=description, pdfPassword=pdfPassword)
	res <- httr::GET(paste0("http://",app_id,":",app_pass,"@cloud.ocrsdk.com/processPhotoId"), query=querylist, body=upload_file(file_path))
	httr::stop_for_status(res)
	return(res)
}