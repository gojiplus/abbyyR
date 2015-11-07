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
	body=upload_file(file_path)
	processdetails <- abbyy_POST("processFields", query=querylist, body=body)
	
	resdf <- do.call(rbind.data.frame, processdetails) # collapse to a data.frame
	names(resdf) <- names(processdetails[[1]])[1:length(resdf)] # names for the df, adjust for <7
	row.names(resdf) <- 1:nrow(resdf)	# row.names for the df

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")

	return(invisible(resdf))
}