context("Get Results")

test_that("getResults works", {

  skip_on_cran()

  token_file <- file("abbyy_key", "r")
  token <- suppressWarnings(readLines(token_file))
  close(token_file)
  setapp(unlist(strsplit(token, ",")))

  results <- getResults(save_to_file=FALSE)
  expect_that(results, is_a("data.frame"))
})