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
