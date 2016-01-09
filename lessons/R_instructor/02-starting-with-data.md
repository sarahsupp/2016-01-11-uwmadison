---
layout: lesson
root: ../..
---

# Learning Objectives
* load external data (CSV files) in memory using the survey table (surveys.csv) as an example
* explore the structure and the content of the data in R
* understand what are factors and how to manipulate them


The most common way that scientists store data is in Excel spreadsheets. While there are R packages designed to access data from Excel spreadsheets (e.g., gdata, RODBC, XLConnect, xlsx, RExcel), users often find it easier to save their spreadsheets in [comma-separated values](../../gloss.html#comma-separeted-values) files (CSV) and then use R's built in functionality to read and manipulate the data. In this short lesson, we'll learn how to read data from a .csv and write to a new .csv, and explore the [arguments](../../gloss.html#argument) that allow you read and write the data correctly for your needs.

## Presentation of the survey data
We are studying the species and weight of animals caught in plots in our study area. The dataset is stored as a csv file: each row holds information for a single animal, and the columns represent:

* Column 	Description
* record_id:	Unique id for the observation
* month: 	         month of observation
* day: 	           day of observation
* year: 	          year of observation
* plot_id: 	ID of a particular plot
* species_id: 	2-letter code
* sex: 	sex of animal (“M”, “F”)
* hindfoot_length: 	length of the hindfoot in mm
* weight: 	weight of the animal in grams
* genus: 	genus of animal
* species: 	species of animal
* taxa: 	e.g. Rodent, Reptile, Bird, Rabbit
* plot_type: 	type of plot

**There are a few different ways we can import data into RStudio** Let's first try downloading it directly from the web, since we know it lives on figshare.

We are going to use the R function download.file() to download the CSV file that contains the survey data from figshare, and we will use read.csv() to load into memory (as a data.frame) the content of the CSV file.

To download the data into the data/ subdirectory, do:

```r
download.file("http://files.figshare.com/2236372/combined.csv",
              "data/portal_data_joined.csv")
```

You are now ready to load the data into RStudio:

```r
surveys <- read.csv('data/portal_data_joined.csv')
```

**Remember**, this statement doesn’t produce any output because assignment doesn’t display anything. If we want to check that our data has been loaded, we can print the variable’s value: `surveys`

Alternatively, wrapping an assignment in parentheses will perform the assignment and display it at the same time.

```r
(surveys <- read.csv('data/portal_data_joined.csv'))
```
But we usually don't want to do this, especially if we have a really large dataset...

Wow… that was a lot of output. At least it means the data loaded properly. Let’s check the top (the first 6 lines) of this data.frame using the function `head()`:

```r
head(surveys)
```

####Challenge:
Do you remember how to read more about a function? Read.csv is a function that allows us to import the data from a csv file into our R program so that we can play with it.
* How many arguments did we apply to read.csv?
* Do you notice anything specific about the way we entered that argument? Why did we do it that way?
* Take one minute to look up the help for read.csv and explore the options - often we can import data as we just did, by simply pointing the program to the file, but R allows us to account for many different special cases or specifics about our data
* Do you think any of these could be especially useful to you in the future?

> **Tip:** The default delimiter of the read.csv() function is a comma, but you can use other delimiters by supplying the 'sep' argument to the function (e.g., typing `sep = ';'` allows a semi-colon separated file to be correctly imported -see ?read.csv() for more information on this and other options for working with different file types).

The call above will import the data, but we have not taken advantage of several handy arguments that can be helpful in loading the data in the format we want. Let's explore some of these arguments.


#### The header argument

The default for `read.csv(...)` is to set the `header` argument to `TRUE`. This means that the first row of values in the .csv is set as header information (column names). If your data set does not have a header, you can set the `header` argument to `FALSE`, and it will display the first row as data, and just make up default column names V1, V2, etc. 

Clearly this would not be the desired behavior for this data set, but it may be useful if you have a dataset without headers.


#### The stringsAsFactors argument
This is perhaps the most important argument in `read.csv()`, particularly if you are working with categorical data. This is because the default behavior of R is to convert character [string](../../gloss.html#string)s into factors, which may make it difficult to do such things as replace values later. For example, let's say we find out that the data collector was color blind, and accidentally recorded green cars as being blue. In order to correct the data set, let's replace 'Blue' with 'Green' in the `$Color` column:

<pre class='in'><code>surveys <- read.csv(file='surveys.csv', stringsAsFactors=FALSE)</code></pre>


#### The sep argument
Sometimes a .csv file might use spaces or tabs (or something else) as the delimiter. If you are using a file that has been saved in a different way, you can simply define it:

<pre class='in'><code>surveys<-read.csv(file='surveys.csv', sep=' ')</code></pre>


#### The strip.white argument
It is not uncommon for mistakes to have been made when the data were recorded, for example a space (whitespace) may have been inserted before a data value. By default this whitespace will be kept in the R environment, such that ' DO' will be recognized as a different value than 'DO'. In order to avoid this type of error, use the `strip.white` argument. 

We could import the data using the `strip.white` argument. NOTE - this argument must be accompanied by the `sep` argument, by which we indicate the type of delimiter in the file (the comma for most .csv files)

<pre class='in'><code>surveys<-read.csv(file='surveys.csv',stringsAsFactors=FALSE, strip.white=TRUE,sep=',')</code></pre>

***...Going back to the data...

Let’s now check the __str__ucture of this data.frame in more details with the function `str()`:

```r
str(surveys)
```

####Challenge:
Based on the output of str(surveys), can you answer the following questions?

* What is the class of the object surveys?
* How many rows and how many columns are in this object?
* How many species have been recorded during these surveys?

As you can see, the columns `species` and `sex` are of a special class called `factor`. Before we learn more about the `data.frame` class, we are going to talk about factors. They are very useful but not necessarily intuitive, and therefore require some attention.


## Factors

Factors are used to represent categorical data. Factors can be ordered or unordered and are an important class for statistical analysis and for plotting.

Factors are stored as integers, and have labels associated with these unique integers. While factors look (and often behave) like character vectors, they are actually integers under the hood, and you need to be careful when treating them like strings.

Once created, factors can only contain a pre-defined set values, known as *levels*. By default, R always sorts levels in alphabetical order. For instance, if you have a factor with 2 levels:

```r
sex <- factor(c("male", "female", "female", "male"))
```

R will assign `1` to the level `"female"` and `2` to the level `"male"` (because `f` comes before `m`, even though the first element in this vector is `"male"`). You can check this by using the function `levels()`, and check the number of levels using `nlevels()`:

```r
levels(sex)
nlevels(sex)
```

Sometimes, the order of the factors does not matter, other times you might want to specify the order because it is meaningful (e.g., “low”, “medium”, “high”) or it is required by particular type of analysis. Additionally, specifying the order of the levels allows us to compare levels:

```r
food <- factor(c("low", "high", "medium", "high", "low", "medium", "high"))
levels(food)
food <- factor(food, levels=c("low", "medium", "high"))
levels(food)
min(food) ## doesn't work
```

**Explain the output error from trying `min(food)`. Encourage students to try things and make mistakes - this is how we learn programming!**

```r
food <- factor(food, levels=c("low", "medium", "high"), ordered=TRUE)
levels(food)
min(food) ## works!
```

In R’s memory, these factors are represented by numbers (1, 2, 3). They are better than using simple integer labels because factors are self describing: "low", "medium", "high"" is more descriptive than 1, 2, 3. Which is low? You wouldn’t be able to tell with just integer data. Factors have this information built in. It is particularly helpful when there are many levels (like the species in our example data set).

## Converting factors
If you need to convert a factor to a character vector, simply use `as.character(x)`.

Converting a factor to a numeric vector is however a little trickier, and you have to go via a character vector. Compare:

```r
f <- factor(c(1, 5, 10, 2))
as.numeric(f)               ## wrong! and there is no warning...
as.numeric(as.character(f)) ## works...
as.numeric(levels(f))[f]    ## The recommended way.
```

#### Challenge
The function `table()` tabulates observations and can be used to create bar plots quickly. For instance:

```r
exprmt <- factor(c("treat1", "treat2", "treat1", "treat3", "treat1", "control",
                   "treat1", "treat2", "treat3"))
table(exprmt)
```

and we can use `barplot` to make a nice plot of our data!

```r
barplot(table(exprmt))
```
This gives us a nice barplot of the number of observations for each of the treatments we listed in our vector for `exprmt`.

Could you recreate this plot with "control" listed last instead of first? Think about what steps you might need to take, try a few things, and discuss with your neighbors.







------------------- **The Below should be covered at some point, mabye in the next section? ** --------------

### Write a new .csv and explore the arguments

After altering our cars dataset by replacing 'Blue' with 'Green' in the `$Color` column, we now want to save the output. There are several arguments for the `write.csv(...)` [function call](../../gloss.html#function-call), a few of which are particularly important for how the data are exported.  Let's explore these now.


<pre class='in'><code>#Export the data. The write.csv() function requires a minimum of two arguments, the data to be saved and the name of the output file.

write.csv(carSpeeds, file='car-speeds-cleaned.csv')</code></pre>

If you open the file, you'll see that it has header names, because the data had headers within R, but that there are numbers in the first column.

<img src="figure/CSV_WithRowNums.png" alt="csv written without row.names argument" />


#### The row.names argument
This argument allows us to set the names of the rows in the output data file. R's default for this argument is `TRUE`, and since it does not know what else to name the rows for the cars data set, it resorts to using row numbers. To correct this, we can set `row.names` to `FALSE`:


<pre class='in'><code>write.csv(carSpeeds, file='car-speeds-cleaned.csv', row.names=FALSE)</code></pre>

Now we see: 

<img src="figure/CSV_WithoutRowNums.png" alt="csv written with row.names argument" />

> **Tip:** there is also a `col.names` argument, which can be used to set the column names for a data set without headers. If the data set already has headers (e.g., we used the headers = TRUE argument when importing the data) then a `col.names` argument will be ignored.


#### The na argument
There are times when we want to specify certain values for `NA`s in the data set (e.g., we are going to pass the data to a program that only accepts -9999 as a nodata value). In this case, we want to set the `NA` value of our output file to the desired value, using the `na` argument. Let's see how this works:


<pre class='in'><code>#First, replace the speed in the 3rd row with NA, by using an index (square brackets to indicate the position of the value we want to replace)
carSpeeds$Speed[3]<-NA
head(carSpeeds)</code></pre>



<pre class='in'><code>write.csv(carSpeeds, file='car-speeds-cleaned.csv', row.names=FALSE)</code></pre>

Now we'll set `NA` to -9999 when we write the new .csv file:


<pre class='in'><code>#Note - the na argument requires a string input
write.csv(carSpeeds, file='car-speeds-cleaned.csv', row.names=FALSE, na= '-9999')</code></pre>

And we see:

<img src="figure/CSV_WithSpecialNA.png" alt="csv written with -9999 as NA" />


#### Key Points

  * Import data from a .csv file using the  `read.csv(...)` function.
  * Understand some of the key arguments available for importing the data properly
    + `header`
    + `stringsAsFactors`
    + `as.is`
    + `strip.white`
  * Write data to a new .csv file using the `write.csv(...)` function
  * Understand some of the key arguments available for exporting the data properly
    + `row.names` / `col.names`
    + `na`

#### Next Steps
We have now explored data import and export from .csv files. There are several more arguments available for both the `read.csv(...)` and `write.csv(...)` functions, as well as similar options for working with data that are stored in other text formats (e.g., .txt).  To find out more, use the R help commands '?read.csv()' and '?write.csv()'.

In the next lessons, we'll explore how to work with and analyze data in the R environment.
