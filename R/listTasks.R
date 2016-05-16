#' List Tasks
#'
#' List all the tasks in the application. You can specify a date range and whether or not you want to include deleted tasks. 
#' The function prints total number of tasks and no. of finished tasks by default. 
#' 
#' @param fromDate Optional; format: yyyy-mm-ddThh:mm:ssZ
#' @param toDate Optional;   format: yyyy-mm-ddThh:mm:ssZ
#' @param excludeDeleted Optional; Boolean, Default=FALSE
#' 
#' @return A data.frame with the following columns: id (task id), registrationTime, statusChangeTime, status 
#' 		   (Submitted, Queued, InProgress, Completed, ProcessingFailed, Deleted, NotEnoughCredits), filesCount (No. of files), 
#'         credits, resultUrl (URL for the processed file)). 
#' 
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/getApplicationInfo/}
#' 
#' @usage listTasks(fromDate=NULL, toDate=NULL, excludeDeleted = FALSE)
#' 
#' @examples \dontrun{
#' listTasks()
#' listTasks(fromDate="2015-11-10T00:00:00Z", toDate="2016-11-10T00:00:00Z")
#' listTasks(fromDate="2015-11-10T00:00:00Z")
#' }

listTasks <- function(fromDate=NULL, toDate=NULL, excludeDeleted=FALSE) {
	
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
	tasklist  <- abbyy_GET("listTasks", query=querylist)

	# Names of return df.
	frame_names <- c("id", "registrationTime", "statusChangeTime", "status", "filesCount", "credits", "resultUrl")

	if (is.null(tasklist)){
		cat("No tasks in the application. \n")
		no_dat <- read.table(text = "", col.names = frame_names)
		return(invisible(no_dat))
	}

	# Converting list to a data.frame
	lenitem <- sapply(tasklist, length) # length of each list item
	resdf   <- setNames(do.call(rbind.data.frame, tasklist), frame_names) # collapse to a data.frame, wraps where lenitems < longest list (7) and set_names to frame_names
	#names(resdf) <- frame_names
	row.names(resdf) <- 1:nrow(resdf)	# row.names for the df
	resdf[lenitem == 6,7] <- NA 		# Fill NAs where lenitems falls short

	# Print some important things
	cat("Total No. of Tasks: ", nrow(resdf), "\n")
	cat("No. of Finished Tasks: ", sum(lenitem==7), "\n")
  
  	# Return the data.frame
	return(invisible(resdf))
}
