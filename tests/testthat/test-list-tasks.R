context("List Tasks")

token <- c(Sys.getenv('AbbyyAppId'), Sys.getenv('AbbyyAppPassword'))

test_that("listTasks happens successfully", {
  skip_on_cran()
  setapp(token)
  list_tasks <- listTasks()
  expect_that(listTasks(), is_a("data.frame"))
  if ( nrow(list_tasks) > 0 ) {
 	# Task Status
 	task_status <- getTaskStatus(list_tasks[1,1])
  	expect_that(task_status, is_a("data.frame"))
  
  	# Delete Task
  	del_task <- deleteTask(list_tasks[1,1])
  	expect_that(del_task, is_a("data.frame"))
  }
})