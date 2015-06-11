#' Delete Task
#'
#' This function deletes a particular task and associated data. From Abbyy "If you try to delete the task that has already been deleted, the successful response is returned."
#' The function by default prints the status of the task you are trying to delete. It will show up as 'deleted' if successful
#' @param taskId id of the task; required
#' @return Data frame with all the details of the task you are trying to delete: id (task id), registrationTime, statusChangeTime, status (Submitted, Queued, InProgress, Completed, ProcessingFailed, Deleted, NotEnoughCredits), filesCount (No. of files), credits, resultUrl (URL for the processed file if applicable)
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/deleteTask/}
#' @examples
#' # deleteTask(taskId="task_id")

deleteTask <- function(taskId=NULL){
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	
	if(is.null(taskId)) stop("Must specify taskId")

	querylist = list(taskId = taskId)
	res <- httr::GET(paste0("https://",app_id,":",app_pass,"@cloud.ocrsdk.com/deleteTask"), query=querylist)
	httr::stop_for_status(res)
	deletedTaskdetails <- XML::xmlToList(httr::content(res))
	
	resdf <- do.call(rbind.data.frame, deletedTaskdetails) # collapse to a data.frame
	names(resdf) <- c("id", "registrationTime", "statusChangeTime", "status", "filesCount", "credits", "resultUrl")[1:length(resdf)] # names for the df, adjust for <7
	row.names(resdf) <- 1:nrow(resdf)	# row.names for the df

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")

	return(invisible(resdf))
}
