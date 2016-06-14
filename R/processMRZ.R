#' Process MRZ: Extract data from Machine Readable Zone
#'
#' Extract data from Machine Readable Zone in an Image
#' @param file_path path to the document
#' @param \dots Additional arguments passed to \code{\link{abbyy_POST}}. 
#' 
#' @return Data frame with details of the task associated with the submitted MRZ document
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/processMRZ/}
#' @examples \dontrun{
#' processMRZ(file_path="file_path")
#' }

processMRZ <- function(file_path="", ...) {
	
	if (!file.exists(file_path)) stop("File Doesn't Exist. Please check the path.")

	body=upload_file(file_path)
	
	process_details <- abbyy_POST("processMRZ", body=body, ...)

	resdf <- as.data.frame(do.call(rbind, process_details)) # collapse to a data.frame

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")
	cat("Task ID: ", 			resdf$id, "\n")

	return(invisible(resdf))
}