---
layout: lesson
root: ../..
---


# Data Carpentry R materials - modified with notes by S.R. Supp
--------------------------------------------------

## Learning Objectives
* Articulate motivations for this lesson
* Introduce participants to RStudio interface
* Set up participants to have a working directory with a data/ folder inside
* Introduce R syntax
* Point to relevant information on how to get help, and understand how to ask well formulated questions

## Getting Started 
* Now that we have collected and cleaned our data, we are going to want to do something with it
* Draw concept map of where we are headed towards best scientific practices, and reproducibility.
* It's really important that you know what you did. More journals/grants/etc. are also making it important for them to know what you did.
* A lot of scientific code is *not* reproducible.
* If you keep a lab notebook, why are we not as careful with our code? 
* We edit each others manuscripts, but we don't edit each other's code. 
* If you write your code with "future you" in mind, you will save yourself and others a lot of time.

# Very basics of R

R is a versatile, open source programming language that was specifically designed for data analysis. As such R is extremely useful both for statistics and data science. Inspired by the programming language S.  

* Open source software under GPL.  
* Superior (if not just comparable) to commercial alternatives. R has over 5,000 user contributed packages at this time. It's widely used both in academia and industry.  
* Available on all platforms.  
* Not just for statistics, but also general purpose programming.  
* Is (sort of) object oriented and functional.  
* Large and growing community of peers.  
* RStudio is a great GUI for getting started with R, and what a lot of scientific programmers use!

Let's open RStudio:
* Start RStudio (demonstrate for class)
* Under the `File` menu, click on `New project`, choose `New directory`, then `Empty project`
* Enter a name for this new folder, and choose a convenient location for it. This will be your **working directory** for the rest of the day (e.g., `~/data-carpentry`)
* Click on “Create project”
* Under the Files tab on the right of the screen, click on `New Folder` and create a folder named `data` within your newly created working directory. (e.g., `~/data-carpentry/data`)
* Create a new R script (`File` > `New File` > `R script`) and save it in your working directory (e.g. `data-carpentry-script.R`)

Your working directory should now look like this (show where it is on the screen, in the environments tab (under `files`).

## Presentation of RStudio
**Point out the different windows in RStudio.**
Let's start by learning about our tool.
* Console, Scripts, Environments, Plots
* Code and workflow are more reproducible if we can document everything that we do.
 * Avoid using too many shortcuts if you won't remember how you did something - best to document it in your `script`
* Our end goal is not just to “do stuff” but to do it in a way that anyone can easily and exactly replicate our workflow and results.


## Interacting with R
There are two main ways of interacting with R: using the console or by using script files (plain text files that contain your code).

The console window (in RStudio, the bottom left panel) is the place where R is waiting for you to tell it what to do, and where it will show the results of a command. You can type commands directly into the console, but they will be forgotten when you close the session. It is better to enter the commands in the script editor, and save the script. This way, you have a complete record of what you did, you can easily show others how you did it and you can do it again later on if needed. You can copy-paste into the R console, but the Rstudio script editor allows you to ‘send’ the current line or the currently selected text to the R console using the `Ctrl-Enter` shortcut.

At some point in your analysis you may want to check the content of variable or the structure of an object, without necessarily keep a record of it in your script. You can type these commands directly in the console. RStudio provides the `Ctrl-1` and `Ctrl-2` shortcuts allow you to jump between the script and the console windows.

If R is ready to accept commands, the R console shows a `>` prompt. If it receives a command (by typing, copy-pasting or sent from the script editor using `Ctrl-Enter`), R will try to execute it, and when ready, show the results and come back with a new `>` prompt to wait for new commands.

If R is still waiting for you to enter more data because it isn’t complete yet, the console will show a `+` prompt. It means that you haven’t finished entering a complete command. This is because you have not ‘closed’ a parenthesis or quotation. If you’re in Rstudio and this happens, click inside the console window and press `Esc`; this should help you out of trouble.


### Commenting
Use `#` signs to comment. Comment liberally in your R scripts. Anything to the right of a `#` is ignored by R.
**Commenting is important because these are your notes to yourself, or to a potential collaborator or code reviewer. Trust me, remembering what you did (and why) a few days from now, let alone a few months or years from now, is harder than you think!**

### Assignment operator

`<-` is the assignment operator. It assigns values on the right to objects on the left. So, after executing `x <- 3`, the value of `x` is `3`. The arrow can be read as 3 **goes** into x. You can also use `=` for assignments but not in all contexts so it is good practice to use `<-` for assignments. `=` should only be used to specify the values of arguments in functions, see below.

In RStudio, typing `Alt + -` (push Alt, the key next to your space bar at the same time as the - key) will write `<-` in a single keystroke.

### Functions and their arguments

Functions are “canned scripts” that automate something complicated or convenient or both. Many functions are predefined, or become available when using the function `library()` (more on that later). A function usually gets one or more inputs called *arguments*. Functions often (but not always) return a *value*. A typical example would be the function `sqrt()`. The input (the argument) must be a number, and the return value (in fact, the output) is the square root of that number. Executing a function (‘running it’) is called calling the function. An example of a function call is:

`b <- sqrt(a)`

Here, the value of `a` is given to the `sqrt()` function, the `sqrt()` function calculates the square root, and returns the value which is then assigned to variable `b`. This function is very simple, because it takes just one argument.

The return ‘value’ of a function need not be numerical (like that of `sqrt()`), and it also does not need to be a single item: it can be a set of things, or even a data set. We’ll see that when we read data files in to R.

Arguments can be anything, not only numbers or filenames, but also other objects. Exactly what each argument means differs per function, and must be looked up in the documentation (I'll show you this in a minute, the documentation are essentially notes on how to use a function, usually with examples). If an argument alters the way the function operates, such as whether to ignore ‘bad values’, such an argument is sometimes called an *option*.

Most functions can take several arguments, but many have so-called *defaults*. If you don’t specify such an argument when calling the function, the function itself will fall back on using the *default*. This is a standard value that the author of the function specified as being “good enough in standard cases”. An example would be what symbol to use in a plot. However, if you want something specific, simply change the argument yourself with a value of your choice.

Let’s try a function that can take multiple arguments - `round`.

If we look up `round` in the help section of Rstudio (lower right panel), we see that we can round in several different ways - so the first things it shows are the different rounding functions. If we scroll down, we see `round(x, digits=0)`. The arguments presented in parentheses (there are 2 of them, a value and the number of digits we want to round to). Since `digits=0`, this tells us that digits is set to round to 0 digits by default. 
**Any guesses as to what we would get if we type the below, without changing or entering the default argument?**

```r
round(3.14159)
```

The answer is `3` because the default is to round to the nearest whole number (digits=0). If we want to keep more digits, we can see how to do that by getting information about the `round` function. We can check the `help` or we can type:

```r
args(round)
``` 

or 

```r
?round
```

to learn more. We see that if we want to keep 2 decimal palces, we can add digits=2 to our function call, or however many we want...

```r
round(3.14159, digits=2)
```

Also, if we provide the arguments in the same order as they are defined, you don't need to name them:
```r
round(3.14159, 2)
```

However, it’s usually not recommended practice, especially for more complex functions, because it’s a lot of remembering to do, and if you share your code with others that includes less known functions it makes your code difficult to read. (It’s however OK to not include the names of the arguments for basic functions like `mean`, `min`, etc…)

Another advantage of naming arguments, is that the order doesn’t matter. This is useful when there start to be more arguments.

## Libraries and Packages
There are a lot of functions that come built-in to what we call `base-R`. You don't need to do anything special to use these functions, other than figure out the right words to type to call them. However, R has a **HUGE** number of other functions that are freely available to download - they are open access and are written by programmers and by people like you! A `package` is a directory (folder) of files that allow you to extend R, usually by introducing new functions to allow you to calculate or plot new things. A `library` is a directory that may contain one or more packages, that you can download into R, so you can use them in RStudio. For now, we'll stick to the basics, but by the end of the day we will show you some useful packages, how to get them, and how to use them.

## Organizing your working directory
To make it easier on yourself, and to avoid overwriting your original data, you should separate the original data (raw data) from intermediate datasets that you may create for the need of a particular analysis. For instance, you may want to create a `data/` directory within your working directory that stores the raw data, and have a `data_output/` directory for intermediate datasets and a `figure_output/` directory for the plots you will generate.


## Seeking HELP

All functions come with a help screen. 
It is critical that you learn to read the help screens since they provide important information on what the function does, 
how it works, and usually sample examples at the very bottom.
**You can't ever learn all of R, but you will get better and faster at doing things. So don't worry if it feels like you're asking for help a lot, especially at first!**

####I know the name of the function I want to use, but I'm not sure how to use it
If you need help with a specific function, let's say `barplot()`, you can type:

```r
?barplot
```
If you just need to remind yourself of the names of the arguments, you can use:
```r
args(lm)
```
If the function is part of a `package` that is installed on your computer, but you don't remember which one, you can type:
```r
??geom_point
```

#### I want to use a function that does X, there must be a function for it, but I don't know which one...
If you are looking for a function to do a particular task, you can use `help.search()` (but only looks through the installed packages):

```r
help.search("linear model")
```
You can also type search terms into the box for help on the lower right panel.

If you can’t find what you are looking for, you can use the rdocumention.org website that search through the help files across all packages available.

**But most of the time, I just use google.**

#### I am stuck… I get an error message that I don’t understand

Start by googling the error message. However, this doesn’t always work very well because often, package developers rely on the error catching provided by R. You end up with general error messages that might not be very helpful to diagnose a problem (e.g. “subscript out of bounds”).

However, you should check stackoverflow. Search using the `[r]` tag. Most questions have already been answered, but the challenge is to use the right words in the search to find the answers: [http://stackoverflow.com/questions/tagged/r](http://stackoverflow.com/questions/tagged/r)
**Open and show stack overflow now. Demonstrate an example question, or show what some recent questions and answers have been**

The [Introduction to R](https://cran.r-project.org/doc/manuals/R-intro.pdf) can also be dense for people with little programming experience but it is a good place to understand the underpinnings of the R language.

The [R FAQ](https://cran.r-project.org/doc/FAQ/R-FAQ.html) is dense and technical but it is full of useful information.


####Asking for help
The key to get help from someone is for them to grasp your problem rapidly. You should make it as easy as possible to pinpoint where the issue might be.

Try to use the correct words to describe your problem. For instance, a `package` is not the same thing as a `library`. Most people will understand what you meant, but others have really strong feelings about the difference in meaning. The key point is that it can make things confusing for people trying to help you. Be as precise as possible when describing your problem

If possible, try to reduce what doesn’t work to a simple reproducible example. If you can reproduce the problem using a very `small data.frame` instead of your 50,000 rows and 10,000 columns one, provide the small one with the description of your problem. When appropriate, try to generalize what you are doing so even people who are not in your field can understand the question.

If it helps to explain the problem, you might want to share an object with someone to illustrate. To share an object with someone else, if it’s relatively small, you can use the function `dput()`. It will output R code that can be used to recreate the exact same object as the one in memory:

```r
dput(head(iris)) # iris is an example data.frame that comes with R
```

If the object is larger, provide either the raw file (i.e., your CSV file) with your script up to the point of the error (and after removing everything that is not relevant to your issue). Alternatively, in particular if your question is not related to a `data.frame`, you can save any R object to a file:

```r
saveRDS(iris, file="/tmp/iris.rds")
```

The content of this file is, however, not human readable and cannot be posted directly on stackoverflow. It can, however, be sent to someone by email who can read it with this command:

```r
some_data <- readRDS(file="~/Downloads/iris.rds")
```

Last, but certainly not least, **always include the output of `sessionInfo()`** as it provides critical information about your platform, the versions of R and the packages that you are using, and other information that can be very helpful to understand your problem.

`sessionInfo()`

#### Where to ask for help?

* **Your friendly colleagues:** if you know someone with more experience than you, they might be able and willing to help you.
* **StackOverflow:** if your question hasn’t been answered before and is well crafted, chances are you will get an answer in less than 5 min.
* **The R-help:** it is read by a lot of people (including most of the R core team), a lot of people post to it, but the tone can be pretty dry, and it is not always very welcoming to new users. If your question is valid, you are likely to get an answer very fast but don’t expect that it will come with smiley faces. Also, here more than everywhere else, be sure to use correct vocabulary (otherwise you might get an answer pointing to the misuse of your words rather than answering your question). You will also have more success if your question is about a base function rather than a specific package.
* **Google:** If you can make a pretty good guess at the right search terms and have learned enough to read through the help, you might find a simple google search can locate a tutorial, question, or blog that can help you solve your own problem.
* **Twitter:** There are lots of friendly colleagues on twitter and folks that monitor the #rstats hashtag who can often answer a simple question very quickly, or send you to a link that can help!
* If your question is about a specific package, see if there is a mailing list for it. Usually it’s included in the DESCRIPTION file of the package that can be accessed using packageDescription("name-of-package"). You may also want to try to email the author of the package directly.
* There are also some topic-specific mailing lists (GIS, phylogenetics, etc…), the complete list is here.


#### More resources
* The [Posting Guide](https://www.r-project.org/posting-guide.html) for the R mailing lists.
* [How to ask for R help](http://blog.revolutionanalytics.com/2014/01/how-to-ask-for-r-help.html) useful guidelines

