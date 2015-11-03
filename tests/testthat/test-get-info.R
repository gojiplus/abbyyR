context("Create Batch")

token <- c(Sys.getenv('AbbyyAppId'), Sys.getenv('AbbyyAppPassword'))

test_that("getAppInfo happens successfully", {
  skip_on_cran()
  setapp(token)
  get_info <- getAppInfo()
  expect_that(get_info, is_a("list"))
})