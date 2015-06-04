### Access AbbyyFine Cloud API via R

To get going, get the application id and password from [http://ocrsdk.com/](http://ocrsdk.com/).

### Installation

To get the current development version from github:

```{r}
# install.packages("devtools")
devtools::install_github("soodoku/abbyyR")

```

### Running
To use the package, first set application id and password via the `setapp` function.

```{r}
setapp(c("app_id", "app_password"))
```

### Functions

**getAppInfo**

Get Information about the Application including details like: Name of the Application, No. of pages remaining (given the money), No. of fields remaining (given the money), and when the application credits expire. The function automatically prints these out. It also stores these in a list.

For some details, see the Abbyy FineReader [Reference](http://ocrsdk.com/documentation/apireference/getApplicationInfo/) for the function.

```{r}
getAppInfo()
```

**listTasks**

List all the tasks in the application. You can specify a date range and whether or not you want to include deleted tasks. The function prints Total number of tasks, Task IDs, and No. of Finished Tasks. The function returns a data.frame with the following columns: id (task id), registrationTime, statusChangeTime, status (Completed, Submitted), filesCount (No. of files), credits, resultUrl (URL for the processed file). 

For some details, see the Abbyy FineReader [Reference](http://ocrsdk.com/documentation/apireference/listTasks/) for the function.

```{r}
listTasks(fromDate="yyyy-mm-ddThh:mm:ssZ",toDate="yyyy-mm-ddThh:mm:ssZ",excludeDeleted="false")
```

**listFinishedTasks**

List all the finished tasks in the application. "The tasks are ordered by the time of the end of processing. No more than 100 tasks can be returned at one method call." (From Abbyy FineReader). The function returns a data.frame with the following columns: id (task id), registrationTime, statusChangeTime, status (Completed, Submitted), filesCount (No. of files), credits, resultUrl (URL for the processed file).

For some details, see the Abbyy FineReader [Reference](http://ocrsdk.com/documentation/apireference/listFinishedTasks/) for the function.

```{r}
listFinishedTasks()
```

**getTaskStatus**

Get status of a particular task.

For some details, see the Abbyy FineReader [Reference](http://ocrsdk.com/documentation/apireference/getTaskStatus/) for the function.

```{r}
getTaskStatus(taskId="task_id")
```

**deleteTask**

Delete a task and related data.

For some details, see the Abbyy FineReader [Reference](http://ocrsdk.com/documentation/apireference/deleteTask/) for the function.

```{r}
deleteTask(taskId="task_id")
```

#### License
Scripts are released under the [GNU V3](License.md).
