#' @title abbyyR: R Client for the Abbyy Cloud OCR
#' 
#' @name abbyyR-package
#' @aliases abbyyR
#'
#' @description OCR images, barcodes, forms, documents with machine readable zones, e.g. passports, right from R.
#' Get the results in any one of a wide variety of formats, from text to XML. 
#' The package provides access to Abbyy Cloud OCR. For more information, see \url{http://ocrsdk.com/}. 
#' Details about results of calls to the API can be found at \url{http://ocrsdk.com/documentation/specifications/status-codes/}.
#'
#' To learn how to use abbyyR, see this vignette: \url{vignettes/Overview_of_abbyyR.html}. 
#' Or, see how to scrape text from a folder of static Wisconsin Ads storyboards: \url{vignettes/wiscads.html}.
#' 
#' You need to get credentials (application ID and password) to use this application. 
#' If you haven't already, get these at \url{http://ocrsdk.com/}. And set these using \code{\link{setapp}}
#' 
#' @importFrom utils read.table
#' @importFrom stats setNames
#' @importFrom httr GET POST authenticate config stop_for_status upload_file content
#' @importFrom XML  xmlToList
#' @importFrom curl curl_download curl_fetch_memory
#' @importFrom progress progress_bar
#' @importFrom readr read_file
#' @importFrom plyr ldply
#' @docType package
#' @author Gaurav Sood
NULL


#' 
#' Base POST AND GET functions. Not exported.

#'
#' GET
#' 
#' @param path path to specific API request URL 
#' @param query query list 
#' @param \dots Additional arguments passed to \code{\link[httr]{GET}}.
#' 
#' @return list

abbyy_GET <- function(path, query, ...) {

  app_id <- Sys.getenv("AbbyyAppId")
  app_pass <- Sys.getenv("AbbyyAppPassword")

  if (identical(app_id, "") | identical(app_pass, "")) {
    stop("Please set application id and password using
          setapp(c('app_id', 'app_pass')).")
  }

  auth <- authenticate(app_id, app_pass)
  res <- GET("https://cloud.ocrsdk.com/", path = path, auth, query = query, ...)
  abbyy_check(res)
  res <- xmlToList(content(res, as = "text"))

  res
}


#'
#' POST
#' 
#' @param path path to specific API request URL 
#' @param query query list
#' @param body passing image through body 
#' @param \dots Additional arguments passed to \code{\link[httr]{POST}}.
#' 
#' @return list

abbyy_POST <- function(path, query, body = "", ...) {

  app_id <- Sys.getenv("AbbyyAppId")
  app_pass <- Sys.getenv("AbbyyAppPassword")

  if (identical(app_id, "") | identical(app_pass, "")) {
    stop("Please set application id and password using
          setapp(c('app_id', 'app_pass')).")
  }

  auth <- authenticate(app_id, app_pass)
  res <- POST("https://cloud.ocrsdk.com/",
         path = path,
         auth,
         query = query,
         body = body, ...)
  abbyy_check(res)
  res <- xmlToList(content(res, as = "text"))

  res
}

#'
#' Request Response Verification
#' 
#' @param  req request
#' @return in case of failure, a message

abbyy_check <- function(req) {

  if (req$status_code < 400) return(invisible())

  stop("HTTP failure: ", req$status_code, "\n", call. = FALSE)
}
