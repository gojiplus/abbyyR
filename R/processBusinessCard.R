#' Process Business Card
#'
#' This function gets Information about a particular application
#' @param file_path path of the document
#' @param language optional, default: English
#' @param imageSource  optional, default: auto
#' @param correctOrientation  optional, default: true
#' @param correctSkew optional, default: true
#' @param exportFormat  optional, default: "vCard"
#' @param pdfPassword  optional, default: NULL
#' @param description  optional, default: ""
#' @keywords Process Remote Image
#' @return Data frame with details of the task associated with the submitted Business Card
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/processBusinessCard/}
#' @examples \dontrun{
#' processBusinessCard(file_path="file_path", language="English")
#' }

processBusinessCard <- function(file_path=NULL, language="English", imageSource="auto", correctOrientation="true", 
						correctSkew="true",exportFormat="vCard", description="", pdfPassword=""){

	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	
	if(is.null(file_path)) stop("Must specify file_path")
	
	querylist = list(language=language, imageSource=imageSource, correctOrientation=correctOrientation, 
					 correctSkew=correctSkew,exportFormat=exportFormat, description=description, pdfPassword=pdfPassword)
	
	res <- POST("http://cloud.ocrsdk.com/processBusinessCard", authenticate(app_id, app_pass), query=querylist, body=upload_file(file_path))
	stop_for_status(res)
	processdetails <- xmlToList(httr::content(res))
	
	resdf <- do.call(rbind.data.frame, processdetails) # collapse to a data.frame
	names(resdf) <- names(processdetails[[1]])[1:length(resdf)] # names for the df, adjust for <7
	row.names(resdf) <- 1:nrow(resdf)	# row.names for the df

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")
	cat("Task ID: ", 			resdf$id, "\n")

	return(invisible(resdf))
}
