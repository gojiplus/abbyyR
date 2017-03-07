#' List Tasks
#'
#' List all the tasks in the application. You can specify a date range and whether or not you want to include deleted tasks. 
#' The function prints total number of tasks and no. of finished tasks by default. 
#' 
#' @param fromDate Optional; format: yyyy-mm-ddThh:mm:ssZ
#' @param toDate Optional;   format: yyyy-mm-ddThh:mm:ssZ
#' @param excludeDeleted Optional; Boolean, Default=FALSE
#' @param \dots Additional arguments passed to \code{\link{abbyy_GET}}.
#' 
#' @return A \code{data.frame} with the following columns: id (task id), registrationTime, statusChangeTime, status 
#' 		   (Submitted, Queued, InProgress, Completed, ProcessingFailed, Deleted, NotEnoughCredits), filesCount (No. of files), 
#'         credits, resultUrl (URL for the processed file)). If no tasks are finished, the last column (resultUrl) isn't returned.
#' 
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/listTasks/}
#' 
#' @usage listTasks(fromDate=NULL, toDate=NULL, excludeDeleted = FALSE, ...)
#' 
#' @examples \dontrun{
#' listTasks()
#' listTasks(fromDate="2015-11-10T00:00:00Z", toDate="2016-11-10T00:00:00Z")
#' listTasks(fromDate="2015-11-10T00:00:00Z")
#' }

listTasks <- function(fromDate = NULL, toDate = NULL, excludeDeleted = FALSE, ...) {
	
	# Convert Bool to string
	exclude_deleted = 'false'
	if (identical(excludeDeleted, TRUE)) {
		exclude_deleted = 'true'
	} 

	# Check format 
	if (!identical(fromDate, NULL)) {
		if (!grepl("^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z", fromDate)) stop("Incorrect Date Format. See examples.")
	}

	if (!identical(toDate, NULL))  {
		 if (!grepl("^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z", toDate))  stop("Incorrect Date Format. See examples.")
	}

	querylist <- list(fromDate = fromDate, toDate = toDate, excludeDeleted = exclude_deleted)
	tasklist  <- abbyy_GET("listTasks", query = querylist, ...)

	# Converting list to a data.frame
	resdf   <- ldply(tasklist, rbind) 

	# Print some important things
	cat("Total No. of Tasks: ", nrow(resdf), "\n")
	cat("No. of Finished Tasks: ", ifelse(!("resultUrl" %in% names(resdf)), 0, sum(!is.na(resdf$resultUrl))), "\n")
  
  	# Return the data.frame
	resdf
}
