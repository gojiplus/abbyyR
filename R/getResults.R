#' Get Results
#'
#' Get data from all the processed images.
#' 
#' The function calls \code{\link{listFinishedTasks}}, goes through the finishedTasks data frame and downloads all the files in resultsUrl
#' Results can be stored in memory or written to the hard disk. By default, the function writes to the disk. 
#' If the user wants the results to be written to disk, a data frame with paths to local file paths is returned. If the user wants to store the 
#' results in memory, data frame with a column carrying the results is returned. 
#' 
#' @param output Optional; folder to which you want to save the data from the processed images; Default is same folder as the script
#' @param save_to_file Required; Default is TRUE; If true, it saves to file. Otherwise returns a data frame with results + other attributes from Abbyy
#' @return data frame returned by \code{\link{listFinishedTasks}} plus either a column that contains paths to local files (when writing to disk), 
#' or actual results returned.   
#' 
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/getTaskStatus/}
#' 
#' @usage getResults(output="", save_to_file=TRUE)
#' 
#' @examples \dontrun{
#' getResults(save_to_file=FALSE)
#' }

getResults <- function(output="./", save_to_file=TRUE) {

	finished_list <- listFinishedTasks()
	
	if (nrow(finished_list) == 0) {

		cat("No Finished Tasks")

	} else {

		# Set progress bar
		pb <- progress_bar$new(total = nrow(finished_list))

		if (!save_to_file) {
			# Add additional col. to finished_list
			finished_list$results <- NA
			
			for (i in seq_along(1:nrow(finished_list))) 
			{
				url <- as.character(finished_list$resultUrl[i])
				temp <- curl_fetch_memory(url)
				finished_list$results[i] <- rawToChar(temp$content)
				pb$tick()
			}

			return(invisible(finished_list))
		}

		finished_list$local_file_path <- NA

		for (i in seq_along(1:nrow(finished_list))) 
		{
			curl_download(as.character(finished_list$resultUrl[i]), destfile=paste0(output, finished_list$id[i]))
			finished_list$local_file_path[i] <- paste0(output, finished_list$id[i])
			pb$tick()
		}
	}
	
	finished_list
}
