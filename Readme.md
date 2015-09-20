### Access Abbyy Cloud OCR from R

[![MIT](https://img.shields.io/github/license/mashape/apistatus.svg)](https://opensource.org/licenses/MIT)
[![Build Status](https://travis-ci.org/soodoku/abbyyR.svg?branch=master)](https://travis-ci.org/soodoku/abbyyR)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/abbyyR)](http://cran.r-project.org/web/packages/abbyyR)
![](http://cranlogs.r-pkg.org/badges/abbyyR)

Easily OCR images, barcodes, forms, documents with machine readable zones, e.g. passports, right from R. Get the results in a wide variety of formats, from text files to detailed XMLs with information about bounding boxes, etc.

The package provides access to the [Abbyy Cloud OCR SDK API](http://ocrsdk.com/). Details about results of calls to the API can be [found here](http://ocrsdk.com/documentation/specifications/status-codes/).

### Installation

To get the current development version from GitHub:

```{r install}
# install.packages("devtools")
devtools::install_github("soodoku/abbyyR")
```

### Using abbyyR

To get acquainted with some of the important functions, read the [overview of the package](vignettes/Overview_of_abbyyR.md). Or, see how [some functions are used along with output](vignettes/abbyyR_example.md). If you are looking for a hands-on example, see [how to scrape text from a folder of images](vignettes/wiscads.md) (static Wisconsin Ads storyboards).

#### License
Scripts are released under the [MIT License](https://opensource.org/licenses/MIT).
