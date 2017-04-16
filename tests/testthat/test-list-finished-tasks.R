context("List Finished Tasks")

test_that("listFinishedTasks happens successfully", {
  skip_on_cran()

  token_file <- file("abbyy_key", "r")
  token <- suppressWarnings(readLines(token_file))
  close(token_file)
  setapp(unlist(strsplit(token, ",")))

  list_fin_tasks <- listFinishedTasks()
  expect_that(list_fin_tasks, is_a("data.frame"))
})
