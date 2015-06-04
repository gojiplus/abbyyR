### Access AbbyyFine Cloud API via R

To get going, get the application id and password from [http://ocrsdk.com/](http://ocrsdk.com/).

### Installation

To get the current development version from github:

```{r}
# install.packages("devtools")
devtools::install_github("soodoku/abbyyR")

```

### Running
To use the package, set application id and password via the `setapp` function.

```{r}
setapp(c("app_id", "app_password"))
```

### Functions

**getAppInfo**

Get Information about the Application including details like: Name of the Application, No. of pages remaining (given the money), No. of fields remaining (given the money), and when the application credits expire. The function automatically prints these out. It also stores these in a list.

**Note:** You must set your application id and password via the `setapp` function before you use this function.

```{r}
getAppInfo()
```

**listTasks**

List all the tasks in the application. You can specify a date range. The function returns a data.frame with the following columns: id (task id), registrationTime, statusChangeTime (), status (), filesCount (), credits, resultUrl

**Note:** You must set your application id and password via the `setapp` function before you use this function.

```{r}
listTasks(fromDate="yyyy-mm-ddThh:mm:ssZ",toDate="yyyy-mm-ddThh:mm:ssZ")
```

**listFinishedTasks**

List all the tasks that are finished.

**Note:** You must set your application id and password via the `setapp` function before you use this function.

```{r}
listFinishedTasks()
```

**getTaskStatus**

Get status of a particular task.

**Note:** You must set your application id and password via the `setapp` function before you use this function.

```{r}
getTaskStatus(taskId="task_id")
```

**deleteTask**

Delete a task.

**Note:** You must set your application id and password via the `setapp` function before you use this function.

```{r}
deleteTask(taskId="task_id")
```

#### License
Scripts are released under the [GNU V3](License.md).
