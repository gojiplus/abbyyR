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

getAppInfo <- function(app_id, app_password){
	httr::GET(paste0("http://",app_id,":",app_password,"@cloud.ocrsdk.com/getApplicationInfo"))
}

# Submit Image
submitImage <- function(app_id, app_password, file_path){
	httr::GET(paste0("http://",app_id,":",app_password,"@cloud.ocrsdk.com/submitImage"), body=upload_file(file_path))
}

# Process Remote Image
processRemoteImage <- function(app_id, app_password, img_url){
	httr::GET(paste0("http://",app_id,":",app_password,"@cloud.ocrsdk.com/processRemoteImage?source=",img_url))
}

# List Tasks
listTasks <- function(app_id, app_password){
	httr::GET(paste0("http://",app_id,":",app_password,"@cloud.ocrsdk.com/listTasks"))
}

# List Finished Tasks
listFinishedTasks <- function(app_id, app_password){
	httr::GET(paste0("http://",app_id,":",app_password,"@cloud.ocrsdk.com/listFinishedTasks"))
}

