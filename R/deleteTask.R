#' Delete Task
#'
#' Deletes task and associated data. While Abbyy says, "If you try to delete the task that has already been deleted, the successful response is returned," 
#' it doesn't appear to hold. Hence, the function now defaults to checking the status of the task via \code{\link{getTaskStatus}}, and 
#' deletes only if it hasn't been deleted. 
#'  
#' The function by default prints the status of the task you are trying to delete. It will show up as 'deleted' if successful.
#' 
#' @param taskId Required; Id of the task
#' @param \dots Additional arguments passed to \code{\link{abbyy_GET}}.
#' 
#' @return Data frame with all the details of the task you are trying to delete: id (task id), registrationTime, statusChangeTime, status (Submitted, Queued, InProgress, Completed, ProcessingFailed, Deleted, NotEnoughCredits), filesCount (No. of files), credits, resultUrl (URL for the processed file if applicable)
#' 
#' @export
#' 
#' @references \url{http://ocrsdk.com/documentation/apireference/deleteTask/}
#' 
#' @examples \dontrun{
#' deleteTask(taskId="task_id")
#' }

deleteTask <- function(taskId=NULL, ...){
		
	if (is.null(taskId)) stop("Must specify taskId")

	# Get the status of the task
	task_status <- getTaskStatus(taskId)
	
	if (identical(task_status$status, 'Deleted')) {
		# Print status of the task
		cat("Status of the task: ", task_status$status, "\n")
		
	} else {
		
		querylist = list(taskId = taskId)
		deleted_task_details <- abbyy_GET("deleteTask", query=querylist, ...)
		resdf <- as.data.frame(do.call(rbind, deleted_task_details))
	
		# Print status of the task
		cat("Status of the task: ", resdf$status, "\n")
		return(invisible(resdf))
	}

	return(invisible(task_status))
}
