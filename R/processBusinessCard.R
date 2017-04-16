#' Process Business Card
#'
#' Processes a Business Card
#' 
#' @param file_path required, path of the document, default: ""
#' @param language optional, default: English
#' @param imageSource  optional, default: auto
#' @param correctOrientation  optional, default: true
#' @param correctSkew optional, default: true
#' @param exportFormat  optional, default: "vCard"
#' @param pdfPassword  optional, default: NULL
#' @param description  optional, default: ""
#' @param \dots Additional arguments passed to \code{\link{abbyy_POST}}.
#' 
#' @keywords Process Remote Image
#' 
#' @return Data frame with details of the task associated with the submitted Business Card
#' 
#' @export
#' 
#' @references \url{http://ocrsdk.com/documentation/apireference/processBusinessCard/}
#' 
#' @examples \dontrun{
#' processBusinessCard(file_path="file_path", language="English")
#' }

processBusinessCard <- function(file_path = "", language = "English", imageSource = "auto", correctOrientation = "true", 
                    correctSkew = "true", exportFormat = "vCard", description = "", pdfPassword = "", ...)
{
  
  if(!file.exists(file_path)) stop("File Doesn't Exist. Please check the path.")
  
  querylist <- list(language = language, imageSource = imageSource, correctOrientation = correctOrientation, 
           correctSkew = correctSkew,exportFormat = exportFormat, description = description, pdfPassword = pdfPassword)
  
  body = upload_file(file_path)
  process_details <- abbyy_POST("processBusinessCard", query = querylist, body = body, ...)

  resdf <- ldply(process_details, rbind)
    
  # Print some important things
  cat("Status of the task: ", resdf$status, "\n")
  cat("Task ID: ",       resdf$id, "\n")

  resdf
}
