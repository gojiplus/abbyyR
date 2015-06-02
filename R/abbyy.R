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
#' @examples
#' getAppInfo()

getAppInfo <- function(app_id=app_id, app_password=app_password){
	httr::GET(paste0("http://",app_id,":",app_password,"@cloud.ocrsdk.com/getApplicationInfo"))
}

#' Submit Image
#'
#' Adds image to the existing task or creates a new task for the uploaded image. The new task isn't processed till processDocument or processFields is called.
#' @param taskId - Optional.
#' @param pdfPassword - Optional. If the pdf is password protected, put the password here.
#' @keywords Submit Image
#' @export
#' @examples
#' getAppInfo(file_path,taskId,pdfPassword)

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
#' @examples
#' getAppInfo(img_url)
processRemoteImage <- function(app_id=app_id, app_password=app_password, img_url){
	httr::GET(paste0("http://",app_id,":",app_password,"@cloud.ocrsdk.com/processRemoteImage?source=",img_url))
}

#' List Tasks
#'
#' This function gets Information about a particular application
#' @param app_id - get this from http://ocrsdk.com/. Set it before you use the package.
#' @param app_password - get this from http://ocrsdk.com/. Set it before you use the package. 
#' @keywords Application Information
#' @export
#' @examples
#' listTasks()

listTasks <- function(app_id=app_id, app_password=app_password){
	httr::GET(paste0("http://",app_id,":",app_password,"@cloud.ocrsdk.com/listTasks"))
}

#' List Finished Tasks
#'
#' This function gets Information about a particular application
#' @param app_id - get this from http://ocrsdk.com/. Set it before you use the package.
#' @param app_password - get this from http://ocrsdk.com/. Set it before you use the package. 
#' @keywords Application Information
#' @export
#' @examples
#' listFinishedTasks()

listFinishedTasks <- function(app_id=app_id, app_password=app_password){
	httr::GET(paste0("http://",app_id,":",app_password,"@cloud.ocrsdk.com/listFinishedTasks"))
}

#' Process Image
#'
#' This function gets Information about a particular application
#' @param app_id - get this from http://ocrsdk.com/. Set it before you use the package.
#' @param app_password - get this from http://ocrsdk.com/. Set it before you use the package. 
#' @keywords Application Information
#' @export
#' @examples
#' processImage()

processImage <- function(app_id=app_id, app_password=app_password){
	httr::GET(paste0("http://",app_id,":",app_password,"@cloud.ocrsdk.com/processImage"))
}

#' Process Document
#'
#' This function gets Information about a particular application
#' @param app_id - get this from http://ocrsdk.com/. Set it before you use the package.
#' @param app_password - get this from http://ocrsdk.com/. Set it before you use the package. 
#' @keywords Application Information
#' @export
#' @examples
#' processDocument()

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
#' processBusinessCard()

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
#' processTextField()

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
#' processBarcodeField()

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
#' processCheckmarkField()

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
#' processFields()


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
#' processMRZ()


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
#' processPhotoId()


processPhotoId <- function(app_id=app_id, app_password=app_password){
	httr::GET(paste0("http://",app_id,":",app_password,"@cloud.ocrsdk.com/processPhotoId"))
}

#' Get Task Status
#'
#' This function gets Information about a particular application
#' @param app_id - get this from http://ocrsdk.com/. Set it before you use the package.
#' @param app_password - get this from http://ocrsdk.com/. Set it before you use the package. 
#' @keywords Application Information
#' @export
#' @examples
#' getTaskStatus(app_id, app_password, taskId)

getTaskStatus <- function(app_id=app_id, app_password=app_password, taskId){
	httr::GET(paste0("http://",app_id,":",app_password,"@cloud.ocrsdk.com/getTaskStatus"))
}

#' Delete Task
#'
#' This function gets Information about a particular application
#' @param app_id - get this from http://ocrsdk.com/. Set it before you use the package.
#' @param app_password - get this from http://ocrsdk.com/. Set it before you use the package. 
#' @keywords Application Information
#' @export
#' @examples
#' deleteTask(app_id, app_password, taskId)

deleteTask <- function(app_id=app_id, app_password=app_password, taskId){
	httr::POST(paste0("http://",app_id,":",app_password,"@cloud.ocrsdk.com/deleteTask"))
}