context("List Finished Tasks")

token <- c(Sys.getenv('AbbyyAppId'), Sys.getenv('AbbyyAppPassword'))

test_that("listFinishedTasks happens successfully", {
  skip_on_cran()
  setapp(token)
  list_fin_tasks <- listFinishedTasks()
  expect_that(list_fin_tasks, is_a("data.frame"))
})