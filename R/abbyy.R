#' \pkg{abbyyR} makes OCR easy.
#'
#' @name abbyyR
#' @description Easily OCR images, barcodes, forms, documents with machine readable zones, e.g. passports, right from R.
#' Get the results in form of text files or detailed XML. The package provides access to Abbyy OCR -- see \url{http://ocrsdk.com/}. 
#' Details about results of calls to the API can be found at \url{http://ocrsdk.com/documentation/specifications/status-codes/}
#' @importFrom httr GET POST authenticate config stop_for_status upload_file content
#' @importFrom XML  xmlToList
#' @importFrom curl curl_download
#' @docType package
#' @author Gaurav Sood
NULL
