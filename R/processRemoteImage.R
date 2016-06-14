#' Process Remote Image
#'
#' This function gets Information about a particular application
#' @param img_url   Required; url to remote image
#' @param language  Optional; default: English
#' @param profile   Optional; default: documentConversion
#' @param textType  Optional; default: normal
#' @param imageSource  Optional; default: auto
#' @param correctOrientation  Optional; default: true
#' @param correctSkew Optional; default: true
#' @param readBarcodes  Optional; default: 
#' @param exportFormat  Optional; default: txt
#' @param pdfPassword  Optional; default: NULL
#' @param description  Optional; default: ""
#' @param \dots Additional arguments passed to \code{\link{abbyy_GET}}.
#' 
#' @return Data frame with details of the task associated with the submitted Remote Image
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/processRemoteImage/}
#' @examples \dontrun{
#' processRemoteImage(img_url="img_url")
#' }

processRemoteImage <- function(img_url=NULL, language="English", profile="documentConversion",textType="normal", imageSource="auto", correctOrientation="true", 
						correctSkew="true",readBarcodes="false", exportFormat="txt", description=NULL, pdfPassword=NULL, ...){
	
	if (is.null(img_url)) stop("Must specify img_url")

	querylist = list(source=img_url, language=language, profile=profile,textType=textType, imageSource=imageSource, correctOrientation=correctOrientation, 
						correctSkew=correctSkew,readBarcodes=readBarcodes,exportFormat=exportFormat, description=description, pdfPassword=pdfPassword)
	
	process_details <- abbyy_GET("processRemoteImage", query=querylist, ...)
	
	resdf <- as.data.frame(do.call(rbind, process_details))

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")
	cat("Task ID: ", 			resdf$id, "\n")

	return(invisible(resdf))
}
