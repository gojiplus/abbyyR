#' processCheckmarkField Method
#'
#' This function gets Information about a particular application
#' @param file_path path of the document
#' @param checkmarkType optional, default: "empty"
#' @param region coordinates of region from top left, 4 values: top left bottom right; optional; default: "-1,-1,-1,-1" (entire image) 
#' @param correctionAllowed  optional, default: "false"
#' @param pdfPassword  optional, default: ""
#' @param description  optional, default: ""
#' @return Data frame with details of the task associated with the submitted Image
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/processCheckmarkField/}
#' @examples
#' # processCheckmarkField(file_path="file_path")

processCheckmarkField <- function(file_path=NULL,checkmarkType="empty",  region="-1,-1,-1,-1",correctionAllowed="false", pdfPassword="",description=""){
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	
	if(is.null(file_path)) stop("Must specify file_path")

	querylist = list(checkmarkType=checkmarkType, region=region,correctionAllowed=correctionAllowed,pdfPassword=pdfPassword,description=description)
	res <- httr::POST("http://cloud.ocrsdk.com/processCheckmarkField", authenticate(app_id, app_pass), query=querylist, body=httr::upload_file(file_path))
	httr::stop_for_status(res)
	processdetails <- XML::xmlToList(httr::content(res))
	
	resdf <- do.call(rbind.data.frame, processdetails) # collapse to a data.frame
	names(resdf) <- names(processdetails[[1]])[1:length(resdf)] # names for the df, adjust for <7
	row.names(resdf) <- 1:nrow(resdf)	# row.names for the df

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")

	return(invisible(resdf))
}