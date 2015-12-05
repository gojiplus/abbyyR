context("Submit Image")

token <- c(Sys.getenv('AbbyyAppId'), Sys.getenv('AbbyyAppPassword'))

image <- system.file("extdata/t1.png", package = "abbyyR")

test_that("submitImage happens successfully", {
  skip_on_cran()
  setapp(token)
  sub_img <- submitImage(file_path=image)
  expect_that(sub_img, is_a("data.frame"))
})