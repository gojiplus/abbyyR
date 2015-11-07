#' Get Results
#'
#' Get data from all the processed images.
#' The function goes through the finishedTasks data frame and downloads all the files in resultsUrl
#' @param output Optional; folder to which you want to save the data from the processed images; Default is same folder as the script
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/getTaskStatus/}
#' @usage getResults(output="")
#' @examples \dontrun{
#' getResults(output="")
#' }

getResults <- function(output="./") {

	finishedlist <- listFinishedTasks()
	
	for(i in 1:nrow(finishedlist)){
		curl_download(finishedlist$resultUrl[i], destfile=paste0(output, finishedlist$id[i]))
	}
}