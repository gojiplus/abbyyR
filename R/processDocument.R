#' Process Document 
#'
#' This function processes several images for the same task and results in a multi-page document. 
#' For instance, upload pages of the book individually via submitImage to the same task. 
#' And then process it via ProcessDocument to get a multi-page pdf.
#' 
#' @param taskId  Only tasks with Submitted, Completed or NotEnoughCredits status can be processed using this function.
#' @param language  String. Optional; default: English
#' @param profile   String. Optional; default: \code{documentConversion}
#' Options: \code{documentConversion, documentArchiving, textExtraction, fieldLevelRecognition, barcodeRecognition}
#' @param textType  String. Optional; default: \code{normal}
#' Options: \code{normal, typewriter, matrix, index, ocrA,ocrB, e13b,cmc7, gothic}
#' @param imageSource  String. Optional; default: \code{auto}
#' Options: \code{auto, photo, scanner}
#' @param correctOrientation  String. Optional; default: \code{true}. 
#' Options: \code{true} or \code{false}
#' @param correctSkew String. Optional; default: \code{true}.
#' Options: \code{true} or \code{false}
#' @param readBarcodes  Optional; 
#' Options: \code{true} or \code{false}
#' @param exportFormat  optional, default: \code{txt} 
#' options: \code{txt, txtUnstructured, rtf, docx, xlsx, pptx, pdfSearchable, pdfTextAndImages, pdfa, xml, xmlForCorrectedImage, alto}
#' @param pdfPassword  Optional; default: NULL
#' @param description  Optional; default: ""
#' @param \dots Additional arguments passed to \code{\link{abbyy_GET}}.
#' 
#' @return \code{data.frame} with details of the task associated with the submitted Document
#' 
#' @export 
#' @references \url{http://ocrsdk.com/documentation/apireference/processDocument/}
#' 
#' @examples \dontrun{
#' processDocument(taskId = "task_id")
#' }

processDocument <- function(taskId = NULL, language="English", 
              profile = c("documentConversion", "documentArchiving", "textExtraction", "fieldLevelRecognition", "barcodeRecognition"), 
              textType = c("normal", "typewriter", "matrix", "index", "ocrA", "ocrB", "e13b", "cmc7", "gothic"), 
              imageSource = c("auto", "photo", "scanner"), 
              correctOrientation = c("true", "false"),
              correctSkew = c("true", "false"),
              readBarcodes = c("false", "true"), 
              exportFormat = c("txt", "txtUnstructured", "rtf", "docx", "xlsx", "pptx", "pdfSearchable", "pdfTextAndImages", "pdfa", "xml", "xmlForCorrectedImage", "alto"),
              description = NULL, pdfPassword = NULL, ...) {
  

  profile        <- match.arg(profile, choices = profile)
  textType       <- match.arg(textType, choices = textType)
  correctSkew    <- match.arg(correctSkew, choices = correctSkew)
  imageSource    <- match.arg(imageSource, choices = imageSource)
  correctOrientation <- match.arg(correctOrientation, choices = correctOrientation)
  readBarcodes   <- match.arg(readBarcodes, choices = readBarcodes)
  exportFormat   <- match.arg(exportFormat, choices = exportFormat)


  querylist      <- list(taskId = taskId, language = language, profile = profile,textType = textType, imageSource = imageSource, correctOrientation = correctOrientation, 
            correctSkew = correctSkew,readBarcodes = readBarcodes,exportFormat = exportFormat, description = description, pdfPassword = pdfPassword)

  process_details <- abbyy_GET("processDocument", query = querylist, ...)
    
  resdf <- ldply(process_details, rbind)
    
  # Print some important things
  cat("Status of the task: ", resdf$status, "\n")

  resdf
}
