#' Delete Task
#'
#' This function deletes a particular task and associated data. From Abbyy "If you try to delete the task that has already been deleted, the successful response is returned."
#' The function by default prints the status of the task you are trying to delete. It will show up as 'deleted' if successful
#' @param taskId id of the task; required
#' @return Data frame with all the details of the task you are trying to delete: id (task id), registrationTime, statusChangeTime, status (Submitted, Queued, InProgress, Completed, ProcessingFailed, Deleted, NotEnoughCredits), filesCount (No. of files), credits, resultUrl (URL for the processed file if applicable)
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/deleteTask/}
#' @examples \dontrun{
#' deleteTask(taskId="task_id")
#' }

deleteTask <- function(taskId=NULL){
		
	if(is.null(taskId)) stop("Must specify taskId")

	querylist = list(taskId = taskId)
	
	deletedTaskdetails <- abbyy_GET("deleteTask", query=querylist)
		
	resdf <- do.call(rbind.data.frame, deletedTaskdetails) # collapse to a data.frame
	names(resdf) <- c("id", "registrationTime", "statusChangeTime", "status", "filesCount", "credits", "resultUrl")[1:length(resdf)] # names for the df, adjust for <7
	row.names(resdf) <- 1:nrow(resdf)	# row.names for the df

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")

	return(invisible(resdf))
}
