---
layout: lesson
root: ../..
---

# Learning Objectives
* understand the concept of a data.frame
* use sequences 
* know how to access any element of a data.frame

So we've already imported our Portal surveys dataframe, but I'm going to leave it alone for a bit longer. It's a really big dataset, and sometimes it's easier to explain, think about, and explore new ideas using some smaller examples. But we will get back to our surveys table soon!

## What are data frames?

`data.frame` is the *de facto* data structure for most tabular data and what we use for statistics and plotting.

A `data.frame` is a collection of vectors of identical lengths. Each vector represents a column, and each vector can be of a different data type (e.g., characters, integers, factors). The `str()` function is useful to inspect the data types of the columns.

A `data.frame` can be created by the functions `read.csv()` or `read.table()`, in other words, when importing spreadsheets from your hard drive (or the web).

By default, `data.frame` converts (= coerces) columns that contain characters (i.e., text) into the `factor` data type. Depending on what you want to do with the data, you may want to keep these columns as `character`. To do so, `read.csv()` and `read.table()` have an argument called `stringsAsFactors` which can be set to `FALSE`:

```r
some_data <- read.csv("data/some_file.csv", stringsAsFactors=FALSE)
```

You can also create data.frame manually with the function data.frame(). This function can also take the argument stringsAsFactors. Compare the output of these examples, and compare the difference between when the data are being read as character and when they are being read as factor.
```r
example_data <- data.frame(animal=c("dog", "cat", "sea cucumber", "sea urchin"),
                           feel=c("furry", "furry", "squishy", "spiny"),
                           weight=c(45, 8, 1.1, 0.8))
str(example_data)
```
The above code writes the data frame as factors, be default

```r
example_data <- data.frame(animal=c("dog", "cat", "sea cucumber", "sea urchin"),
                           feel=c("furry", "furry", "squishy", "spiny"),
                           weight=c(45, 8, 1.1, 0.8), stringsAsFactors=FALSE)
str(example_data)
```
Here, we've allowed them to be characters.


####Challenge

1. There are a few mistakes in this hand crafted data.frame, can you spot and fix them? Don’t hesitate to experiment!
```r
    author_book <- data.frame(author_first=c("Charles", "Ernst", "Theodosius"),
                              author_last=c(Darwin, Mayr, Dobzhansky),
                              year=c(1942, 1970))
```

2. Can you predict the class for each of the columns in the following example?
```r
    country_climate <- data.frame(country=c("Canada", "Panama", "South Africa", "Australia"),
                                   climate=c("cold", "hot", "temperate", "hot/temperate"),
                                   temperature=c(10, 30, 18, "15"),
                                   northern_hemisphere=c(TRUE, TRUE, FALSE, "FALSE"),
                                   has_kangaroo=c(FALSE, FALSE, FALSE, 1))
```
Check your guesses using str(country_climate). Are they what you expected? Why? Why not? Discuss with your neighbor.

R coerces (when possible) to the data type that is the least common denominator and is the easiest to coerce to.

**In a small dataset like one of these, we might be able to easily track down these errors and fix them manually - e.g., we could remove the quotes from the 15 or the FALSE, or make sure we are consistent in using TRUE/FALSE vs. 0/1. But in a large dataset (how many rows did we say the survey's table has? - it would be really difficult to do this manually, and if the data has already been collected - too late to ask our recorders to be sure they are doing their job correctly! This is also why yesterday's data cleaning is so important. We can also clean our data right in R, but it is best/easiest if this step is done first!**

## Inspecting data.frame objects

We already saw how the functions `head()` and `str()` can be useful to check the content and the structure of a `data.frame`. Here is a non-exhaustive list of functions to get a sense of the content/structure of the data.

* Size:
  * `dim()` - returns a vector with the number of rows in the first element, and the number of columns as the second element (the __dim__ensions of the object)
  * `nrow()` - returns the number of rows
  * `ncol()` - returns the number of columns
* Content:
  * `head()` - shows the first 6 rows
  * `tail()` - shows the last 6 rows
* Names:
  * `names()` - returns the column names (synonym of colnames() for data.frame objects)
  * `rownames()` - returns the row names
* Summary:
  * `str()` - structure of the object and information about the class, length and content of each column
  * `summary()` - summary statistics for each column

**Note:** most of these functions are “generic”, they can be used on other types of objects besides `data.frame`.

#### Challenge: 
Try out a few of these on the surveys data that we imported. How large is the dataset? Does summary give you different information for the different data types?

## Indexing and sequences

If we want to extract one or several values from a vector, we must provide one or several indices in square brackets, just as we do in math. For instance:

For the second value in the vector:
```r
animals <- c("mouse", "rat", "dog", "cat")
animals[2]
```

For the third and then the second value in the vector (it will give it to us in the order we ask, not the order they originally appear:
```r
animals[c(3, 2)]
```

For the values 2 through 4 

**Note** R indexes start at 1. Programming languages like Fortran, MATLAB, and R start counting at 1, because that’s what human beings typically do. Languages in the C family (including C++, Java, Perl, and Python) count from 0 because that’s simpler for computers to do.

```r
animals[2:4]
```

Can anyone explain in words what the computer is doing here?
```r
more_animals <- animals[c(1:3, 2:4)]
more_animals
```

## Indexing data.frames
**A `data.frame` is basically a collection of vectors, where each column is a single data type (e.g. numeric, character, factor...) and if it were on it's own, should function like a vector.**

So using what we just learned about how to access different parts of a vector, let's think about how we might access different parts of a `data.frame`. 

A vector is one dimensional (just a single "row" of numbers or strings. But a `data.frame` is 2-dimensional: it has rows and columns. So when we indexed our vector, we only needed to provide a single number in our brackets [2]. But for a data.frame, we need to identify where in the "grid" we want our data, so we use an index with row and column values [row, column]. 

Our survey data frame has rows and columns (it has 2 dimensions), if we want to extract some specific data from it, we need to specify the “coordinates” we want from it. Row numbers come first, followed by column numbers.

To select the first row and first column:
```r
surveys[1,1]
```

To select the first row and sixth column:
```r
surveys[1,6]
```

If we leave one of these blank, R will choose the ENTIRE row or column. Thus, to get the first row of data, we would use:
```r
surveys[1, ]
```

####Challenge:
Using what we learned earlier and applying it to the surveys data, can you:
* Extract the hindfoot_lengths
* Extract the first 25 rows of data
* Extract the first 25 rows of data, with only the columns for plot_id, species_id, sex, and hindfoot_length
* Extract the last 25 rows of data, with only the columns for year, species_id, and weight.
* Extract the data for species_id and weight and save it as a new data.frame called `species_weight`

### : and Seq
**Useful Side Note:** `:` is a special function that creates numeric vectors of integers in increasing or decreasing order, test `1:10` and `10:1` for instance. 

The function `seq()` (for __seq__uence) can be used to create more complex patterns:

To count by 2:
`seq(1, 10, by=2)`

To display 3 values starting with 5 and ending with 10:
`seq(5, 10, length.out=3)`

To isplay 10 values, starting at 50 and incrementing by 5:
`seq(50, by=5, length.out=10)`

To count by 3, but stop below the upper limit: 
`seq(1, 8, by=3) # sequence stops to stay below upper limit`


####Challenge

The function `nrow()` on a `data.frame` returns the number of rows. Use it, in conjuction with `seq()` to create a new `data.frame` called `surveys_by_10` that includes every 10th row of the survey data frame starting at row 10 (10, 20, 30, …)

It might be helpful to break this problem down into steps. Before you try for the final solution, think about what steps you will need to take to solve the problem. How many rows will you expect your final dataframe to be? You can use this to check if you were successful (remember, the computer giving you an answer doesn't mean its the right answer). You can try each step one at a time, building on each successful part. Try to begin on your own, but after a few minutes, you should discuss your problem-solving approach, and your solution (or however far you got) with your neighbor.

Another important way to select data from specific columns, is to use the `$` notation. For example, we can select only the data from the years column by naming it:

```r
surveys$year
```

If we want, we can save that as a vector, by assigning it to a new name, so we can work with it separately.

```r
years <- surveys$year
```

One other useful thing, especially for factor or character variables, is to know what the unique things are.

```r
unique(surveys$year)
```
And again, we can save that out to a varable:
```r
years <- unique(surveys$year)
```

## Basic plotting

Here's the part we've all been waiting for, let's make some pretty pictures with our data!

Remember when we did the barplot example? We can do the same thing here, with the surveys data, now that we know how to index and subset it, and save it.

```r
barplot(table(surveys$taxa))
```

Awesome! Now we can see our data!
If we look at the `help` for barplot, we can find all sorts of ways to make this graph "prettier" if we want.

We can change the color of the bars, the limts on the x or y axis, the name of the figure, etc. 
(R colors)[http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf] can be found online in several places.

*Demonstrate a few of these, and give people a chance to explore and figure it out, maybe using weight this time, so they are doing something different*

Let's take the data for hind foot length, and see what the distribution of values are. Hind foot length is allometrically related to body weight, so it can potentially act as a proxy for that measurement.

```r
hfl <- surveys$hindfoot_length
barplot(table(hfl))
```

We can also plot the kernel density plots as a different way to see the distribution of our data:

```r
# Kernel Density Plot
d <- density(surveys$hindfoot_length) # returns the density data
plot(d) # plots the results 
```

Boxplots allow us to break the data up over some value, and to see the variance within each of those:

```r
boxplot(hindfoot_length ~ species_id, data=surveys, col="hotpink")
```

I'm not generally a fan of pie charts ((humans are bad at comparing pie slices)[http://www.businessinsider.com/pie-charts-are-the-worst-2013-6]), but you can make them easily in R:

```r
pie(table(surveys$species_id))
```

Remember that I said hind foot length and weight should be related. Let's see if that is true in this dataset!

```r
plot(surveys$hindfoot_length, surveys$weight)
```

We can even add data transformation or math right in our plot function:

```r
plot(surveys$hindfoot_length, log(surveys$weight))
```

Or add a trendline:

```r
plot(surveys$hindfoot_length, log(surveys$weight))
abline(lm(log(surveys~weight) ~ surveys$hindfoot_length), col="red")
```

**Note:** in the above abline call, we still had to specify that we were logging weight - otherwise the computer wouldn't just know that from the previous line - *secret: computers aren't really that smart*. 

**These are only a few simple ways to get started with plots in Base-R. There are many many more packages that you can download that allow you to make more detailed or "prettier" plots in R. Also, as we learn more about how to aggregate and analyze data, you can plot more useful data summaries, such as change in average mass through time, or the abundances of species through time!








-------------- ** To cover later if there is time?** ------------------



## Creating Functions

If we only had one data set to analyze, it would probably be faster to load the file into a spreadsheet and use that to plot some simple statistics. 
But we have twelve files to check, and may have more in the future.
In this lesson, we'll learn how to write a function so that we can repeat several operations with a single command.

#### Objectives

* Define a function that takes arguments.
* Return a value from a function.
* Test a function.
* Explain what a call stack is, and trace changes to the call stack as functions are called.
* Set default values for function arguments.
* Explain why we should divide programs into small, single-purpose functions.

### Defining a function

Let's start by defining a function `fahr_to_kelvin` that converts temperatures from Fahrenheit to Kelvin:


<pre class='in'><code>fahr_to_kelvin <- function(temp) {
  kelvin <- ((temp - 32) * (5 / 9)) + 273.15
  return(kelvin)
}</code></pre>

We define `fahr_to_kelvin` by assigning it to the output of `function`.
The list of argument names are containted within parentheses.
Next, the [body](../../gloss.html#function-body) of the function--the statements that are executed when it runs--is contained within curly braces (`{}`).
The statements in the body are indented by two spaces.
This makes the code easier to read but does not affect how the code operates. 

When we call the function, the values we pass to it are assigned to those variables so that we can use them inside the function.
Inside the function, we use a [return statement](../../gloss.html#return-statement) to send a result back to whoever asked for it.

> **Tip:** One feature unique to R is that the return statement is not required.
R automatically returns whichever variable is on the last line of the body of the function.
Since we are just learning, we will explicitly define the return statement.

Let's try running our function.
Calling our own function is no different from calling any other function:


<pre class='in'><code># freezing point of water
fahr_to_kelvin(32)</code></pre>



<div class='out'><pre class='out'><code>[1] 273.1
</code></pre></div>



<pre class='in'><code># boiling point of water
fahr_to_kelvin(212)</code></pre>



<div class='out'><pre class='out'><code>[1] 373.1
</code></pre></div>

We've successfully called the function that we defined, and we have access to the value that we returned.

### Composing Functions

Now that we've seen how to turn Fahrenheit into Kelvin, it's easy to turn Kelvin into Celsius:


<pre class='in'><code>kelvin_to_celsius <- function(temp) {
  celsius <- temp - 273.15
  return(celsius)
}

#absolute zero in Celsius
kelvin_to_celsius(0)</code></pre>



<div class='out'><pre class='out'><code>[1] -273.1
</code></pre></div>

What about converting Fahrenheit to Celsius?
We could write out the formula, but we don't need to.
Instead, we can [compose](../../gloss.html#function-composition) the two functions we have already created:


<pre class='in'><code>fahr_to_celsius <- function(temp) {
  temp_k <- fahr_to_kelvin(temp)
  result <- kelvin_to_celsius(temp_k)
  return(result)
}

# freezing point of water in Celsius
fahr_to_celsius(32.0)</code></pre>



<div class='out'><pre class='out'><code>[1] 0
</code></pre></div>

This is our first taste of how larger programs are built: we define basic operations, then combine them in ever-large chunks to get the effect we want. 
Real-life functions will usually be larger than the ones shown here--typically half a dozen to a few dozen lines--but they shouldn't ever be much longer than that, or the next person who reads it won't be able to understand what's going on.

#### Challenges

  + In the last lesson, we learned to **c**oncatenate elements into a vector using the `c` function, e.g. `x <- c("A", "B", "C")` creates a vector `x` with three elements.
  Furthermore, we can extend that vector again using `c`, e.g. `y <- c(x, "D")` creates a vector `y` with four elements.
  Write a function called `fence` that takes two vectors as arguments, called `original` and `wrapper`, and returns a new vector that has the wrapper vector at the beginning and end of the original:
  

  

<pre class='in'><code>best_practice <- c("Write", "programs", "for", "people", "not", "computers")
asterisk <- "***"  # R interprets a variable with a single value as a vector
                   # with one element.
fence(best_practice, asterisk)</code></pre>



<div class='out'><pre class='out'><code>[1] "***"       "Write"     "programs"  "for"       "people"    "not"      
[7] "computers" "***"      
</code></pre></div>

  + If the variable `v` refers to a vector, then `v[1]` is the vector's first element and `v[length(v)]` is its last (the function `length` returns the number of elements in a vector).
    Write a function called `outer` that returns a vector made up of just the first and last elements of its input:
    



<pre class='in'><code>dry_principle <- c("Don't", "repeat", "yourself", "or", "others")
outer(dry_principle)</code></pre>



<div class='out'><pre class='out'><code>[1] "Don't"  "others"
</code></pre></div>

### The Call Stack

Let's take a closer look at what happens when we call `fahr_to_celsius(32)`. To make things clearer, we'll start by putting the initial value 32 in a variable and store the final result in one as well:


<pre class='in'><code>original <- 32
final <- fahr_to_celsius(original)</code></pre>

The diagram below shows what memory looks like after the first line has been executed:


When we call `fahr_to_celsius`, R *doesn't* create the variable `temp` right away.
Instead, it creates something called a [stack frame](../../gloss.html#stack-frame) to keep track of the variables defined by `fahr_to_kelvin`.
Initially, this stack frame only holds the value of `temp`:


When we call `fahr_to_kelvin` inside `fahr_to_celsius`, R creates another stack frame to hold `fahr_to_kelvin`'s variables:


It does this because there are now two variables in play called `temp`: the argument to `fahr_to_celsius`, and the argument to `fahr_to_kelvin`.
Having two variables with the same name in the same part of the program would be ambiguous, so R (and every other modern programming language) creates a new stack frame for each function call to keep that function's variables separate from those defined by other functions.

When the call to `fahr_to_kelvin` returns a value, R throws away `fahr_to_kelvin`'s stack frame and creates a new variable in the stack frame for `fahr_to_celsius` to hold the temperature in Kelvin:


It then calls `kelvin_to_celsius`, which means it creates a stack frame to hold that function's variables:



Once again, R throws away that stack frame when `kelvin_to_celsius` is done
and creates the variable `result` in the stack frame for `fahr_to_celsius`:


Finally, when `fahr_to_celsius` is done, R throws away *its* stack frame and puts its result in a new variable called `final` that lives in the stack frame we started with:


This final stack frame is always there;
it holds the variables we defined outside the functions in our code.
What it *doesn't* hold is the variables that were in the various stack frames.
If we try to get the value of `temp` after our functions have finished running, R tells us that there's no such thing:


<pre class='in'><code>temp</code></pre>



<div class='out'><pre class='out'><code>Error: object 'temp' not found
</code></pre></div>

> **Tip:** The explanation of the stack frame above was very general and the basic concept will help you understand most languages you try to program with.
However, R has some unique aspects that can be exploited when performing more complicated operations.
We will not be writing anything that requires knowledge of these more advanced concepts.
In the future when you are comfortable writing functions in R, you can learn more by reading the [R Language Manual][man] or this [chapter][] from [Advanced R Programming][adv-r] by Hadley Wickham.
For context, R uses the terminology "environments" instead of frames.

[man]: http://cran.r-project.org/doc/manuals/r-release/R-lang.html#Environment-objects
[chapter]: http://adv-r.had.co.nz/Environments.html
[adv-r]: http://adv-r.had.co.nz/

Why go to all this trouble? Well, here's a function called `span` that calculates the difference between the mininum and maximum values in an array:


<pre class='in'><code>span <- function(a) {
  diff <- max(a) - min(a)
  return(diff)
}

dat <- read.csv(file = "inflammation-01.csv", header = FALSE)
# span of inflammation data
span(dat)</code></pre>



<div class='out'><pre class='out'><code>[1] 20
</code></pre></div>

Notice `span` assigns a value to variable called `diff`. We might very well use a variable with the same name (`diff`) to hold the inflammation data:


<pre class='in'><code>diff <- read.csv(file = "inflammation-01.csv", header = FALSE)
# span of inflammation data
span(diff)</code></pre>



<div class='out'><pre class='out'><code>[1] 20
</code></pre></div>

We don't expect the variable `diff` to have the value 20 after this function call, so the name `diff` cannot refer to the same variable defined inside `span` as it does in as it does in the main body of our program (which R refers to as the global environment).
And yes, we could probably choose a different name than `diff` for our variable in this case, but we don't want to have to read every line of code of the R functions we call to see what variable names they use, just in case they change the values of our variables.

The big idea here is [encapsulation](../../gloss.html#encapsulation), and it's the key to writing correct, comprehensible programs.
A function's job is to turn several operations into one so that we can think about a single function call instead of a dozen or a hundred statements each time we want to do something.
That only works if functions don't interfere with each other; if they do, we have to pay attention to the details once again, which quickly overloads our short-term memory.

#### Challenges

  + We previously wrote functions called `fence` and `outer`.
    Draw a diagram showing how the call stack changes when we run the following:


<pre class='in'><code>inside <- "carbon"
outside <- "+"
result <- outer(fence(inside, outside))</code></pre>

### Testing and Documenting

Once we start putting things in functions so that we can re-use them, we need to start testing that those functions are working correctly.
To see how to do this, let's write a function to center a dataset around a particular value:


<pre class='in'><code>center <- function(data, desired) {
  new_data <- (data - mean(data)) + desired
  return(new_data)
}</code></pre>

We could test this on our actual data, but since we don't know what the values ought to be, it will be hard to tell if the result was correct.
Instead, let's create a vector of 0s and then center that around 3.
This will make it simple to see if our function is working as expected:


<pre class='in'><code>z <- c(0, 0, 0, 0)
z</code></pre>



<div class='out'><pre class='out'><code>[1] 0 0 0 0
</code></pre></div>



<pre class='in'><code>center(z, 3)</code></pre>



<div class='out'><pre class='out'><code>[1] 3 3 3 3
</code></pre></div>

That looks right, so let's try center on our real data. We'll center the inflammation data from day 4 around 0:


<pre class='in'><code>dat <- read.csv(file = "inflammation-01.csv", header = FALSE)
centered <- center(dat[, 4], 0)
head(centered)</code></pre>



<div class='out'><pre class='out'><code>[1]  1.25 -0.75  1.25 -1.75  1.25  0.25
</code></pre></div>

It's hard to tell from the default output whether the result is correct, but there are a few simple tests that will reassure us:


<pre class='in'><code># original min
min(dat[, 4])</code></pre>



<div class='out'><pre class='out'><code>[1] 0
</code></pre></div>



<pre class='in'><code># original mean
mean(dat[, 4])</code></pre>



<div class='out'><pre class='out'><code>[1] 1.75
</code></pre></div>



<pre class='in'><code># original max
max(dat[, 4])</code></pre>



<div class='out'><pre class='out'><code>[1] 3
</code></pre></div>



<pre class='in'><code># centered min
min(centered)</code></pre>



<div class='out'><pre class='out'><code>[1] -1.75
</code></pre></div>



<pre class='in'><code># centered mean
mean(centered)</code></pre>



<div class='out'><pre class='out'><code>[1] 0
</code></pre></div>



<pre class='in'><code># centered max
max(centered)</code></pre>



<div class='out'><pre class='out'><code>[1] 1.25
</code></pre></div>

That seems almost right: the original mean was about 1.75, so the lower bound from zero is now about -1.75.
The mean of the centered data is 0.
We can even go further and check that the standard deviation hasn't changed:


<pre class='in'><code># original standard deviation
sd(dat[, 4])</code></pre>



<div class='out'><pre class='out'><code>[1] 1.068
</code></pre></div>



<pre class='in'><code># centerted standard deviation
sd(centered)</code></pre>



<div class='out'><pre class='out'><code>[1] 1.068
</code></pre></div>

Those values look the same, but we probably wouldn't notice if they were different in the sixth decimal place.
Let's do this instead:


<pre class='in'><code># difference in standard deviations before and after
sd(dat[, 4]) - sd(centered)</code></pre>



<div class='out'><pre class='out'><code>[1] 0
</code></pre></div>

Sometimes, a very small difference can be detected due to rounding at very low decimal places.
R has a useful function for comparing two objects allowing for rounding errors, `all.equal`:


<pre class='in'><code>all.equal(sd(dat[, 4]), sd(centered))</code></pre>



<div class='out'><pre class='out'><code>[1] TRUE
</code></pre></div>

It's still possible that our function is wrong, but it seems unlikely enough that we should probably get back to doing our analysis.
We have one more task first, though: we should write some [documentation](../../gloss.html#documentation) for our function to remind ourselves later what it's for and how to use it.

A common way to put documentation in software is to add [comments](../../gloss.html#comment) like this:


<pre class='in'><code>center <- function(data, desired) {
  # return a new vector containing the original data centered around the
  # desired value.
  # Example: center(c(1, 2, 3), 0) => c(-1, 0, 1)
  new_data <- (data - mean(data)) + desired
  return(new_data)
}</code></pre>

> **Tip:** Formal documentation for R functions is written in separate `.Rd` using a markup language similar to [LaTeX][].
You see the result of this documentation when you look at the help file for a given function, e.g. `?read.csv`.
The [roxygen2][] package allows R coders to write documentation alongside the function code and then process it into the appropriate `.Rd` files.
You will want to switch to this more formal method of writing documentation when you start writing more complicated R projects.

[LaTeX]: http://www.latex-project.org/
[roxygen2]: http://cran.r-project.org/web/packages/roxygen2/vignettes/rd.html

#### Challenges

  + Write a function called `analyze` that takes a filename as a argument and displays the three graphs produced in the [previous lesson][01] (average, min and max inflammation over time).
  `analyze("inflammation-01.csv")` should produce the graphs already shown, while `analyze("inflammation-02.csv")` should produce corresponding graphs for the second data set. Be sure to document your function with comments.

[01]: 01-starting-with-data.html



  + Write a function `rescale` that takes a vector as input and returns a corresponding vector of values scaled to lie in the range 0 to 1.
  (If $L$ and $H$ are the lowest and highest values in the original vector, then the replacement for a value $v$ should be $(v-L) / (H-L)$.)
  Be sure to document your function with comments.



  + Test that your `rescale` function is working properly using `min`, `max`, and `plot`.



### Defining Defaults

We have passed arguments to functions in two ways: directly, as in `dim(dat)`, and by name, as in `read.csv(file = "inflammation-01.csv", header = FALSE)`.
In fact, we can pass the arguments to `read.csv` without naming them:


<pre class='in'><code>dat <- read.csv("inflammation-01.csv", FALSE)</code></pre>

However, the position of the arguments matters if they are not named.


<pre class='in'><code>dat <- read.csv(header = FALSE, file = "inflammation-01.csv")
dat <- read.csv(FALSE, "inflammation-01.csv")</code></pre>



<div class='out'><pre class='out'><code>Error: 'file' must be a character string or connection
</code></pre></div>

To understand what's going on, and make our own functions easier to use, let's re-define our `center` function like this:


<pre class='in'><code>center <- function(data, desired = 0) {
  # return a new vector containing the original data centered around the
  # desired value (0 by default).
  # Example: center(c(1, 2, 3), 0) => c(-1, 0, 1)
  new_data <- (data - mean(data)) + desired
  return(new_data)
}</code></pre>

The key change is that the second argument is now written `desired = 0` instead of just `desired`.
If we call the function with two arguments, it works as it did before:


<pre class='in'><code>test_data <- c(0, 0, 0, 0)
center(test_data, 3)</code></pre>



<div class='out'><pre class='out'><code>[1] 3 3 3 3
</code></pre></div>

But we can also now call `center()` with just one argument, in which case `desired` is automatically assigned the default value of `0`:


<pre class='in'><code>more_data <- 5 + test_data
more_data</code></pre>



<div class='out'><pre class='out'><code>[1] 5 5 5 5
</code></pre></div>



<pre class='in'><code>center(more_data)</code></pre>



<div class='out'><pre class='out'><code>[1] 0 0 0 0
</code></pre></div>

This is handy: if we usually want a function to work one way, but occasionally need it to do something else, we can allow people to pass an argument when they need to but provide a default to make the normal case easier.

The example below shows how R matches values to arguments


<pre class='in'><code>display <- function(a = 1, b = 2, c = 3) {
  result <- c(a, b, c)
  names(result) <- c("a", "b", "c")  # This names each element of the vector
  return(result)
}

# no arguments
display()</code></pre>



<div class='out'><pre class='out'><code>a b c 
1 2 3 
</code></pre></div>



<pre class='in'><code># one argument
display(55)</code></pre>



<div class='out'><pre class='out'><code> a  b  c 
55  2  3 
</code></pre></div>



<pre class='in'><code># two arguments
display(55, 66)</code></pre>



<div class='out'><pre class='out'><code> a  b  c 
55 66  3 
</code></pre></div>



<pre class='in'><code># three arguments
display (55, 66, 77)</code></pre>



<div class='out'><pre class='out'><code> a  b  c 
55 66 77 
</code></pre></div>

As this example shows, arguments are matched from left to right, and any that haven't been given a value explicitly get their default value.
We can override this behavior by naming the value as we pass it in:


<pre class='in'><code># only setting the value of c
display(c = 77)</code></pre>



<div class='out'><pre class='out'><code> a  b  c 
 1  2 77 
</code></pre></div>

> **Tip:** To be precise, R has three ways that arguments supplied by you are matched to the *formal arguments* of the function definition
>
> 1. by complete name, 
> 2. by partial name (matching on initial *n* characters of the argument name), and
> 3. by position.
>
> Arguments are matched in the manner outlined above in *that order*: by complete name, then by partial matching of names, and finally by position.

With that in hand, let's look at the help for `read.csv()`:


<pre class='in'><code>?read.csv</code></pre>

There's a lot of information there, but the most important part is the first couple of lines:


<pre class='in'><code>read.csv(file, header = TRUE, sep = ",", quote = "\"",
         dec = ".", fill = TRUE, comment.char = "", ...)</code></pre>

This tells us that `read.csv()` has one argument, `file`, that doesn't have a default value, and six others that do.
Now we understand why the following gives an error:


<pre class='in'><code>dat <- read.csv(FALSE, "inflammation-01.csv")</code></pre>



<div class='out'><pre class='out'><code>Error: 'file' must be a character string or connection
</code></pre></div>

It fails because `FALSE` is assigned to `file` and the filename is assigned to the argument `header`.

#### Challenges

  + Rewrite the `rescale` function so that it scales a vector to lie between 0 and 1 by default, but will allow the caller to specify lower and upper bounds if they want.
  Compare your implementation to your neighbor's: do the two functions always behave the same way?



#### Key Points

* Define a function using `name <- function(...args...)`.
* The body of a function should be surrounded by curly braces (`{}`).
* Call a function using `name(...values...)`.
* Each time a function is called, a new stack frame is created on the [call stack](../../gloss.html#call-stack) to hold its arguments and local variables.
* R looks for variables in the current stack frame before looking for them at the top level.
* Use `help(thing)` to view help for something.
* Put comments at the beginning of functions to provide help for that function.
* Annotate your code!
* Specify default values for arguments when defining a function using `name = value` in the argument list.
* Arguments can be passed by matching based on name, by position, or by omitting them (in which case the default value is used).

#### Next Steps

We now have a function called analyze to visualize a single data set.
We could use it to explore all 12 of our current data sets like this:


<pre class='in'><code>analyze("inflammation-01.csv")
analyze("inflammation-02.csv")
#...
analyze("inflammation-12.csv")</code></pre>

but the chances of us typing all 12 filenames correctly aren't great, and we'll be even worse off if we get another hundred files.
What we need is a way to tell R to do something once for each file, and that will be the subject of the next lesson.
