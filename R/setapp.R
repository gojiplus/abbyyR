#' Sets Application ID and Password
#'
#' Set Application ID and Password. Needed for interfacing with Abbyy FineReader Cloud OCR SDK. Run this before anything else.
#' 
#' @details 
#' The function looks for AbbyyAppId and AbbyyAppPassword in the environment. If it doesn't find them and if we don't want to force
#' change in them, it looks for arguments. And if no arguments are passed, it asks for user to input the values. 
#' 
#' @param appdetails A vector of app_id, app_password. Get these from \url{http://ocrsdk.com/}. Set them before you use other functions.
#' @param force Force change the app_id and app_password stored in the environment
#' 
#' @keywords Sets Application ID and Password
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/getApplicationInfo/}
#' @examples \dontrun{
#' setapp(c("app_id", "app_password"))
#' }

setapp <- 
function(appdetails = NULL, force=FALSE) {

    env_id <- Sys.getenv('AbbyyAppId')
    env_pass <- Sys.getenv('AbbyyAppPassword')
    
    # If you cannot find AbbyyAppId or AbbyyAppPassword in the environment
    if ((identical(env_id, "") | identical(env_pass, "")) | !force) {

    	# First look for arguments passed in the function
	    if (!is.null(appdetails)) {
	        Sys.setenv(AbbyyAppId = appdetails[1])
	        Sys.setenv(AbbyyAppPassword = appdetails[2])
	       }

		# Else ask user for the details    
	    else {
    		message("Couldn't find env var AbbyyAppId or AbbyyAppPassword. See ?setapp for more details.")
			message("Please enter your AbbyyAppId and press enter:")
		  	pat <- readline(": ")
        	Sys.setenv(AbbyyAppId = pat)
        	message("Now please enter your AbbyyAppPassword and press enter:")
		  	pat <- readline(": ")
        	Sys.setenv(AbbyyAppPassword = pat)
	        }
    }
}
