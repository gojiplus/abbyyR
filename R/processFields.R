#' Process Fields
#'
#' This function gets Information about a particular application
#' @param file_path path of the document
#' @param taskId - Only tasks with Submitted, Completed or NotEnoughCredits status can be processed using this function.
#' @param description  optional, default: ""
#' @return Data frame with details of the task associated with the submitted Image
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/processFields/}
#' @examples \dontrun{
#' processFields(file_path="file_path", taskId="task_id",description="")
#' }

processFields <- function(file_path="", taskId=NULL, description=""){
	
	if(!file.exists(file_path)) stop("File Doesn't Exist. Please check the path.")

	querylist = list(taskId = taskId, description=description)
	
	process_details <- abbyy_POST("processFields", query=querylist, body=upload_file(file_path))
	
	resdf <- as.data.frame(do.call(rbind, process_details)) # collapse to a data.frame
	
	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")
	cat("Task ID: ", 			resdf$id, "\n")

	return(invisible(resdf))
}