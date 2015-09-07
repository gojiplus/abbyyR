### Access Abbyy Cloud OCR SDK API via R

[![GPL-3.0](http://img.shields.io/:license-gpl-blue.svg)](http://opensource.org/licenses/GPL-3.0)
[![Build Status](https://travis-ci.org/soodoku/abbyyR.svg?branch=master)](https://travis-ci.org/soodoku/abbyyR)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/abbyyR)](http://cran.r-project.org/web/packages/abbyyR)
![](http://cranlogs.r-pkg.org/badges/abbyyR)

Easily OCR images, barcodes, forms, documents with machine readable zones, e.g. passports, right from R. Get the results in form of text files or detailed XML.
The package provides access to the [Abbyy Cloud OCR SDK API](http://ocrsdk.com/). Details about results of calls to the API can be [found here](http://ocrsdk.com/documentation/specifications/status-codes/).

### Installation

To get the current development version from github:

```{r install}
# install.packages("devtools")
devtools::install_github("soodoku/abbyyR")
```

### Usage

Learn how to use abbyyR with a vignette that gives you an [overview of the package](vignettes/Overview of abbyyR.md). Or, see an applied example of scraping text from [static Wisconsin Ads storyboards](wiscads.Rmd).

#### License
Scripts are released under [GNU V3](http://www.gnu.org/licenses/gpl-3.0.en.html).