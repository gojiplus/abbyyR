#' OCR File
#'
#' Want to quick OCR a local file and get the results? Use this function.  
#' @param file_path path to file containing OCR'd text; required
#' @param exportFormat  optional, default: txt; 
#' options: txt, txtUnstructured, rtf, docx, xlsx, pptx, pdfSearchable, pdfTextAndImages, pdfa, xml, xmlForCorrectedImage, alto
#' @param output_dir path to output directory. file_name will be same as input file name (except for the extension)
#' @param save_to_file Required, Boolean, Default is TRUE, but if not, returns result to memory 
#' 
#' @return path to output file
#' 
#' @export
#'
#' @examples \dontrun{
#' ocrFile(file_path = "path_to_ocr_file", output_dir = "path_to_output_dir")
#' }

ocrFile <- function(file_path = "", output_dir = "./", 
          exportFormat = c("txt", "txtUnstructured", "rtf", "docx", "xlsx", "pptx", "pdfSearchable", "pdfTextAndImages", "pdfa", "xml", "xmlForCorrectedImage", "alto"), 
          save_to_file = TRUE) {

  exportFormat <- match.arg(exportFormat)

  res <- processImage(file_path = file_path, exportFormat = exportFormat)

  # Wait till the processing is finished with a maximum time 
  while(!(any(as.character(res$id) == as.character(listFinishedTasks()$id)))) {
    Sys.sleep(1)
  }

  finishedlist <- listFinishedTasks()
  
  # Coerce to char. if not.
  res$id <- as.character(res$id)
  finishedlist$id <- as.character(finishedlist$id)

  if (identical(save_to_file, FALSE)) {
    res <- curl_fetch_memory(finishedlist$resultUrl[res$id == finishedlist$id])
    return(rawToChar(res$content))
  }

  curl_download(finishedlist$resultUrl[res$id == finishedlist$id], destfile = paste0(output_dir, unlist(strsplit(basename(file_path), "[.]"))[1], ".", exportFormat))
  
}
