context("List Tasks")

test_that("listTasks happens successfully", {
  skip_on_cran()

  token_file <- file("abbyy_key", "r")
  token <- suppressWarnings(readLines(token_file))
  close(token_file)
  setapp(unlist(strsplit(token, ",")))

  list_tasks <- listTasks()
  expect_that(listTasks(), is_a("data.frame"))

  if (nrow(list_tasks) > 0 ) {
  # Task Status
  task_status <- getTaskStatus(list_tasks[1, 2])
  expect_that(task_status, is_a("data.frame"))

  # Delete Task
  ready_to_delete <- list_tasks[list_tasks$status == "Completed", ]
  del_task <- deleteTask(ready_to_delete[1, 2])
  expect_that(del_task, is_a("data.frame"))
  }
})
