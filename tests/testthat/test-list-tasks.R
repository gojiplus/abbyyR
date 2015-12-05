context("List Tasks")

token <- c(Sys.getenv('AbbyyAppId'), Sys.getenv('AbbyyAppPassword'))

test_that("listTasks happens successfully", {
  skip_on_cran()
  setapp(token)
  list_tasks <- listTasks()
  expect_that(listTasks(), is_a("data.frame"))
})