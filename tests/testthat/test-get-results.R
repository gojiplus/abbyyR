context("Get Results")

token <- c(Sys.getenv('AbbyyAppId'), Sys.getenv('AbbyyAppPassword'))

test_that("getResults works", {
  skip_on_cran()
  setapp(token)
  results <- getResults(save_to_file=FALSE)
  expect_that(results, is_a("list"))
})