#' Submit Image
#'
#' Adds image to the existing task or creates a new task for the uploaded image. The new task isn't processed till processDocument or processFields is called.
#' @param file_path Required; Path to the document
#' @param taskId    Optional; Assigns image to the task ID specified. If an empty string is passed, a new task is created. 
#' @param pdfPassword Optional; If the pdf is password protected, put the password here.
#' @return Data frame with all the details of the submitted image: id (task id), registrationTime, statusChangeTime, status (Submitted, Queued, InProgress, Completed, ProcessingFailed, Deleted, NotEnoughCredits), filesCount (No. of files), credits
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/submitImage/} 
#' @examples \dontrun{
#' submitImage(file_path="/images/image1.png",taskId="task_id",pdfPassword="pdf_password")
#' }

submitImage <- function(file_path=NULL, taskId="", pdfPassword=""){
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	
	if(is.null(file_path)) stop("Must specify file_path")
	
	# The API doesn't handle taskId="" and that is just as well as new task is created
	if(taskId=="") querylist = list(pdfPassword=pdfPassword)
	else querylist = list(taskId = taskId, pdfPassword=pdfPassword)

	res <- httr::POST("https://cloud.ocrsdk.com/submitImage", httr::authenticate(app_id, app_pass), query=querylist, body=httr::upload_file(file_path))
	httr::stop_for_status(res)
	submitdetails <- XML::xmlToList(httr::content(res))
	
	resdf <- do.call(rbind.data.frame, submitdetails) # collapse to a data.frame
	names(resdf) <- names(submitdetails[[1]])
	row.names(resdf) <- 1

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")
	cat("Task ID: ", 			resdf$id, "\n")

	return(invisible(resdf))
}