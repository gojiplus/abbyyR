#' Process Fields
#'
#' This function gets Information about a particular application
#' @param file_path path of the document
#' @param taskId - Only tasks with Submitted, Completed or NotEnoughCredits status can be processed using this function.
#' @param description  optional, default: ""
#' @return Data frame with details of the task associated with the submitted Image
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/processFields/}
#' @examples
#' # processFields(file_path="file_path", taskId="task_id",description="")

processFields <- function(file_path=NULL,taskId=NULL,description=""){
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	
	if(is.null(file_path)) stop("Must specify file_path")

	querylist = list(taskId = taskId, description=description)
	res <- httr::POST("http://cloud.ocrsdk.com/processFields", httr::authenticate(app_id, app_pass), query=querylist, body=httr::upload_file(file_path))
	httr::stop_for_status(res)
	processdetails <- XML::xmlToList(httr::content(res))
	
	resdf <- do.call(rbind.data.frame, processdetails) # collapse to a data.frame
	names(resdf) <- names(processdetails[[1]])[1:length(resdf)] # names for the df, adjust for <7
	row.names(resdf) <- 1:nrow(resdf)	# row.names for the df

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")

	return(invisible(resdf))
}