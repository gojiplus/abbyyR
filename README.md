## Access Abbyy Cloud OCR from R

[![Build Status](https://travis-ci.org/soodoku/abbyyR.svg?branch=master)](https://travis-ci.org/soodoku/abbyyR)
[![Appveyor Build status](https://ci.appveyor.com/api/projects/status/yh856e6cv7uucaj2?svg=true)](https://ci.appveyor.com/project/soodoku/abbyyR)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/abbyyR)](https://cran.r-project.org/package=abbyyR)
![](http://cranlogs.r-pkg.org/badges/grand-total/abbyyR)
[![codecov](https://codecov.io/gh/soodoku/abbyyR/branch/master/graph/badge.svg)](https://codecov.io/gh/soodoku/abbyyR)

Easily OCR images, barcodes, forms, documents with machine readable zones, e.g. passports, right from R. Get the results in a wide variety of formats, from text files to detailed XMLs with information about bounding boxes, etc.

The package provides access to the [Abbyy Cloud OCR SDK API](http://ocrsdk.com/). Details about results of calls to the API can be [found here](http://ocrsdk.com/documentation/specifications/status-codes/).

### Installation

To get the latest version on CRAN:
```r
install.packages("abbyyR")
```

To get the current development version from GitHub:

```r
# install.packages("devtools")
devtools::install_github("soodoku/abbyyR", build_vignettes = TRUE)
```

### Using abbyyR

To get acquainted with some of the important functions, read the vignettes:

```r
# Overview of the package
vignette("introduction", package = "abbyyR")
# some functions are used along with output
vignette("example", package = "abbyyR")
# how to scrape text from a folder of images
vignette("wiscads", package = "abbyyR")
```

The final output quality varies by complexity of the layout to resolution to font face etc. To measure the final quality of ocr, you can measure the edit distance to `gold standard' coded sample using [recognize](https://github.com/soodoku/recognize). To do quick edit distance based search and replace to fix messy data, you can use [turbo search and replace](https://github.com/soodoku/search-and-replace).

### License
Scripts are released under the [MIT License](https://opensource.org/licenses/MIT).

### Contributor Code of Conduct

The project welcomes contributions from everyone! In fact, it depends on it. To maintain this welcoming atmosphere, and to collaborate in a fun and productive way, we expect contributors to the project to abide by the [Contributor Code of Conduct](http://contributor-covenant.org/version/1/0/0/).