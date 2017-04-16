#' Process Text Field
#'
#' This function gets Information about a particular application
#' @param file_path path of the document
#' @param region coordinates of region from top left, 4 values: top left bottom right; optional; default: "-1,-1,-1,-1" (entire image) 
#' @param language optional; default: "English"
#' @param letterSet letterset to be used for recognition, set by language but can be customized; optional; default: ""
#' @param regExp which words are allowed in the field. see regular expression documentation; optional; default: ""
#' @param textType type of the text in the field including typewriter, handprinted; optional; default: "normal"
#' @param oneTextLine field contains only one text line or more; optional; default: "false"
#' @param oneWordPerTextLine field contains one word per line or not; optional; default: "false"
#' @param markingType only for handprint recognition, includes underlinedText etc.; optional; default: "simpleText"
#' @param placeholdersCount No. of character cells for the field; optional; default: "1"
#' @param writingStyle handprint writing style, see Abbyy FineReader documentation for values; optional; default: "default"
#' @param description Description of processing task; optional; default: ""
#' @param pdfPassword Password for pdf; optional; default: ""
#' @param \dots Additional arguments passed to \code{\link{abbyy_POST}}.
#' 
#' @return Data frame with details of the task associated with the submitted Image
#' 
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/processTextField/}
#' @references \url{http://ocrsdk.com/documentation/specifications/regular-expressions/}
#' 
#' @examples \dontrun{
#' processTextField(file_path="file_path")
#' }

processTextField <- function(file_path = "", region = "-1,-1,-1,-1", language = "English", letterSet = "", regExp = "", textType = "normal", oneTextLine = "false", 
                           oneWordPerTextLine = "false", markingType = "simpleText", placeholdersCount = "1", writingStyle = "default", description = "", 
                           pdfPassword = "", ...) {
  
  if (!file.exists(file_path)) stop("File Doesn't Exist. Please check the path.")

  querylist <- list(language = language, letterSet = letterSet, regExp = regExp, textType = textType, oneTextLine = oneTextLine, 
                 oneWordPerTextLine = oneWordPerTextLine, markingType = markingType, placeholdersCount = placeholdersCount, 
                 writingStyle = writingStyle, description = description, pdfPassword = pdfPassword)

  body  <- upload_file(file_path)
  process_details <- abbyy_POST("processTextField", query = querylist, body = body, ...)

  resdf <- ldply(process_details, rbind)

  # Print some important things
  cat("Status of the task: ", resdf$status, "\n")
  cat("Task ID: ",       resdf$id, "\n")

  resdf
}
