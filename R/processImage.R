#' Process Image
#'
#' This function processes an image
#' @param file_path path to the document
#' @param language optional, default: English
#' @param profile   optional, default: documentConversion
#' @param textType  optional, default: normal
#' @param imageSource  optional, default: auto
#' @param correctOrientation  optional, default: true
#' @param correctSkew  optional, default: true
#' @param readBarcodes  optional, default: 
#' @param exportFormat  optional, default: txt
#' @param pdfPassword  optional, default: NULL
#' @param description  optional, default: ""
#' @return Data frame with details of the task associated with the submitted Image
#' @export
#' @references \url{http://ocrsdk.com/documentation/specifications/image-formats/}
#' @references \url{http://ocrsdk.com/documentation/apireference/processImage/}
#' @examples \dontrun{
#' processImage(file_path="file_path", language="English")
#' }

processImage <- function(file_path=NULL, language="English", profile="documentConversion",textType="normal", imageSource="auto", correctOrientation="true", 
						correctSkew="true",readBarcodes="false",exportFormat="txt", description="", pdfPassword=""){
	
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	
	if(is.null(file_path)) stop("Must specify file_path")

	querylist = list(language=language, profile=profile,textType=textType, imageSource=imageSource, correctOrientation=correctOrientation, 
						correctSkew=correctSkew,readBarcodes=readBarcodes,exportFormat=exportFormat, description=description, pdfPassword=pdfPassword)

	res <- POST("http://cloud.ocrsdk.com/processImage", authenticate(app_id, app_pass), query=querylist, body=upload_file(file_path))
	stop_for_status(res)
	processdetails <- xmlToList(content(res))
	
	resdf <- do.call(rbind.data.frame, processdetails) # collapse to a data.frame
	names(resdf) <- names(processdetails[[1]])
	row.names(resdf) <- 1:nrow(resdf)	# row.names for the df

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")
	cat("Task ID: ", 			resdf$id, "\n")

	return(invisible(resdf))
}
