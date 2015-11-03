context("Create Batch")

test_that("batch creation happens successfully", {
  skip_on_cran()
  token <- readRDS("token_file.rds")
  setapp(token)
  get_info <- getAppInfo()
  expect_that(get_info, is_a("list"))
})