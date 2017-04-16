#' List Finished Tasks
#'
#' @description List all the finished tasks in the application. 
#' 
#' The tasks are ordered by the time of the end of processing. 
#' No more than 100 tasks can be returned at one method call. 
#' The function prints number of finished tasks by default.
#' 
#' @param \dots Additional arguments passed to \code{\link{abbyy_GET}}.
#' 
#' @return A \code{data.frame} with the following columns: id (task id), registrationTime, statusChangeTime, 
#' status (Completed), filesCount (No. of files), credits, resultUrl (URL for the processed file)
#' 
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/listFinishedTasks/}
#' 
#' @examples \dontrun{
#' listFinishedTasks()
#' }

listFinishedTasks <- function(...) {
  
  tasklist <- abbyy_GET("listFinishedTasks", query = "", ...)  

  # Names of return df.
  frame_names <- c("id", "registrationTime", "statusChangeTime", "status", "filesCount", "credits", "resultUrl")

  if (is.null(tasklist)){
    cat("No finished tasks in the application. \n")
    no_dat <- read.table(text = "", col.names = frame_names)
    return(invisible(no_dat))
  }

  resdf <- ldply(tasklist, rbind) 
    
  # Print some important things
  cat("No. of Finished Tasks: ", nrow(resdf), "\n")

  resdf
}
