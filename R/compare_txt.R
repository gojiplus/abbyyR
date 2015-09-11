#' Compare Text
#'
#' This function calculates the edit distance between OCR'd and human transcribed file.
#' The function by default prints the status of the task you are trying to delete. It will show up as 'deleted' if successful
#' @param path_to_ocr path to file containing OCR'd text; required
#' @param path_to_gold path to file containing human transcribed text; required
#' @param remove_extra_space a dummy indicating whether or not extra spaces should be removed from the OCR file; default is TRUE
#' 
#' @return levenshtein distance
#' @export
#' @examples \dontrun{
#' compare_txt(path_to_ocr="path_to_ocr_file", path_to_gold="path_to_gold_file", 
#' 	           remove_extra_space=TRUE)
#' }

compare_txt <- function(path_to_ocr=NULL, path_to_gold=NULL, remove_extra_space=TRUE) 
{
	ocr  <- read_file(path_to_ocr)
	gold <- read_file(path_to_gold)

	if (remove_extra_space) {
		ocr  <- gsub("^ *|(?<= ) | *$", "", ocr, perl=T)
		gold <- gsub("^ *|(?<= ) | *$", "", gold, perl=T)
	}

	levdist <- levenshteinDist(ocr, gold)

	levdist
}