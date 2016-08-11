#' Process Remote Image
#'
#' This function gets Information about a particular application
#' @param img_url   Required; url to remote image
#' @param language  Optional; default: English
#' @param profile   Optional; default: documentConversion. 
#' Must be one of the following: documentConversion, documentArchiving, textExtraction, fieldLevelRecognition, barcodeRecognition
#' @param textType  Optional; default: normal. Specifies the type of the text on a page. 
#' Must be one of the following:: normal, typewriter, matrix, index, handprinted, ocrA, ocrB, e13b, cmc7, gothic
#' @param imageSource  Optional; default: auto. Can be one of the following: auto, photo, scanner
#' @param correctOrientation  Optional; default: true. Can be true or false
#' @param correctSkew Optional; default: true
#' @param readBarcodes  Optional; default: 
#' @param exportFormat  Optional; default: txt. Must be one of the following: txt, rtf, docx, xlsx, pptx, pdfSearchable, pdfTextAndImages, pdfa, xml, alto
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
						correctSkew="true", readBarcodes="false", exportFormat="txt", description=NULL, pdfPassword=NULL, ...){
	
	if (is.null(img_url)) stop("Must specify img_url")

	if (!(exportFormat %in% c('txt', 'rtf', 'docx', 'xlsx', 'pptx', 'pdfSearchable', 'pdfTextAndImages', 'pdfa', 'xml', 'alto'))) stop("Incorrect exportFormat argument.")
	if (!(profile %in% c('documentConversion', 'documentArchiving', 'textExtraction', 'fieldLevelRecognition', 'barcodeRecognition'))) stop("Incorrect profile argument.")
	if (!(textType %in% c('normal', 'typewriter', 'matrix', 'index', 'handprinted', 'ocrA', 'ocrB', 'e13b', 'cmc7', 'gothic'))) stop("Incorrect textType argument.")
	if (!(textType %in% c('auto', 'photo', 'scanner'))) stop("Incorrect imageSource argument.")

	querylist = list(source=img_url, language=language, profile=profile,textType=textType, imageSource=imageSource, correctOrientation=correctOrientation, 
						correctSkew=correctSkew,readBarcodes=readBarcodes,exportFormat=exportFormat, description=description, pdfPassword=pdfPassword)
	
	process_details <- abbyy_GET("processRemoteImage", query=querylist, ...)
	
	resdf <- as.data.frame(do.call(rbind, process_details))

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")
	cat("Task ID: ", 			resdf$id, "\n")

	return(invisible(resdf))
}
