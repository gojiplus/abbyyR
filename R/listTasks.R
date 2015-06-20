#' List Tasks
#'
#' List all the tasks in the application. You can specify a date range and whether or not you want to include deleted tasks. 
#' The function prints Total number of tasks and No. of Finished Tasks. 
#' @param fromDate - optional;  format: yyyy-mm-ddThh:mm:ssZ
#' @param toDate - optional;  format: yyyy-mm-ddThh:mm:ssZ
#' @param excludeDeleted - optional; default='false'
#' @return A data frame with the following columns: id (task id), registrationTime, statusChangeTime, status 
#' 		   (Submitted, Queued, InProgress, Completed, ProcessingFailed, Deleted, NotEnoughCredits), filesCount (No. of files), credits, resultUrl (URL for the processed file)
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/getApplicationInfo/}
#' @usage listTasks(fromDate=NULL,toDate=NULL,excludeDeleted='false')

listTasks <- function(fromDate=NULL,toDate=NULL, excludeDeleted='false'){
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	
	querylist = list(fromDate = fromDate, toDate = toDate, excludeDeleted=excludeDeleted)
	res <- httr::GET("http://cloud.ocrsdk.com/listTasks", authenticate(app_id, app_pass), query=querylist)
	httr::stop_for_status(res)
	tasklist <- XML::xmlToList(httr::content(res))

	if(is.null(tasklist)){
		cat("No tasks in the application. \n")
		return(invisible(NULL))
	}

	# Converting list to a data.frame
	lenitem <- sapply(tasklist, length) # length of each list item
	resdf <- do.call(rbind.data.frame, tasklist) # collapse to a data.frame, wraps where lenitems < longest list (7)
	names(resdf) <- names(tasklist[[1]]) # names for the df
	row.names(resdf) <- 1:nrow(resdf)	# row.names for the df
	resdf[lenitem == 6,7] <- NA 		# Fill NAs where lenitems falls short

	# Print some important things
	cat("Total No. of Tasks: ", nrow(resdf), "\n")
	cat("No. of Finished Tasks: ", sum(lenitem==7), "\n")
  
  	# Return the data.frame
	return(invisible(resdf))
}