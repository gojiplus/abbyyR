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
#' @param readBarcodes  optional, default: false
#' @param exportFormat  optional, default: txt; 
#' options: txt, txtUnstructured, rtf, docx, xlsx, pptx, pdfSearchable, pdfTextAndImages, pdfa, xml, xmlForCorrectedImage, alto
#' @param pdfPassword  optional, default: NULL
#' @param description  optional, default: ""
#' @param \dots Additional arguments passed to \code{\link{abbyy_POST}}.
#' 
#' 
#' @return Data frame with details of the task associated with the submitted Image
#' @export
#' @references \url{http://ocrsdk.com/documentation/specifications/image-formats/}
#' @references \url{http://ocrsdk.com/documentation/apireference/processImage/}
#' @examples \dontrun{
#' processImage(file_path="file_path", language="English", exportFormat="txtUnstructured")
#' }


processImage <- function(file_path="", language="English", profile="documentConversion",textType="normal", imageSource="auto", correctOrientation="true", 
						correctSkew="true", readBarcodes="false", exportFormat="txt", description="", pdfPassword="", ...)
{
		
	if (!file.exists(file_path)) stop("File Doesn't Exist. Please check the path.")

	querylist <- list(language=language, profile=profile,textType=textType, imageSource=imageSource, correctOrientation=correctOrientation, 
						correctSkew=correctSkew,readBarcodes=readBarcodes,exportFormat=exportFormat, description=description, pdfPassword=pdfPassword)

	body <- upload_file(file_path)
	process_details <- abbyy_POST("processImage", query=querylist, body=body, ...)
		
	resdf <- as.data.frame(do.call(rbind, process_details))

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")
	cat("Task ID: ", 			resdf$id, "\n")

	return(invisible(resdf))
}
