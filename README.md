### Access Abbyy Cloud OCR from R

[![Build Status](https://travis-ci.org/soodoku/abbyyR.svg?branch=master)](https://travis-ci.org/soodoku/abbyyR)
[![Appveyor Build status](https://ci.appveyor.com/api/projects/status/yh856e6cv7uucaj2?svg=true)](https://ci.appveyor.com/project/soodoku/abbyyR)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/abbyyR)](http://cran.r-project.org/web/packages/abbyyR)
![](http://cranlogs.r-pkg.org/badges/grand-total/abbyyR)

Easily OCR images, barcodes, forms, documents with machine readable zones, e.g. passports, right from R. Get the results in a wide variety of formats, from text files to detailed XMLs with information about bounding boxes, etc.

The package provides access to the [Abbyy Cloud OCR SDK API](http://ocrsdk.com/). Details about results of calls to the API can be [found here](http://ocrsdk.com/documentation/specifications/status-codes/).

### Installation

To get the current development version from GitHub:

```{r install}
# install.packages("devtools")
devtools::install_github("soodoku/abbyyR", build_vignettes = TRUE)
```

### Using abbyyR

To get acquainted with some of the important functions, read the [overview of the package](vignettes/Overview_of_abbyyR.md). Or, see how [some functions are used along with output](vignettes/abbyyR_example.md). If you are looking for a hands-on example, see [how to scrape text from a folder of images](vignettes/wiscads.md) (static Wisconsin Ads storyboards).

The final output quality varies by complexity of the layout to resolution to font face etc. To measure the final quality of ocr, you can measure the edit distance to `gold standard' coded sample using [recognize](https://github.com/soodoku/recognize). To do quick complex search and replace to fix messy data, you can use [turbo search and replace](https://github.com/soodoku/search-and-replace).



#### License
Scripts are released under the [MIT License](https://opensource.org/licenses/MIT).
