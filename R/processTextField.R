#' Process Text Field
#'
#' This function gets Information about a particular application
#' @param file_path path of the document
#' @param region coordinates of region from top left, 4 values: top left bottom right; optional; default: "-1,-1,-1,-1" (entire image) 
#' @param language optional; default: "English"
#' @param letterSet letterset to be used for recognition, set by language but can be customized; optional; default: ""
#' @param regExp which words are allowed in the field. see regular expression documentation; optional; default: ""
#' @param textType type of the text in the field including typewriter, handprinted; optional; default: "normal"
#' @param oneTextLine field contains only one text line or more; optional; default: "false"
#' @param oneWordPerTextLine field contains one word per line or not; optional; default: "false"
#' @param markingType only for handprint recognition, includes underlinedText etc.; optional; default: "simpleText"
#' @param placeholdersCount No. of character cells for the field; optional; default: "1"
#' @param writingStyle handprint writing style, see Abbyy FineReader documentation for values; optional; default: "default"
#' @param description Description of processing task; optional; default: ""
#' @param pdfPassword Password for pdf; optional; default: ""
#' @return Data frame with details of the task associated with the submitted Image
#' @export
#' @references \url{http://ocrsdk.com/documentation/apireference/processTextField/}
#' @references \url{http://ocrsdk.com/documentation/specifications/regular-expressions/}
#' @examples
#' # processTextField(file_path="file_path")

processTextField <- function(file_path=NULL, region="-1,-1,-1,-1", language="English", letterSet="", regExp="", textType="normal", oneTextLine="false", oneWordPerTextLine="false", 
							 markingType="simpleText", placeholdersCount="1", writingStyle="default", description="",pdfPassword=""){
	app_id=getOption("AbbyyAppId"); app_pass=getOption("AbbyyAppPassword")
	if(is.null(app_id) | is.null(app_pass)) stop("Please set application id and password using setapp(c('app_id', 'app_pass')).")
	
	if(is.null(file_path)) stop("Must specify file_path")
	querylist = list(language=language, letterSet=letterSet, regExp=regExp, textType=textType, oneTextLine=oneTextLine, oneWordPerTextLine=oneWordPerTextLine, 
							 markingType=markingType, placeholdersCount=placeholdersCount, writingStyle=writingStyle, description=description,pdfPassword=pdfPassword)
	
	res <- httr::POST("http://cloud.ocrsdk.com/processTextField", authenticate(app_id, app_pass), query=querylist, body=httr::upload_file(file_path))
	httr::stop_for_status(res)
	processdetails <- XML::xmlToList(httr::content(res))
	
	resdf <- do.call(rbind.data.frame, processdetails) # collapse to a data.frame
	names(resdf) <- names(processdetails[[1]])[1:length(resdf)] # names for the df, adjust for <7
	row.names(resdf) <- 1:nrow(resdf)	# row.names for the df

	# Print some important things
	cat("Status of the task: ", resdf$status, "\n")
	cat("Task ID: ", 			resdf$id, "\n")

	return(invisible(resdf))
}