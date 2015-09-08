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

getResults <- function(output=""){
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	
	finishedlist <- listFinishedTasks()
	
	for(i in 1:nrow(finishedlist)){
		#RCurl::getURLContent(finishedlist$resultUrl[i], ssl.verifypeer = FALSE, useragent = "R")
		#httr::getURL(ssl.verifypeer = FALSE)
		curl_download(finishedlist$resultUrl[i],destfile=paste0(output, finishedlist$id[i]))
	}
}