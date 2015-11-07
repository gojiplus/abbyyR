#' processCheckmarkField Method
#'
#' This function gets Information about a particular application
#' 
#' @param file_path required, path of the document, default: ""
#' @param checkmarkType optional, default: "empty"
#' @param region coordinates of region from top left, 4 values: top left bottom right; optional; default: "-1,-1,-1,-1" (entire image) 
#' @param correctionAllowed  optional, default: "false"
#' @param pdfPassword  optional, default: ""
#' @param description  optional, default: ""
#' @return Data frame with details of the task associated with the submitted Image
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/processCheckmarkField/}
#' @examples \dontrun{
#' processCheckmarkField(file_path="file_path")
#' }

processCheckmarkField <- function(file_path="",checkmarkType="empty",  region="-1,-1,-1,-1",correctionAllowed="false", pdfPassword="",description="") {

	if(!file.exists(file_path)) stop("File Doesn't Exist. Please check the path.")

	querylist = list(checkmarkType=checkmarkType, region=region,correctionAllowed=correctionAllowed,pdfPassword=pdfPassword,description=description)
	
	body=upload_file(file_path)
	processdetails <- abbyy_POST("processCheckmarkField", query=querylist, body=body)
	
	resdf <- do.call(rbind.data.frame, processdetails) # collapse to a data.frame
	names(resdf) <- names(processdetails[[1]])[1:length(resdf)] # names for the df, adjust for <7
	row.names(resdf) <- 1:nrow(resdf)	# row.names for the df

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")

	return(invisible(resdf))
}