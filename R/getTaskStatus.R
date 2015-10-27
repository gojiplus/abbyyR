#' Get Task Status
#'
#' This function gets task status for a particular task ID.
#' The function prints the status of the task by default.
#' The function returns a data.frame with all the task details: id (task id), registrationTime, statusChangeTime, status (Submitted, Queued, InProgress, Completed, ProcessingFailed, Deleted, NotEnoughCredits), filesCount (No. of files), credits, resultUrl (URL for the processed file if applicable)
#' @param taskId -id of the task; required
#' @return A data frame with all the available details about the task
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/getTaskStatus/} 
#' @examples \dontrun{
#' getTaskStatus(taskId="task_id")
#' }

getTaskStatus <- function(taskId=NULL){
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	
	if(is.null(taskId)) stop("Must specify taskId")
	
	querylist = list(taskId = taskId)
	res <- GET("http://cloud.ocrsdk.com/getTaskStatus", authenticate(app_id, app_pass), query=querylist)
	stop_for_status(res)
	taskdetails <- xmlToList(content(res))
	
	resdf <- do.call(rbind.data.frame, taskdetails) # collapse to a data.frame
	names(resdf) <- names(taskdetails[[1]])  
	row.names(resdf) <- 1	# row.names for the df

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")

	return(invisible(resdf))
}