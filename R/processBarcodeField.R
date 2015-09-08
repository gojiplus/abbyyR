#' Process Bar Code Field
#'
#' This function gets Information about a particular application
#' @param file_path path of the document
#' @param barcodeType optional, default: "autodetect"
#' @param region coordinates of region from top left, 4 values: top left bottom right; optional; default: "-1,-1,-1,-1" (entire image) 
#' @param containsBinaryData   optional, default: "false"
#' @param pdfPassword  optional, default: ""
#' @param description  optional, default: ""
#' @return Data frame with details of the task associated with the submitted Image
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/processBarcodeField/}
#' @examples \dontrun{
#' processBarcodeField(file_path="file_path")
#' }

processBarcodeField <- function(file_path=NULL, barcodeType="autodetect", region="-1,-1,-1,-1",containsBinaryData="false",pdfPassword="",description=""){
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	
	if(is.null(file_path)) stop("Must specify file_path")

	querylist = list(barcodeType=barcodeType, region=region,containsBinaryData=containsBinaryData,pdfPassword=pdfPassword,description=description)
	res <- POST("http://cloud.ocrsdk.com/processBarcodeField", authenticate(app_id, app_pass), query=querylist, body=upload_file(file_path))
	stop_for_status(res)
	processdetails <- xmlToList(content(res))
	
	resdf <- do.call(rbind.data.frame, processdetails) # collapse to a data.frame
	names(resdf) <- names(processdetails[[1]])[1:length(resdf)] # names for the df, adjust for <7
	row.names(resdf) <- 1:nrow(resdf)	# row.names for the df

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")
	cat("Task ID: ", 			resdf$id, "\n")

	return(invisible(resdf))
}