"
Code for Using Abbyy Fine Cloud OCR SDK API from R

Part of abbyyR R package

To get app_id and app_password, go to:
http://ocrsdk.com/

@author: Gaurav Sood
"
#' \pkg{abbyyR} makes getting OCR easy.
#'
#' @name abbyyR
#' @docType package
NULL

#' Sets Application ID and Password
#'
#' Sets Application ID and Password. Needed for interfacing with Abbyy FineReader Cloud OCR SDK
#' @param appdetails - Required. A vector of app_id, app_password. Get these from \url{http://ocrsdk.com/}. Set them before you use other functions.
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
#' Get Information about the Application, such as number of pages (given the money), when the application credits expire etc. The function prints the details, and returns a list with the details.
#' @return A list with items including Name of the Application, No. of pages remaining (given the money), No. of fields remaining (given the money), and when the application credits expire. 
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/getApplicationInfo/}
#' @references \url{http://ocrsdk.com/schema/appInfo-1.0.xsd}
#' @usage getAppInfo()

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
#' The function prints Total number of tasks and No. of Finished Tasks. 
#' @param fromDate - optional;  format: yyyy-mm-ddThh:mm:ssZ
#' @param toDate - optional;  format: yyyy-mm-ddThh:mm:ssZ
#' @param excludeDeleted - optional; default='false'
#' @return A data frame with the following columns: id (task id), registrationTime, statusChangeTime, status 
#' 		   (Submitted, Queued, InProgress, Completed, ProcessingFailed, Deleted, NotEnoughCredits), filesCount (No. of files), credits, resultUrl (URL for the processed file)
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/getApplicationInfo/}
#' @usage listTasks(fromDate=NULL,toDate=NULL,excludeDeleted='false')

listTasks <- function(fromDate=NULL,toDate=NULL, excludeDeleted='false'){
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	
	querylist = list(fromDate = fromDate, toDate = toDate, excludeDeleted=excludeDeleted)
	res <- httr::GET(paste0("http://",app_id,":",app_pass,"@cloud.ocrsdk.com/listTasks"), query=querylist)
	httr::stop_for_status(res)
	tasklist <- XML::xmlToList(httr::content(res))

	if(is.null(tasklist)){
		cat("No tasks in the application. \n")
		return(invisible(NULL))
	}

	# Converting list to a data.frame
	lenitem <- sapply(tasklist, length) # length of each list item
	resdf <- do.call(rbind.data.frame, tasklist) # collapse to a data.frame, wraps where lenitems < longest list (7)
	names(resdf) <- names(tasklist[[1]]) # names for the df
	row.names(resdf) <- 1:nrow(resdf)	# row.names for the df
	resdf[lenitem == 6,7] <- NA 		# Fill NAs where lenitems falls short

	# Print some important things
	cat("Total No. of Tasks: ", nrow(resdf), "\n")
	cat("No. of Finished Tasks: ", sum(lenitem==7), "\n")
  
  	# Return the data.frame
	return(invisible(resdf))
}

#' List Finished Tasks
#'
#' List all the finished tasks in the application. 
#' From Abbyy FineReader: The tasks are ordered by the time of the end of processing. No more than 100 tasks can be returned at one method call. 
#' The function prints number of finished tasks by default
#' @return A data frame with the following columns: id (task id), registrationTime, statusChangeTime, status (Completed), filesCount (No. of files), credits, resultUrl (URL for the processed file)
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/listFinishedTasks/}
#' @usage listFinishedTasks()

listFinishedTasks <- function(){
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	
	res <- httr::GET(paste0("http://",app_id,":",app_pass,"@cloud.ocrsdk.com/listFinishedTasks"))
	httr::stop_for_status(res)
	tasklist <- XML::xmlToList(httr::content(res))

	if(is.null(tasklist)){
		cat("No finished tasks in the application. \n")
		return(invisible(NULL))
	}

	resdf <- do.call(rbind.data.frame, tasklist) # collapse to a data.frame, wraps where lenitems < longest list (7)
	names(resdf) <- names(tasklist[[1]]) # names for the df
	row.names(resdf) <- 1:nrow(resdf)	# row.names for the df

	# Print some important things
	cat("No. of Finished Tasks: ", nrow(resdf), "\n")

	return(invisible(resdf))
}


#' Get Results
#'
#' Get data from all the processed images.
#' The function goes through the finishedTasks data frame and downloads all the files in resultsUrl
#' @param output Optional; folder to which you want to save the data from the processed images; Default is same folder as the script
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/getTaskStatus/}
#' @usage getResults(output="")

getResults <- function(output=""){
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	
	finishedlist <- listFinishedTasks()
	
	for(i in 1:nrow(finishedlist)){
		#RCurl::getURLContent(finishedlist$resultUrl[i], ssl.verifypeer = FALSE, useragent = "R")
		#httr::getURL(ssl.verifypeer = FALSE)
		download.file(finishedlist$resultUrl[i],destfile=paste0(output, finishedlist$id[i]), method="curl")
	}
}

#' Get Task Status
#'
#' This function gets task status for a particular task ID.
#' The function prints the status of the task by default.
#' The function returns a data.frame with all the task details: id (task id), registrationTime, statusChangeTime, status (Submitted, Queued, InProgress, Completed, ProcessingFailed, Deleted, NotEnoughCredits), filesCount (No. of files), credits, resultUrl (URL for the processed file if applicable)
#' @param taskId -id of the task; required
#' @return A data frame with all the available details about the task
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/getTaskStatus/}
#' @examples
#' # getTaskStatus(taskId="task_id")

getTaskStatus <- function(taskId=NULL){
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	
	if(is.null(taskId)) stop("Must specify taskId")
	
	querylist = list(taskId = taskId)
	res <- httr::GET(paste0("http://",app_id,":",app_pass,"@cloud.ocrsdk.com/getTaskStatus"), query=querylist)
	httr::stop_for_status(res)
	taskdetails <- XML::xmlToList(httr::content(res))
	
	resdf <- do.call(rbind.data.frame, taskdetails) # collapse to a data.frame
	names(resdf) <- names(taskdetails[[1]])  
	row.names(resdf) <- 1	# row.names for the df

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")

	return(invisible(resdf))
}

#' Delete Task
#'
#' This function deletes a particular task and associated data. From Abbyy "If you try to delete the task that has already been deleted, the successful response is returned."
#' The function by default prints the status of the task you are trying to delete. It will show up as 'deleted' if successful
#' @param taskId id of the task; required
#' @return Data frame with all the details of the task you are trying to delete: id (task id), registrationTime, statusChangeTime, status (Submitted, Queued, InProgress, Completed, ProcessingFailed, Deleted, NotEnoughCredits), filesCount (No. of files), credits, resultUrl (URL for the processed file if applicable)
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/deleteTask/}
#' @examples
#' # deleteTask(taskId="task_id")

deleteTask <- function(taskId=NULL){
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	
	if(is.null(taskId)) stop("Must specify taskId")

	querylist = list(taskId = taskId)
	res <- httr::GET(paste0("https://",app_id,":",app_pass,"@cloud.ocrsdk.com/deleteTask"), query=querylist)
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
#' @param file_path Required; Path to the document
#' @param taskId    Optional; Assigns image to the task ID specified. If an empty string is passed, a new task is created. 
#' @param pdfPassword Optional; If the pdf is password protected, put the password here.
#' @return Data frame with all the details of the submitted image: id (task id), registrationTime, statusChangeTime, status (Submitted, Queued, InProgress, Completed, ProcessingFailed, Deleted, NotEnoughCredits), filesCount (No. of files), credits
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/submitImage/}
#' @examples
#' # submitImage(file_path="/images/image1.png",taskId="task_id",pdfPassword="pdf_password")

submitImage <- function(file_path=NULL, taskId="", pdfPassword=""){
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	
	if(is.null(file_path)) stop("Must specify file_path")
	
	# The API doesn't handle taskId="" and that is just as well as new task is created
	if(taskId=="") querylist = list(pdfPassword=pdfPassword)
	else querylist = list(taskId = taskId, pdfPassword=pdfPassword)
	
	res <- httr::POST(paste0("http://",app_id,":",app_pass,"@cloud.ocrsdk.com/submitImage"), query=querylist, body=httr::upload_file(file_path))
	httr::stop_for_status(res)
	submitdetails <- XML::xmlToList(httr::content(res))
	
	resdf <- do.call(rbind.data.frame, submitdetails) # collapse to a data.frame
	names(resdf) <- names(submitdetails[[1]])
	row.names(resdf) <- 1

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")
	cat("Task ID: ", 			resdf$id, "\n")

	return(invisible(resdf))
}

#' Process Image
#'
#' This function processes an image
#' @param file_path path to the document
#' @param language optional, default: English
#' @param profile   optional, default: documentConversion
#' @param textType  optional, default: normal
#' @param imageSource  optional, default: auto
#' @param correctOrientation  optional, default: true
#' @param correctSkew  optional, default: true
#' @param readBarcodes  optional, default: 
#' @param exportFormat  optional, default: txt
#' @param pdfPassword  optional, default: NULL
#' @param description  optional, default: ""
#' @return Data frame with details of the task associated with the submitted Image
#' @export
#' @references \url{http://ocrsdk.com/documentation/specifications/image-formats/}
#' @references \url{http://ocrsdk.com/documentation/apireference/processImage/}
#' @examples
#' # processImage(file_path="file_path", language="English")

processImage <- function(file_path=NULL, language="English", profile="documentConversion",textType="normal", imageSource="auto", correctOrientation="true", 
						correctSkew="true",readBarcodes="false",exportFormat="txt", description="", pdfPassword=""){
	
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	
	if(is.null(file_path)) stop("Must specify file_path")

	querylist = list(language=language, profile=profile,textType=textType, imageSource=imageSource, correctOrientation=correctOrientation, 
						correctSkew=correctSkew,readBarcodes=readBarcodes,exportFormat=exportFormat, description=description, pdfPassword=pdfPassword)

	res <- httr::POST(paste0("http://",app_id,":",app_pass,"@cloud.ocrsdk.com/processImage"), query=querylist, body=httr::upload_file(file_path))
	httr::stop_for_status(res)
	processdetails <- XML::xmlToList(httr::content(res))
	
	resdf <- do.call(rbind.data.frame, processdetails) # collapse to a data.frame
	names(resdf) <- names(processdetails[[1]])
	row.names(resdf) <- 1:nrow(resdf)	# row.names for the df

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")
	cat("Task ID: ", 			resdf$id, "\n")

	return(invisible(resdf))
}

#' Process Remote Image
#'
#' This function gets Information about a particular application
#' @param img_url   Required; url to remote image
#' @param language  Optional; default: English
#' @param profile   Optional; default: documentConversion
#' @param textType  Optional; default: normal
#' @param imageSource  Optional; default: auto
#' @param correctOrientation  Optional; default: true
#' @param correctSkew Optional; default: true
#' @param readBarcodes  Optional; default: 
#' @param exportFormat  Optional; default: txt
#' @param pdfPassword  Optional; default: NULL
#' @param description  Optional; default: ""
#' @return Data frame with details of the task associated with the submitted Remote Image
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/processRemoteImage/}
#' @examples
#' # processRemoteImage(img_url="img_url")

processRemoteImage <- function(img_url=NULL, language="English", profile="documentConversion",textType="normal", imageSource="auto", correctOrientation="true", 
						correctSkew="true",readBarcodes="false",exportFormat="txt", description=NULL, pdfPassword=NULL){
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	
	if(is.null(img_url)) stop("Must specify img_url")

	querylist = list(source=img_url, language=language, profile=profile,textType=textType, imageSource=imageSource, correctOrientation=correctOrientation, 
						correctSkew=correctSkew,readBarcodes=readBarcodes,exportFormat=exportFormat, description=description, pdfPassword=pdfPassword)
	res <- httr::GET(paste0("http://",app_id,":",app_pass,"@cloud.ocrsdk.com/processRemoteImage"), query=querylist)
	httr::stop_for_status(res)
	processdetails <- XML::xmlToList(httr::content(res))
	
	resdf <- do.call(rbind.data.frame, processdetails) # collapse to a data.frame
	names(resdf) <- names(processdetails[[1]])
	row.names(resdf) <- 1	# row.names for the df

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")
	cat("Task ID: ", 			resdf$id, "\n")

	return(invisible(resdf))
}

#' Process Document 
#'
#' This function processes several images for the same task and results in a multi-page document. 
#' For instance, upload pages of the book individually via submitImage to the same task. And then process it via ProcessDocument to get a multi-page pdf.
#' @param taskId - Only tasks with Submitted, Completed or NotEnoughCredits status can be processed using this function.
#' @param language  Optional; default: English
#' @param profile   Optional; default: documentConversion
#' @param textType  Optional; default: normal
#' @param imageSource  Optional; default: auto
#' @param correctOrientation  Optional; default: true
#' @param correctSkew Optional; default: true
#' @param readBarcodes  Optional; default: 
#' @param exportFormat  Optional; default: txt
#' @param pdfPassword  Optional; default: NULL
#' @param description  Optional; default: ""
#' @return Data frame with details of the task associated with the submitted Document
#' @export 
#' @references \url{http://ocrsdk.com/documentation/apireference/processDocument/}
#' @examples
#' # processDocument(taskId = "task_id")

processDocument <- function(taskId = NULL, language="English", profile="documentConversion",textType="normal", imageSource="auto", correctOrientation="true", 
						correctSkew="true",readBarcodes="false",exportFormat="txt", description=NULL, pdfPassword=NULL){
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	
	querylist = list(taskId = taskId, language=language, profile=profile,textType=textType, imageSource=imageSource, correctOrientation=correctOrientation, 
						correctSkew=correctSkew,readBarcodes=readBarcodes,exportFormat=exportFormat, description=description, pdfPassword=pdfPassword)
	res <- httr::GET(paste0("http://",app_id,":",app_pass,"@cloud.ocrsdk.com/processDocument"), query=querylist)
	httr::stop_for_status(res)
	processdetails <- XML::xmlToList(httr::content(res))
	
	resdf <- do.call(rbind.data.frame, processdetails) # collapse to a data.frame
	names(resdf) <- names(processdetails[[1]])
	row.names(resdf) <- 1:nrow(resdf)	# row.names for the df

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")

	return(invisible(resdf))
}

#' Process Business Card
#'
#' This function gets Information about a particular application
#' @param file_path path of the document
#' @param language optional, default: English
#' @param imageSource  optional, default: auto
#' @param correctOrientation  optional, default: true
#' @param correctSkew optional, default: true
#' @param exportFormat  optional, default: "vCard"
#' @param pdfPassword  optional, default: NULL
#' @param description  optional, default: ""
#' @keywords Process Remote Image
#' @return Data frame with details of the task associated with the submitted Business Card
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/processBusinessCard/}
#' @examples
#' # processBusinessCard(file_path="file_path", language="English")

processBusinessCard <- function(file_path=NULL, language="English", imageSource="auto", correctOrientation="true", 
						correctSkew="true",exportFormat="vCard", description="", pdfPassword=""){

	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	
	if(is.null(file_path)) stop("Must specify file_path")
	querylist = list(language=language, imageSource=imageSource, correctOrientation=correctOrientation, 
						correctSkew=correctSkew,exportFormat="vCard", description="", pdfPassword="")
	res <- httr::GET(paste0("http://",app_id,":",app_pass,"@cloud.ocrsdk.com/processBusinessCard"), query=querylist, body=httr::upload_file(file_path))
	httr::stop_for_status(res)
	processdetails <- XML::xmlToList(httr::content(res))
	
	resdf <- do.call(rbind.data.frame, processdetails) # collapse to a data.frame
	names(resdf) <- names(processdetails[[1]])[1:length(resdf)] # names for the df, adjust for <7
	row.names(resdf) <- 1:nrow(resdf)	# row.names for the df

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")

	return(invisible(resdf))
}

#' Process Text Field
#'
#' This function gets Information about a particular application
#' @param file_path path of the document
#' @param region coordinates of region from top left, 4 values: top left bottom right; optional; default: "-1,-1,-1,-1" (entire image) 
#' @param language optional; default: "English"
#' @param letterSet letterset to be used for recognition, set by language but can be customized; optional; default: ""
#' @param regExp which words are allowed in the field. see regular expression documentation; optional; default: ""
#' @param textType type of the text in the field including typewriter, handprinted; optional; default: "normal"
#' @param oneTextLine field contains only one text line or more; optional; default: "false"
#' @param oneWordPerTextLine field contains one word per line or not; optional; default: "false"
#' @param markingType only for handprint recognition, includes underlinedText etc.; optional; default: "simpleText"
#' @param placeholdersCount No. of character cells for the field; optional; default: "1"
#' @param writingStyle handprint writing style, see Abbyy FineReader documentation for values; optional; default: "default"
#' @param description Description of processing task; optional; default: ""
#' @param pdfPassword Password for pdf; optional; default: ""
#' @return Data frame with details of the task associated with the submitted Image
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/processTextField/}
#' @references \url{http://ocrsdk.com/documentation/specifications/regular-expressions/}
#' @examples
#' # processTextField(file_path="file_path")

processTextField <- function(file_path=NULL, region=c(-1,-1,-1,-1), language="English", letterSet="", regExp="", textType="normal", oneTextLine="false", oneWordPerTextLine="false", 
							 markingType="simpleText", placeholdersCount="1", writingStyle="default", description="",pdfPassword=""){
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	
	if(is.null(file_path)) stop("Must specify file_path")
	querylist = list(language=language, letterSet=letterSet, regExp=regExp, textType=textType, oneTextLine=oneTextLine, oneWordPerTextLine=oneWordPerTextLine, 
							 markingType=markingType, placeholdersCount=placeholdersCount, writingStyle=writingStyle, description=description,pdfPassword=pdfPassword)
	res <- httr::POST(paste0("http://",app_id,":",app_pass,"@cloud.ocrsdk.com/processTextField"), query=querylist, body=httr::upload_file(file_path))
	httr::stop_for_status(res)
	processdetails <- XML::xmlToList(httr::content(res))
	
	resdf <- do.call(rbind.data.frame, processdetails) # collapse to a data.frame
	names(resdf) <- names(processdetails[[1]])[1:length(resdf)] # names for the df, adjust for <7
	row.names(resdf) <- 1:nrow(resdf)	# row.names for the df

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")

	return(invisible(resdf))
}

#' Process Bar Code Field
#'
#' This function gets Information about a particular application
#' @param file_path path of the document
#' @param barcodeType optional, default: "autodetect"
#' @param region coordinates of region from top left, 4 values: top left bottom right; optional; default: "-1,-1,-1,-1" (entire image) 
#' @param containsBinaryData   optional, default: "false"
#' @param pdfPassword  optional, default: ""
#' @param description  optional, default: ""
#' @return Data frame with details of the task associated with the submitted Image
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/processBarcodeField/}
#' @examples
#' # processBarcodeField(file_path="file_path")

processBarcodeField <- function(file_path=NULL, barcodeType="autodetect", region=c(-1,-1,-1,-1),containsBinaryData="false",pdfPassword="",description=""){
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	
	if(is.null(file_path)) stop("Must specify file_path")

	querylist = list(barcodeType=barcodeType, region=region,containsBinaryData=containsBinaryData,pdfPassword=pdfPassword,description=description)
	res <- httr::POST(paste0("http://",app_id,":",app_pass,"@cloud.ocrsdk.com/processBarcodeField"), query=querylist, body=httr::upload_file(file_path))
	httr::stop_for_status(res)
	processdetails <- XML::xmlToList(httr::content(res))
	
	resdf <- do.call(rbind.data.frame, processdetails) # collapse to a data.frame
	names(resdf) <- names(processdetails[[1]])[1:length(resdf)] # names for the df, adjust for <7
	row.names(resdf) <- 1:nrow(resdf)	# row.names for the df

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")

	return(invisible(resdf))
}

#' processCheckmarkField Method
#'
#' This function gets Information about a particular application
#' @param file_path path of the document
#' @param checkmarkType optional, default: "empty"
#' @param region coordinates of region from top left, 4 values: top left bottom right; optional; default: "-1,-1,-1,-1" (entire image) 
#' @param correctionAllowed  optional, default: "false"
#' @param pdfPassword  optional, default: ""
#' @param description  optional, default: ""
#' @return Data frame with details of the task associated with the submitted Image
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/processCheckmarkField/}
#' @examples
#' # processCheckmarkField(file_path="file_path")

processCheckmarkField <- function(file_path=NULL,checkmarkType="empty",  region=c(-1,-1,-1,-1),correctionAllowed="false", pdfPassword="",description=""){
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	
	if(is.null(file_path)) stop("Must specify file_path")

	querylist = list(checkmarkType=checkmarkType, region=region,correctionAllowed=correctionAllowed,pdfPassword=pdfPassword,description=description)
	res <- httr::POST(paste0("http://",app_id,":",app_pass,"@cloud.ocrsdk.com/processCheckmarkField"), query=querylist, body=httr::upload_file(file_path))
	httr::stop_for_status(res)
	processdetails <- XML::xmlToList(httr::content(res))
	
	resdf <- do.call(rbind.data.frame, processdetails) # collapse to a data.frame
	names(resdf) <- names(processdetails[[1]])[1:length(resdf)] # names for the df, adjust for <7
	row.names(resdf) <- 1:nrow(resdf)	# row.names for the df

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")

	return(invisible(resdf))
}

#' Process Fields
#'
#' This function gets Information about a particular application
#' @param file_path path of the document
#' @param taskId - Only tasks with Submitted, Completed or NotEnoughCredits status can be processed using this function.
#' @param description  optional, default: ""
#' @return Data frame with details of the task associated with the submitted Image
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/processFields/}
#' @examples
#' # processFields(file_path="file_path", taskId="task_id",description="")

processFields <- function(file_path=NULL,taskId=NULL,description=""){
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	
	if(is.null(file_path)) stop("Must specify file_path")

	querylist = list(taskId = taskId, description=description)
	res <- httr::POST(paste0("http://",app_id,":",app_pass,"@cloud.ocrsdk.com/processFields"), query=querylist, body=httr::upload_file(file_path))
	httr::stop_for_status(res)
	processdetails <- XML::xmlToList(httr::content(res))
	
	resdf <- do.call(rbind.data.frame, processdetails) # collapse to a data.frame
	names(resdf) <- names(processdetails[[1]])[1:length(resdf)] # names for the df, adjust for <7
	row.names(resdf) <- 1:nrow(resdf)	# row.names for the df

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")

	return(invisible(resdf))
}

#' Process MRZ: Extract data from Machine Readable Zone
#'
#' Extract data from Machine Readable Zone in an Image
#' @param file_path path to the document
#' @return Data frame with details of the task associated with the submitted MRZ document
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/processMRZ/}
#' @examples
#' # processMRZ(file_path="file_path")

processMRZ <- function(file_path=NULL){
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	
	if(is.null(file_path)) stop("Must specify file_path")

	res <- httr::POST(paste0("http://",app_id,":",app_pass,"@cloud.ocrsdk.com/processMRZ"), body=httr::upload_file(file_path))
	httr::stop_for_status(res)
	tasklist <- XML::xmlToList(httr::content(res))
	processdetails <- XML::xmlToList(httr::content(res))
	
	resdf <- do.call(rbind.data.frame, processdetails) # collapse to a data.frame
	names(resdf) <- names(processdetails[[1]])[1:length(resdf)] # names for the df, adjust for <7
	row.names(resdf) <- 1:nrow(resdf)	# row.names for the df

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")

	return(invisible(resdf))
}

#' Process Photo ID
#'
#' This function gets Information about a particular application
#' @param file_path path to file; required
#' @param idType optional; default = "auto"
#' @param imageSource optional; default = "auto"
#' @param correctOrientation optional; default = "true"
#' @param correctSkew optional; default = "true"
#' @param description optional; default = ""
#' @param pdfPassword optional; default = ""
#' @return Data frame with details of the task associated with the submitted Photo ID image 
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/processPhotoId/}
#' @examples
#' # processPhotoId(file_path="file_path", idType="auto", imageSource="auto")

processPhotoId <- function(file_path=NULL, idType="auto", imageSource="auto", correctOrientation="true", correctSkew="true", description="", pdfPassword=""){
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	
	if(is.null(file_path)) stop("Must specify file_path")

	querylist = list(idType=idType, imageSource=imageSource, correctOrientation=correctOrientation, correctSkew=correctSkew, description=description, pdfPassword=pdfPassword)
	res <- httr::POST(paste0("http://",app_id,":",app_pass,"@cloud.ocrsdk.com/processPhotoId"), query=querylist, body=httr::upload_file(file_path))
	httr::stop_for_status(res)
	processdetails <- XML::xmlToList(httr::content(res))
	
	resdf <- do.call(rbind.data.frame, processdetails) # collapse to a data.frame
	names(resdf) <- names(processdetails[[1]])
	row.names(resdf) <- 1

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")

	return(invisible(resdf))
}