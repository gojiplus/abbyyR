"
Code for Using Abbyy Fine Cloud OCR SDK

To get app_id and app_password, go to:
http://ocrsdk.com/

@author: Gaurav Sood
"

#' Get Application Info
#'
#' This function gets Information about a particular application
#' @param app_id - get this from http://ocrsdk.com/. Set it before you use the package.
#' @param app_password - get this from http://ocrsdk.com/. Set it before you use the package. 
#' @keywords Application Information
#' @export
#' @references \url{http://dhttp://ocrsdk.com/documentation/apireference/getApplicationInfo/}
#' @references \url{http://ocrsdk.com/schema/appInfo-1.0.xsd}
#' @examples
#' getAppInfo(app_id=app_id, app_password=app_password)

getAppInfo <- function(app_id=app_id, app_password=app_password){
	res <- httr::GET(paste0("http://",app_id,":",app_password,"@cloud.ocrsdk.com/getApplicationInfo"))
	stop_for_status(res)
	xmlToList(content(res))
}

#' @export
print.getAppInfo <- function(x, ...){
  cat("Name of Application: ", x[[1]]$name, "\n", sep = "")
  cat("No. of Pages Remaining: ", x[[1]]$pages, "\n", sep = "")
  cat("No. of Fields Remaining: ", x[[1]]$fields, "\n", sep = "")
  cat("Application Credits Expire on: ", x[[1]]$expires, "\n", sep = "")
  cat("Type: ", x[[1]]$type, "\n", sep = "")
}

#' Submit Image
#'
#' Adds image to the existing task or creates a new task for the uploaded image. The new task isn't processed till processDocument or processFields is called.
#' @param taskId - Optional.
#' @param pdfPassword - Optional. If the pdf is password protected, put the password here.
#' @keywords Submit Image
#' @export
#' @references \url{http://dhttp://ocrsdk.com/documentation/apireference/submitImage/}
#' @examples
#' submitImage(file_path,taskId,pdfPassword)

submitImage <- function(app_id=app_id, app_password=app_password, file_path){
	httr::GET(paste0("http://",app_id,":",app_password,"@cloud.ocrsdk.com/submitImage"), body=upload_file(file_path))
}

#' Process Remote Image
#'
#' This function gets Information about a particular application
#' @param app_id - get this from http://ocrsdk.com/. Set it before you use the package.
#' @param app_password - get this from http://ocrsdk.com/. Set it before you use the package. 
#' @keywords Application Information
#' @export
#' @references \url{http://dhttp://ocrsdk.com/documentation/apireference/processRemoteImage/}
#' @examples
#' processRemoteImage(app_id=app_id, app_password=app_password, img_url)
processRemoteImage <- function(app_id=app_id, app_password=app_password, img_url){
	httr::GET(paste0("http://",app_id,":",app_password,"@cloud.ocrsdk.com/processRemoteImage?source=",img_url))
}

#' Process Image
#'
#' This function processes an image
#' @param language; default: English
#' @param profile;  default: documentConversion
#' @param textType; default: normal
#' @param imageSource; default: auto
#' @param correctOrientation; default: true
#' @param correctSkew; default: true
#' @param readBarcodes; default: 
#' @param exportFormat; default: txt
#' @param pdfPassword; default: 
#' @param description; default: 
#' @keywords Application Information
#' @export
#' @references \url{http://dhttp://ocrsdk.com/documentation/apireference/processImage/}
#' @examples
#' processImage(language="English", profile="documentConversion",textType="normal", imageSource="auto", correctOrientation="true", correctSkew="true",readBarcodes,exportFormat="txt",description="", pdfPassword="", file_path="file_path")

processImage <- function(app_id=app_id, app_password=app_password,language="English", profile="documentConversion",textType="normal", 
						imageSource="auto", correctOrientation="true", correctSkew="true",readBarcodes,exportFormat="txt",description="", pdfPassword="", file_path){
	httr::GET(paste0("http://",app_id,":",app_password,"@cloud.ocrsdk.com/processImage"), body=upload_file(file_path))
}

#' Process Document 
#'
#' This function processes several images
#' @param app_id - get this from http://ocrsdk.com/. Set it before you use the package.
#' @param app_password - get this from http://ocrsdk.com/. Set it before you use the package. 
#' @keywords Application Information
#' @export
#' @examples
#' processDocument(app_id=app_id, app_password=app_password)

processDocument <- function(app_id=app_id, app_password=app_password){
	httr::GET(paste0("http://",app_id,":",app_password,"@cloud.ocrsdk.com/processDocument"))
}

#' Process Business Card
#'
#' This function gets Information about a particular application
#' @param app_id - get this from http://ocrsdk.com/. Set it before you use the package.
#' @param app_password - get this from http://ocrsdk.com/. Set it before you use the package. 
#' @keywords Application Information
#' @export
#' @examples
#' processBusinessCard(app_id=app_id, app_password=app_password)

processBusinessCard <- function(app_id=app_id, app_password=app_password){
	httr::GET(paste0("http://",app_id,":",app_password,"@cloud.ocrsdk.com/processBusinessCard"))
}

#' Process Text Field
#'
#' This function gets Information about a particular application
#' @param app_id - get this from http://ocrsdk.com/. Set it before you use the package.
#' @param app_password - get this from http://ocrsdk.com/. Set it before you use the package. 
#' @keywords Application Information
#' @export
#' @examples
#' processTextField(app_id=app_id, app_password=app_password)

processTextField <- function(app_id=app_id, app_password=app_password){
	httr::GET(paste0("http://",app_id,":",app_password,"@cloud.ocrsdk.com/processTextField"))
}

#' Process Bar Code Field
#'
#' This function gets Information about a particular application
#' @param app_id - get this from http://ocrsdk.com/. Set it before you use the package.
#' @param app_password - get this from http://ocrsdk.com/. Set it before you use the package. 
#' @keywords Application Information
#' @export
#' @examples
#' processBarcodeField(app_id=app_id, app_password=app_password)

processBarcodeField <- function(app_id=app_id, app_password=app_password){
	httr::GET(paste0("http://",app_id,":",app_password,"@cloud.ocrsdk.com/processBarcodeField"))
}

#' processCheckmarkField Method
#'
#' This function gets Information about a particular application
#' @param app_id - get this from http://ocrsdk.com/. Set it before you use the package.
#' @param app_password - get this from http://ocrsdk.com/. Set it before you use the package. 
#' @keywords Application Information
#' @export
#' @examples
#' processCheckmarkField(app_id=app_id, app_password=app_password)

processCheckmarkField <- function(app_id=app_id, app_password=app_password){
	httr::GET(paste0("http://",app_id,":",app_password,"@cloud.ocrsdk.com/processCheckmarkField"))
}

#' Process Fields
#'
#' This function gets Information about a particular application
#' @param app_id - get this from http://ocrsdk.com/. Set it before you use the package.
#' @param app_password - get this from http://ocrsdk.com/. Set it before you use the package. 
#' @keywords Application Information
#' @export
#' @examples
#' processFields(app_id=app_id, app_password=app_password)


processFields <- function(app_id=app_id, app_password=app_password){
	httr::GET(paste0("http://",app_id,":",app_password,"@cloud.ocrsdk.com/processFields"))
}

#' Process MRZ
#'
#' This function gets Information about a particular application
#' @param app_id - get this from http://ocrsdk.com/. Set it before you use the package.
#' @param app_password - get this from http://ocrsdk.com/. Set it before you use the package. 
#' @keywords Application Information
#' @export
#' @examples
#' processMRZ(app_id=app_id, app_password=app_password)


processMRZ <- function(app_id=app_id, app_password=app_password){
	httr::GET(paste0("http://",app_id,":",app_password,"@cloud.ocrsdk.com/processMRZ"))
}

#' Process Photo ID
#'
#' This function gets Information about a particular application
#' @param app_id - get this from http://ocrsdk.com/. Set it before you use the package.
#' @param app_password - get this from http://ocrsdk.com/. Set it before you use the package. 
#' @keywords Application Information
#' @export
#' @examples
#' processPhotoId(app_id=app_id, app_password=app_password)


processPhotoId <- function(app_id=app_id, app_password=app_password){
	httr::GET(paste0("http://",app_id,":",app_password,"@cloud.ocrsdk.com/processPhotoId"))
}

#' List Tasks
#'
#' This function gets Information about a particular application
#' @param fromDate; not required;  format: yyyy-mm-ddThh:mm:ssZ
#' @param toDate; not required;  format: yyyy-mm-ddThh:mm:ssZ
#' @param excludeDeleted; not required; default='false'
#' @keywords List Tasks
#' @export
#' @examples
#' listTasks(app_id=app_id, app_password=app_password,fromDate,toDate,excludeDeleted)

listTasks <- function(app_id=app_id, app_password=app_password,fromDate,toDate,excludeDeleted){
	httr::GET(paste0("http://",app_id,":",app_password,"@cloud.ocrsdk.com/listTasks"))
}

#' List Finished Tasks
#'
#' This function gets Information about a particular application
#' @keywords Finished Tasks
#' @export
#' @examples
#' listFinishedTasks(app_id=app_id, app_password=app_password)

listFinishedTasks <- function(app_id=app_id, app_password=app_password){
	httr::GET(paste0("http://",app_id,":",app_password,"@cloud.ocrsdk.com/listFinishedTasks"))
}

#' Get Task Status
#'
#' This function gets Information about a particular application
#' @param taskId
#' @keywords Task Status
#' @export
#' @examples
#' getTaskStatus(app_id=app_id, app_password=app_password, taskId)

getTaskStatus <- function(app_id=app_id, app_password=app_password, taskId){
	httr::GET(paste0("http://",app_id,":",app_password,"@cloud.ocrsdk.com/getTaskStatus"))
}

#' Delete Task
#'
#' This function deletes the given task and the images associated with this task.
#' @param taskId
#' @keywords Delete Task
#' @export
#' @examples
#' deleteTask(app_id=app_id, app_password=app_password, taskId)

deleteTask <- function(app_id=app_id, app_password=app_password, taskId){
	httr::POST(paste0("http://",app_id,":",app_password,"@cloud.ocrsdk.com/deleteTask"))
}