#' Process MRZ: Extract data from Machine Readable Zone
#'
#' Extract data from Machine Readable Zone in an Image
#' @param file_path path to the document
#' @return Data frame with details of the task associated with the submitted MRZ document
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/processMRZ/}
#' @examples \dontrun{
#' processMRZ(file_path="file_path")
#' }

processMRZ <- function(file_path=NULL){
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	
	if(is.null(file_path)) stop("Must specify file_path")

	res <- POST("http://cloud.ocrsdk.com/processMRZ", authenticate(app_id, app_pass), body=upload_file(file_path))
	stop_for_status(res)
	tasklist <- xmlToList(content(res))
	processdetails <- xmlToList(content(res))
	
	resdf <- do.call(rbind.data.frame, processdetails) # collapse to a data.frame
	names(resdf) <- names(processdetails[[1]])[1:length(resdf)] # names for the df, adjust for <7
	row.names(resdf) <- 1:nrow(resdf)	# row.names for the df

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")

	return(invisible(resdf))
}