#' Process Document 
#'
#' This function processes several images for the same task and results in a multi-page document. 
#' For instance, upload pages of the book individually via submitImage to the same task. And then process it via ProcessDocument to get a multi-page pdf.
#' @param taskId - Only tasks with Submitted, Completed or NotEnoughCredits status can be processed using this function.
#' @param language  Optional; default: English
#' @param profile   Optional; default: documentConversion
#' @param textType  Optional; default: normal
#' @param imageSource  Optional; default: auto
#' @param correctOrientation  Optional; default: true
#' @param correctSkew Optional; default: true
#' @param readBarcodes  Optional; default: 
#' @param exportFormat  Optional; default: txt
#' @param pdfPassword  Optional; default: NULL
#' @param description  Optional; default: ""
#' @return Data frame with details of the task associated with the submitted Document
#' @export 
#' @references \url{http://ocrsdk.com/documentation/apireference/processDocument/}
#' @examples \dontrun{
#' processDocument(taskId = "task_id")
#' }

processDocument <- function(taskId = NULL, language="English", profile="documentConversion",textType="normal", imageSource="auto", correctOrientation="true", 
						correctSkew="true",readBarcodes="false",exportFormat="txt", description=NULL, pdfPassword=NULL){
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	
	querylist = list(taskId = taskId, language=language, profile=profile,textType=textType, imageSource=imageSource, correctOrientation=correctOrientation, 
						correctSkew=correctSkew,readBarcodes=readBarcodes,exportFormat=exportFormat, description=description, pdfPassword=pdfPassword)
	res <- httr::GET("http://cloud.ocrsdk.com/processDocument", httr::authenticate(app_id, app_pass), query=querylist)
	httr::stop_for_status(res)
	processdetails <- XML::xmlToList(httr::content(res))
	
	resdf <- do.call(rbind.data.frame, processdetails) # collapse to a data.frame
	names(resdf) <- names(processdetails[[1]])
	row.names(resdf) <- 1:nrow(resdf)	# row.names for the df

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")

	return(invisible(resdf))
}