### Access AbbyyFine Cloud API via R

To get going, get the application id and password from [http://ocrsdk.com/](http://ocrsdk.com/).

### Installation

To get the current development version from github:

```{r}
# install.packages("devtools")
devtools::install_github("soodoku/abbyyR")

```

### Running
To use the package, set application id and password:

```{r}
# Set 
setapp(c("app_id", "app_password"))

```

### Functions

Get Information about the Application including details like: Name of the Application, No. of pages remaining (given the money), No. of fields remaining (given the money), and when the application credits expire. The function automatically prints these out. It also stores these in a list.

Note: You must set your application id and password before you run this function.

```{r}

getAppInfo()

```

#### License
Scripts are released under the [GNU V3](License.md).
