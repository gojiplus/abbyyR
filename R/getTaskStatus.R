#' Get Task Status
#'
#' This function gets task status for a particular task ID.
#' The function prints the status of the task by default.
#' The function returns a data.frame with all the task details: id (task id), registrationTime, statusChangeTime, status (Submitted, Queued, InProgress, Completed, ProcessingFailed, Deleted, NotEnoughCredits), filesCount (No. of files), credits, resultUrl (URL for the processed file if applicable)
#' 
#' @param taskId Required, Id of the task
#' @return A data frame with all the available details about the task
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/getTaskStatus/} 
#' @examples \dontrun{
#' getTaskStatus(taskId="task_id")
#' }

getTaskStatus <- function(taskId = NULL) {
	
	if (is.null(taskId)) stop("Must specify taskId")
	
	querylist <- list(taskId = taskId)	
	taskdetails <- abbyy_GET("getTaskStatus", query=querylist)

	resdf <- as.data.frame(do.call(rbind, taskdetails)) # collapse to a data.frame

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")

	return(invisible(resdf))
}