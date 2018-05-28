# abbyyR 0.5.3

* add region argument to processImage()

# abbyyR 0.5.2

* extensive linting. passes expect_lint_free

# abbyyR 0.5.1

* moved to ldply for coercing list to data.frame
* improved documentation
* moved to match.arg
* making all returns visible

# abbyyR 0.5.0

* Pass more arguments (dots)
* StringsAsFactors issues for getresults fixed

# abbyyR 0.4.0

* compareText moved to R package recognize
* getAppInfo returns a data.frame
* Minor improvements to documentation
* listTasks checks date format, provides more examples
* Unique rownames for listFinishedTasks df
* Added progress bar for getResults()

# abbyyR 0.3.0

* getResults returns a data frame carrying local file paths after writing to disk  
* Simpler coercion to data frame for all lists of length 1, more standardized 'cats' for process functions  
* httr upgrade issues fixed  
* getResults accounts for the case when there are no finished tasks  

# abbyyR 0.2.3

* check if file exists  
* fixed bug in getResults()  
* fixed checking env. tokens  
* More unit tests, better coverage  
* compareText has been deprecated. Part of another package (recognize) on GitHub.  
* getResults allows saving to memory  

# abbyyR 0.2.2

* added basic test  
* processPhotoID is not completely supported by abbyy. Adjusted for that. Changed documentation.  
* getTaskStatus had a bug -- it is fixed now  
* Storing keys in environment than options  
* Took out the https link causing pandoc to break  

# abbyyR 0.2.1

* Better error handling  
* Better internal organization of functions  
* Added Readme  
* Vignettes via knitr  
* runs pdf via qpdf  

# abbyyR 0.2.0

* Improved How Authentication Information is Transmitted.  
* New Vignette  
* Download files via curl::curl_download rather than download.file  
* A function that gives you quality of OCR: compare human transcription to OCR output. String Distance.  
* Convenient functions to ocr a file.  
