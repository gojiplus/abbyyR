#' @title abbyyR: R Client for the Abbyy Cloud OCR
#' 
#' @name abbyyR-package
#' @aliases abbyyR
#'
#' @description Easily OCR images, barcodes, forms, documents with machine readable zones, e.g. passports, right from R.
#' Get the results in any one of a wide variety of formats, from text to XML. 
#' The package provides access to Abbyy Cloud OCR -- see \url{http://ocrsdk.com/}. 
#' Details about results of calls to the API can be found at \url{http://ocrsdk.com/documentation/specifications/status-codes/}.
#'
#' To learn how to use abbyyR, see this vignette: \url{vignettes/Overview_of_abbyyR.html}. 
#' Or, see how to scrape text from a folder of static Wisconsin Ads storyboards: \url{vignettes/wiscads.html}.
#' 
#' You need to get credentials (application ID and password) to use this application. 
#' If you haven't already, get these at \url{http://ocrsdk.com/}.
#' 
#' @importFrom httr GET POST authenticate config stop_for_status upload_file content
#' @importFrom XML  xmlToList
#' @importFrom curl curl_download
#' @importFrom RecordLinkage levenshteinDist
#' @importFrom readr read_file
#' @docType package
#' @author Gaurav Sood
NULL
