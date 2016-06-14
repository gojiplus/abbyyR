#' Submit Image
#'
#' Adds image to the existing task or creates a new task for the uploaded image. The new task isn't processed till processDocument or processFields is called.
#' @param file_path Required; Path to the document
#' @param taskId    Optional; Assigns image to the task ID specified. If an empty string is passed, a new task is created. 
#' @param pdfPassword Optional; If the pdf is password protected, put the password here.
#' @param \dots Additional arguments passed to \code{\link{abbyy_POST}}.
#' 
#' @return Data frame with all the details of the submitted image: id (task id), registrationTime, statusChangeTime, status (Submitted, Queued, InProgress, Completed, ProcessingFailed, Deleted, NotEnoughCredits), filesCount (No. of files), credits
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/submitImage/} 
#' @examples \dontrun{
#' submitImage(file_path="/images/image1.png", taskId="task_id", pdfPassword="pdf_password")
#' }

submitImage <- function(file_path="", taskId="", pdfPassword="", ...)
{
	
	if (!file.exists(file_path)) stop("File Doesn't Exist. Please check the path.")

	# The API doesn't handle taskId="" and that is just as well as new task is created
	if (taskId=="") {
		querylist = list(pdfPassword=pdfPassword)
	} else {
		querylist = list(taskId = taskId, pdfPassword=pdfPassword)
	}

	submit_details <- abbyy_POST("submitImage", query=querylist, body=upload_file(file_path), ...)
	
	resdf <- as.data.frame(do.call(rbind, submit_details))

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")
	cat("Task ID: ", 			resdf$id, "\n")

	return(invisible(resdf))
}