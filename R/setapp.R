#' Sets Application ID and Password
#'
#' Set Application ID and Password. Needed for interfacing with Abbyy FineReader Cloud OCR SDK. Run this before anything else.
#' @param appdetails Required; A vector of app_id, app_password. Get these from \url{http://ocrsdk.com/}. Set them before you use other functions.
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

