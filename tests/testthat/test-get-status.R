context("Get Status")

token <- c(Sys.getenv('AbbyyAppId'), Sys.getenv('AbbyyAppPassword'))

test_that("getTaskStatus works", {
  skip_on_cran()
  setapp(token)
  Sys.setenv("R_TESTS" = "")
  tasks <- listTasks()
  look_this_up <- tasks$id[1]
  task_status <- getTaskStatus(look_this_up)
  expect_that(task_status, is_a("data.frame"))
})