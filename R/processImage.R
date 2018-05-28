#' Process Image
#'
#' This function processes an image
#' @param file_path path to the document
#' @param region String. Optional. Default: "-1,-1,-1,-1". Region of the image.
#' @param language optional, default: English
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
#' @param pdfPassword  optional, default: NULL
#' @param description  optional, default: ""
#' @param \dots Additional arguments passed to \code{\link{abbyy_POST}}.
#' 
#' 
#' @return A \code{data.frame} with details of the task associated with the submitted Image
#' 
#' @export
#' @references \url{http://ocrsdk.com/documentation/specifications/image-formats/}
#' @references \url{http://ocrsdk.com/documentation/apireference/processImage/}
#' 
#' @examples \dontrun{
#' processImage(file_path = "file_path", language = "English", exportFormat = "txtUnstructured")
#' }

processImage <- function(file_path = "", language = "English",
                         profile = c("documentConversion",
                                      "documentArchiving",
                                      "textExtraction",
                                      "fieldLevelRecognition",
                                      "barcodeRecognition"),
                         textType = c("normal", "typewriter", "matrix",
                                      "index", "ocrA", "ocrB", "e13b",
                                      "cmc7", "gothic"),
                         imageSource = c("auto", "photo", "scanner"),
                         correctOrientation = c("true", "false"),
                         correctSkew = c("true", "false"),
                         region = "-1,-1,-1,-1",
                         readBarcodes = c("false", "true"),
                         exportFormat = c("txt", "txtUnstructured",
                                          "rtf", "docx", "xlsx", "pptx",
                                          "pdfSearchable", "pdfTextAndImages",
                                          "pdfa", "xml",
                                          "xmlForCorrectedImage", "alto"),
                         description = "", pdfPassword = "", ...) {

  if (!file.exists(file_path)) {
    stop("File Doesn't Exist. Please check the path.")
  }

  profile        <- match.arg(profile, choices = profile)
  textType       <- match.arg(textType, choices = textType)
  correctSkew    <- match.arg(correctSkew, choices = correctSkew)
  imageSource    <- match.arg(imageSource, choices = imageSource)
  correctOrientation <- match.arg(correctOrientation,
                                  choices = correctOrientation)
  readBarcodes   <- match.arg(readBarcodes, choices = readBarcodes)
  exportFormat   <- match.arg(exportFormat, choices = exportFormat)

  querylist <- list(language = language,
                    region = region,
                    profile = profile,
                    textType = textType,
                    imageSource = imageSource,
                    correctOrientation = correctOrientation,
                    correctSkew = correctSkew,
                    readBarcodes = readBarcodes,
                    exportFormat = exportFormat,
                    description = description,
                    pdfPassword = pdfPassword)

  body <- upload_file(file_path)
  process_details <- abbyy_POST("processImage",
                                query = querylist,
                                body = body, ...)

  resdf <- ldply(process_details, rbind)

  # Print some important things
  cat("Status of the task: ", resdf$status, "\n")
  cat("Task ID: ",       resdf$id, "\n")

  resdf
}
