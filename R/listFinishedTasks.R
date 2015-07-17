#' List Finished Tasks
#'
#' List all the finished tasks in the application. 
#' From Abbyy FineReader: The tasks are ordered by the time of the end of processing. No more than 100 tasks can be returned at one method call. 
#' The function prints number of finished tasks by default
#' @return A data frame with the following columns: id (task id), registrationTime, statusChangeTime, status (Completed), filesCount (No. of files), credits, resultUrl (URL for the processed file)
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/listFinishedTasks/}
#' @usage listFinishedTasks()
#' @examples \dontrun{
#' listFinishedTasks()
#' }

listFinishedTasks <- function(){
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	
	res <- httr::GET("http://cloud.ocrsdk.com/listFinishedTasks", httr::authenticate(app_id, app_pass))
	httr::stop_for_status(res)
	tasklist <- XML::xmlToList(httr::content(res))

	if(is.null(tasklist)){
		cat("No finished tasks in the application. \n")
		return(invisible(NULL))
	}

	resdf <- do.call(rbind.data.frame, tasklist) # collapse to a data.frame, wraps where lenitems < longest list (7)
	names(resdf) <- names(tasklist[[1]]) # names for the df
	row.names(resdf) <- 1:nrow(resdf)	# row.names for the df

	# Print some important things
	cat("No. of Finished Tasks: ", nrow(resdf), "\n")

	return(invisible(resdf))
}
