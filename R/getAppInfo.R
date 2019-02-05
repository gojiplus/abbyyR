#' Get Application Info
#'
#' Get Information about the Application, such as number of pages (given the money), 
#' when the application credits expire etc. The function prints the details, and returns a 
#' data.frame with the details.
#' 
#' @param \dots Additional arguments passed to \code{\link{abbyy_GET}}.
#' 
#' @return A data.frame with the following fields: Name of the Application (name), 
#' No. of pages remaining (pages), No. of fields remaining (fields), 
#' when the application credits expire (expires) and type of application (type). 
#' 
#' @export
#' 
#' @references \url{http://ocrsdk.com/documentation/apireference/getApplicationInfo/}
#' @references \url{http://ocrsdk.com/schema/appInfo-1.0.xsd}
#' 
#' @examples \dontrun{
#' getAppInfo()
#' }

getAppInfo <- function(...) {

  appinfo <- abbyy_GET("getApplicationInfo", query = "", ...)[[1]]

  cat("Name of Application: ", appinfo$name, "\n", sep = "")
  cat("No. of Pages Remaining: ", appinfo$pages, "\n", sep = "")
  cat("No. of Fields Remaining: ", appinfo$fields, "\n", sep = "")
  cat("Application Credits Expire on: ", appinfo$expires, "\n", sep = "")
  cat("Type: ", appinfo$type, "\n", sep = "")

  appinfo
}
