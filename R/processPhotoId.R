#' Process Photo ID
#'
#' Get data from a Photo ID. The function is under testing and may not work fully.
#' 
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
#' @examples \dontrun{
#' processPhotoId(file_path="file_path", idType="auto", imageSource="auto")
#' }

processPhotoId <- function(file_path="", idType="auto", imageSource="auto", correctOrientation="true", correctSkew="true", description="", pdfPassword="") {
		
	if (!file.exists(file_path)) stop("File Doesn't Exist. Please check the path.")

	querylist <- list(idType=idType, imageSource=imageSource, correctOrientation=correctOrientation, correctSkew=correctSkew, description=description, pdfPassword=pdfPassword)

	body <- upload_file(file_path)
	process_details <- abbyy_POST("processPhotoId", query=NULL, body=body)

	resdf <- as.data.frame(do.call(rbind, process_details))

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")
	cat("Task ID: ", 			resdf$id, "\n")

	return(invisible(resdf))
}