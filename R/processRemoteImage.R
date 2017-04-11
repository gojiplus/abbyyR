#' Process Remote Image
#'
#' This function gets Information about a particular application
#' @param img_url   Required; url to remote image
#' @param language  Optional; default: English
#' @param profile   String. Optional; default: \code{documentConversion}
#' Options: \code{documentConversion, documentArchiving, textExtraction, fieldLevelRecognition, barcodeRecognition}
#' @param textType  String. Optional; default: \code{normal}. Specifies the type of the text on a page.
#' Options: \code{normal, typewriter, matrix, index, ocrA,ocrB, e13b,cmc7, gothic}
#' @param imageSource  String. Optional; default: \code{auto}
#' Options: \code{auto, photo, scanner}
#' @param correctOrientation  String. Optional; default: \code{true}. 
#' Options: \code{true} or \code{false}
#' @param correctSkew String. Optional; default: \code{true}.
#' Options: \code{true} or \code{false}
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

processRemoteImage <- function(img_url=NULL, language="English", 
							   profile = c("documentConversion", "documentArchiving", "textExtraction", "fieldLevelRecognition", "barcodeRecognition"), 
							   textType = c("normal", "typewriter", "matrix", "index", "ocrA", "ocrB", "e13b", "cmc7", "gothic"), 
							   imageSource = c("auto", "photo", "scanner"), 
							   correctOrientation = c("true", "false"),
							   correctSkew = c("true", "false"),
							   readBarcodes = c("false", "true"), 
							   exportFormat = c("txt", "txtUnstructured", "rtf", "docx", "xlsx", "pptx", "pdfSearchable", "pdfTextAndImages", "pdfa", "xml", "xmlForCorrectedImage", "alto"),
						       description=NULL, pdfPassword=NULL, ...) {
	
	if (is.null(img_url)) stop("Must specify img_url")

	profile        <- match.arg(profile, choices = profile)
	textType       <- match.arg(textType, choices = textType)
	correctSkew    <- match.arg(correctSkew, choices = correctSkew)
	imageSource    <- match.arg(imageSource, choices = imageSource)
	correctOrientation <- match.arg(correctOrientation, choices = correctOrientation)
	readBarcodes   <- match.arg(readBarcodes, choices = readBarcodes)
	exportFormat   <- match.arg(exportFormat, choices = exportFormat)

	querylist = list(source=img_url, language=language, profile=profile,textType=textType, imageSource=imageSource, correctOrientation=correctOrientation, 
					 correctSkew=correctSkew,readBarcodes=readBarcodes,exportFormat=exportFormat, description=description, pdfPassword=pdfPassword)
	
	process_details <- abbyy_GET("processRemoteImage", query=querylist, ...)
	
	resdf <- ldply(process_details, rbind)

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")
	cat("Task ID: ", 			resdf$id, "\n")

	resdf
}
