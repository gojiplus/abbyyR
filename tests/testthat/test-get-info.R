context("Get App Info.")

test_that("getAppInfo happens successfully", {
  skip_on_cran()

  token_file <- file("abbyy_key", "r")
  token <- suppressWarnings(readLines(token_file))
  close(token_file)
  setapp(unlist(strsplit(token, ",")))
  
  get_info <- getAppInfo()
  expect_that(get_info, is_a("list"))
})