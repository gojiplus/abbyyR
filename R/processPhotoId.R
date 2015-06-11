#' Process Photo ID
#'
#' This function gets Information about a particular application
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
#' @examples
#' # processPhotoId(file_path="file_path", idType="auto", imageSource="auto")

processPhotoId <- function(file_path=NULL, idType="auto", imageSource="auto", correctOrientation="true", correctSkew="true", description="", pdfPassword=""){
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	
	if(is.null(file_path)) stop("Must specify file_path")

	querylist = list(idType=idType, imageSource=imageSource, correctOrientation=correctOrientation, correctSkew=correctSkew, description=description, pdfPassword=pdfPassword)
	res <- httr::POST(paste0("http://",app_id,":",app_pass,"@cloud.ocrsdk.com/processPhotoId"), query=querylist, body=httr::upload_file(file_path))
	httr::stop_for_status(res)
	processdetails <- XML::xmlToList(httr::content(res))
	
	resdf <- do.call(rbind.data.frame, processdetails) # collapse to a data.frame
	names(resdf) <- names(processdetails[[1]])
	row.names(resdf) <- 1

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")

	return(invisible(resdf))
}