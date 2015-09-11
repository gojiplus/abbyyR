#' OCR File
#'
#' Want to quick OCR a local file and get the results? Use this function.  
#' @param file_path path to file containing OCR'd text; required
#' @param exportFormat  optional, default: txt; 
#' options: txt, txtUnstructured, rtf, docx, xlsx, pptx, pdfSearchable, pdfTextAndImages, pdfa, xml, xmlForCorrectedImage, alto
#' @param output_dir path to output directory. file_name will be same as input file name (except for the extension)
#' 
#' @return path to output file
#' @export
#' @examples \dontrun{
#' OCRFile(file_path="path_to_ocr_file", output_dir="path_to_output_dir")
#' }

ocrFile <- function(file_path=NULL, output_dir="./", exportFormat="txt") 
{
	res <- processImage(file_path=file_path, exportFormat=exportFormat)

	# Wait till the processing is finished with a maximum time 
	while(!(any(res$id ==listFinishedTasks()$id))) {
		Sys.sleep(1)
	}

	finishedlist <- listFinishedTasks()
	curl_download(finishedlist$resultUrl[res$id == finishedlist$id], destfile=paste0(output_dir, unlist(strsplit(basename(file_path), "[.]"))[1], ".", exportFormat))
	
}
