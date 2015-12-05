#' Get Results
#'
#' Get data from all the processed images.
#' The function goes through the finishedTasks data frame and downloads all the files in resultsUrl
#' 
#' @param output Optional; folder to which you want to save the data from the processed images; Default is same folder as the script
#' @param save_to_file Required; Default is TRUE; If true, it saves to file. Otherwise returns the object you requested.
#' 
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/getTaskStatus/}
#' 
#' @usage getResults(output="", save_to_file=TRUE)
#' 
#' @examples \dontrun{
#' getResults(save_to_file=FALSE)
#' }

getResults <- function(output="./", save_to_file=TRUE) {

	finishedlist <- listFinishedTasks()
	
	res <- list()

	if (!save_to_file) {
		for(i in 1:nrow(finishedlist)) {
			res[[i]] <- curl_fetch_memory(finishedlist$resultUrl[i])
		}
		return(res)
	}

	for(i in 1:nrow(finishedlist)){
		curl_download(finishedlist$resultUrl[i], destfile=paste0(output, finishedlist$id[i]))
	}
}