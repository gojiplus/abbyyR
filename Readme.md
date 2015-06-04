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

### Usage

Details about results of calls to AbbyyFine Cloud OCR SDK can be [found here](http://ocrsdk.com/documentation/specifications/status-codes/).

**getAppInfo**

Get Information about the Application including details like: Name of the Application, No. of pages remaining (given the money), No. of fields remaining (given the money), and when the application credits expire. The function automatically prints these out. It also stores these in a list.

For additional details about how Abbyy FineReader implements `getAppInfo`, see the [reference](http://ocrsdk.com/documentation/apireference/getApplicationInfo/) for the function.

```{r}
getAppInfo()

 
"
Sample Output:

Name of Application: test
No. of Pages Remaining: 99
No. of Fields Remaining: 495
Application Credits Expire on: 2015-08-28T00:00:00
Type: Normal
"

```

**listTasks**

List all the tasks in the application. You can specify a date range and whether or not you want to include deleted tasks. The function prints Total number of tasks, Task IDs, and No. of Finished Tasks. The function returns a data.frame with the following columns: id (task id), registrationTime, statusChangeTime, [status](http://ocrsdk.com/documentation/specifications/task-statuses/) (Submitted, Queued, InProgress, Completed, ProcessingFailed, Deleted, NotEnoughCredits), filesCount (No. of files), credits, resultUrl (URL for the processed file). 

For additional details about how Abbyy FineReader implements `listTasks`, see the [reference](http://ocrsdk.com/documentation/apireference/listTasks/) for the function.

```{r}
listTasks(fromDate="yyyy-mm-ddThh:mm:ssZ",toDate="yyyy-mm-ddThh:mm:ssZ",excludeDeleted="false")
```

**listFinishedTasks**

List all the finished tasks in the application. "The tasks are ordered by the time of the end of processing. No more than 100 tasks can be returned at one method call." (From Abbyy FineReader). The function returns a data.frame with the following columns: id (task id), registrationTime, statusChangeTime, [status](http://ocrsdk.com/documentation/specifications/task-statuses/) (Submitted, Queued, InProgress, Completed, ProcessingFailed, Deleted, NotEnoughCredits), filesCount (No. of files), credits, resultUrl (URL for the processed file).

For additional details about how Abbyy FineReader implements `listFinishedTasks`, see the [reference](http://ocrsdk.com/documentation/apireference/listFinishedTasks/) for the function.

```{r}
listFinishedTasks()
```

**getTaskStatus**

The function gets task status for a particular task ID. The function prints the status of the task by default. The function returns a data.frame with all the task details: id (task id), registrationTime, statusChangeTime, [status](http://ocrsdk.com/documentation/specifications/task-statuses/) (Submitted, Queued, InProgress, Completed, ProcessingFailed, Deleted, NotEnoughCredits), filesCount (No. of files), credits, resultUrl (URL for the processed file if applicable).


For additional details about how Abbyy FineReader implements `getTaskStatus`, see the [reference](http://ocrsdk.com/documentation/apireference/getTaskStatus/) for the function.

```{r}
getTaskStatus(taskId="task_id")
```

**deleteTask**

This function deletes a particular task and associated data. From Abbyy "If you try to delete the task that has already been deleted, the successful response is returned." The function by default prints the status of the task you are trying to delete. It will show up as 'deleted' if successful. The function returns a data.frame with all the details of the task you are trying to delete: id (task id), registrationTime, statusChangeTime, [status](http://ocrsdk.com/documentation/specifications/task-statuses/) (Submitted, Queued, InProgress, Completed, ProcessingFailed, Deleted, NotEnoughCredits), filesCount (No. of files), credits, resultUrl (URL for the processed file if applicable)

For additional details about how Abbyy FineReader implements `deleteTask`, see the [reference](http://ocrsdk.com/documentation/apireference/deleteTask/) for the function.

```{r}
deleteTask(taskId="task_id")
```

**submitImage**

Adds image to the existing task or creates a new task for the uploaded image. The new task isn't processed till processDocument or processFields is called (via Abbyy FineReader). The function takes two optional arguments, taskId (assigns image to the task ID specified. If empty string is passed, a new task is created) and pdfPassword (If the pdf is password protected). The function returns a data.frame with all the details of the submitted image: id (task id), registrationTime, statusChangeTime, [status](http://ocrsdk.com/documentation/specifications/task-statuses/) (Submitted, Queued, InProgress, Completed, ProcessingFailed, Deleted, NotEnoughCredits), filesCount (No. of files), credits,  estimatedProcessingTime

For additional details about how Abbyy FineReader implements `submitImage`, see the [reference](http://ocrsdk.com/documentation/apireference/submitImage/) for the function.

```{r}
submitImage(taskId="task_id")
```

**processImage**

Adds image to the existing task or creates a new task for the uploaded image. The new task isn't processed till processDocument or processFields is called (via Abbyy FineReader). The function takes two optional arguments, taskId (assigns image to the task ID specified. If an empty string is passed, a new task is created) and pdfPassword (If the pdf is password protected). The function returns a data.frame with all the details of the submitted image: id (task id), registrationTime, statusChangeTime, [status](http://ocrsdk.com/documentation/specifications/task-statuses/) (Submitted, Queued, InProgress, Completed, ProcessingFailed, Deleted, NotEnoughCredits), filesCount (No. of files), credits

For supported file formats, see [Supported File Formats](http://ocrsdk.com/documentation/specifications/image-formats/). For additional details about how Abbyy FineReader implements `processImage`, see the [reference](http://ocrsdk.com/documentation/apireference/processImage/) for the function.

```{r}
processImage(file_path="file_path", language="English", profile="documentConversion")
```

**processRemoteImage**

Same as processImage except the function takes image url as a required argument.

For supported file formats, see [Supported File Formats](http://ocrsdk.com/documentation/specifications/image-formats/). For additional details about how Abbyy FineReader implements `processImage`, see the [reference](http://ocrsdk.com/documentation/apireference/processRemoteImage/) for the function.

```{r}
processRemoteImage(img_url="img_url", language="English", profile="documentConversion")
```

**processDocument**

This function processes several images for the same task and results in a multi-page document. For instance, upload pages of the book individually via submitImage to the same task. And then process it via ProcessDocument to get a multi-page pdf.

For additional details about how Abbyy FineReader implements `processDocument`, see the [reference](http://ocrsdk.com/documentation/apireference/processDocument/) for the function.

```{r}
processDocument(task_id="task_id")
```

**processBusinessCard**

For additional details about how Abbyy FineReader implements `processBusinessCard`, see the [reference](http://ocrsdk.com/documentation/apireference/processBusinessCard/) for the function.

```{r}
processBusinessCard(file_path="file_path")
```


**processTextField**

For additional details about how Abbyy FineReader implements `processTextField`, see the [reference](http://ocrsdk.com/documentation/apireference/processTextField/) for the function.

```{r}
processTextField(file_path="file_path")
```


**processBarcodeField**

For additional details about how Abbyy FineReader implements `processBarcodeField`, see the [reference](http://ocrsdk.com/documentation/apireference/processBarcodeField/) for the function.

```{r}
processBarcodeField(file_path="file_path")
```


**processCheckmarkField**

For additional details about how Abbyy FineReader implements `processCheckmarkField`, see the [reference](http://ocrsdk.com/documentation/apireference/processCheckmarkField/) for the function.

```{r}
processCheckmarkField(file_path="file_path")
```

**processFields**

For additional details about how Abbyy FineReader implements `processFields`, see the [reference](http://ocrsdk.com/documentation/apireference/processFields/) for the function.

```{r}
processFields(file_path="file_path")
```

**processMRZ**

Extract data from Machine Readable Zone.

Output may contain the following fields: MrzType, Line1, Line2, Line3, DocumentType, DocumentSubtype, IssuingCountry, LastName, GivenName, DocumentNumber, DocumentNumberVerified, DocumentNumberCheck, Nationality, BirthDate, BirthDateVerified

For supported file formats, see [Supported File Formats](http://ocrsdk.com/documentation/specifications/image-formats/). For additional details about how Abbyy FineReader implements `processMRZ`, see the [reference](http://ocrsdk.com/documentation/apireference/processMRZ/) for the function.

```{r}
processMRZ(file_path="file_path")
```

#### License
Scripts are released under the [GNU V3](License.md).


