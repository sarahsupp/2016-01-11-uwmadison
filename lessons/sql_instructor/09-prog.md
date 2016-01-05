---
layout: lesson
root: ../..
---

## Programming with Databases


<div class="objectives" markdown="1">
#### Objectives
</div>
*   Write short programs that execute SQL queries.
*   Trace the execution of a program that contains an SQL query.
*   Explain why most database applications are written in a general-purpose language rather than in SQL.
</div>


To close,
let's have a look at how to access a database from
a statistical programming language like R.
Other languages, such as Python, use almost exactly the same model:
library and function names may differ,
but the concepts are the same.

Here's a short R program that selects latitudes and longitudes
from an SQLite database stored in a file called `survey.db`:

<pre class="in"><code>#install and load the package
install.packages(RSQLite)
library(RSQLite)

#locate the db files onyour computer
system("ls *.db", show=TRUE)

#set up the connection to the database
driver = dbDriver("SQLite")
con = dbConnect(driver, dbname="survey.db")

#get desired data as a dataframe
results = dbGetQuery(con, "select lat, long from site")

#close connection to database
dbDisconnect(con)
rm(con)
</code></pre>

<div class="out"><pre class='out'><code>(-49.85, -128.57)
(-47.15, -126.72)
(-48.87, -123.4)
</code></pre></div>


The program starts by installing and loading the `RSQLite` library.
If we were connecting to MySQL, DB2, or some other database,
we might need to import a different library,
but all of them provide the same functions,
so that the rest of our program does not have to change
(at least, not much)
if we switch from one database to another.

Line 2 establishes a connection to the database.
Since we're using SQLite, we need to specify the driver and the name of the database file.
Some systems may require us to provide a username and password as well.

We then can ask the database to execute a query for us and save the results to a dataframe.
The query is written in SQL adn surrounded by quotes, so it can be passed to `dbGetQuery` as a string.
It's our job to make sure that SQL is properly formatted;
if it isn't,
or if something goes wrong when it is being executed,
the database will report an error.

If we look at the dataframew we can see that it has the data we requested in two columns: lat and long for the sites.

The final lines close our connection,
since the database can only keep a limited number of these open at one time. If we are ony working with one database, we can run multiple queries before closing it. 
Since establishing a connection takes time,
though,
we shouldn't open a connection,
do one operation,
then close the connection,
only to reopen it a few microseconds later to do another operation.
Instead,
it's normal to create one connection that stays open for the lifetime of the program.
But when we are done, it is good practice to close the connenction.


Queries in real applications will often depend on values provided by users.
For example,
this function takes a user's ID as a parameter and returns their name:


<pre class="in"><code>get_name = function(db_file, person_ident){
  query = paste("select personal || ' ' || family from Person where ident='", person_ident, "';", sep="")
  
  db = dbConnect(driver, dbname=db_file)
  results = dbGetQuery(db, query)
  dbDisconnect(db)
  
  return (results[1,1])
}

get_name("survey.db", "dyer")</code></pre>


<div class="out"><pre class='out'><code>William Dyer
</code></pre></div>


We use string concatenation (`paste`) on the first line of this function
to construct a query containing the user ID we have been given.
This seems simple enough,
but what happens if someone gives us this string as input?

~~~
dyer'; drop table Survey; select '
~~~

It looks like there's garbage after the name of the project,
but it is very carefully chosen garbage.
If we insert this string into our query,
the result is:

~~~
select personal || ' ' || family from Person where ident='dyer'; drop tale Survey; select '';
~~~

If we execute this,
it will erase one of the tables in our database.
  
This is called an [SQL injection attack](../../gloss.html#sql-injection-attack),
and it has been used to attack thousands of programs over the years.
In particular,
many web sites that take data from users insert values directly into queries
without checking them carefully first.
  
Since a villain might try to smuggle commands into our queries in many different ways,
the safest way to deal with this threat is
to replace characters like quotes with their escaped equivalents,
so that we can safely put whatever the user gives us inside a string.
We can do this by using a [prepared statement](../../gloss.html#prepared-statement)
instead of formatting our statements as strings, a more advanced topic we will not cover today.

A prepared statement makes key changes in the query string that allows user input. then translates the string and makes sure that the values are safe to use (e.g. will not damage the database).


#### Challenges

1.  Write an short R program that connects to the portal_mammals 	database, a real long-term ecological dataset. 
   **Explore:** Use 	commands in R to determine the names of the tables, and the 	names of the fields in the tables. 
   **Return:** Write a  	query that returns a dataframe with the total rodent mass for each year. 
   Write a second query 	that returns a dataframe with 	the average weight (rounded 2 decimal places) for each year, 	plot and species.  
   Disconnect from 	your copy of the database.

2.  **Explore:** Look at the dataframe in R. How many species are there? How does mass change throughout the years? 
   Plot the 	results for avg_wgt vs. year. 
   Write a script that subsets the data to only include species starting with "D". These are keystone kangaroo rat species. 
   Plot their average masses by year.



<div class="keypoints" markdown="1">
</div>
#### Key Points

*   We usually write database applications in a general-purpose language, and embed SQL queries in it.
*   To connect to a database, a program must use a library specific to that database manager.
*   A program may open one or more connections to a single database, and have one or more cursors active in each.
*   Programs can read query results in batches or all at once.
