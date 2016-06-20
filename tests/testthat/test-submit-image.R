context("Submit, Process Image")

samp_image <- system.file("extdata/t1.png", package = "abbyyR")

test_that("submitImage, processImage happens successfully", {
  skip_on_cran()
  
  token_file <- file("abbyy_key", "r")
  token <- suppressWarnings(readLines(token_file))
  close(token_file)
  setapp(unlist(strsplit(token, ",")))

  sub_img <- submitImage(file_path=samp_image)
  proc_img <- processImage(file_path=samp_image)

  expect_that(sub_img, is_a("data.frame"))
  expect_that(proc_img, is_a("data.frame"))
})