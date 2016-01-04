---
layout: lesson
root: ../..
---

## Selecting Data

The data we will be using is a time-series for a small mammal community in southern Arizona. This is part of a project studying the effects of rodents and ants on the plant community that has been running for almost 40 years. The rodents are sampled on a series of 24 plots, with different experimental manipulations controlling which rodents are allowed to access which plots.

**Show photos of Portal site and explain a bit more about the study, so that we can understand the data**

This is a real dataset that has been used in over 100 publications. We've simplified it just a little bit for the workshop, but you can download the [full dataset](http://esapubs.org/archive/ecol/E090/118/) and work with it using exactly the same tools we'll learn about today.

Today, we have access to several of the [main files](https://figshare.com/articles/Portal_Project_Teaching_Database/1314459) for the Portal Project that store information on: 
   1. Study plots (these are the sites that data are measured at)
   2. Species (information on each species that could be seen at the site)
   3. Surveys (measurements taken for each individual captured during each survey for ~40 years)

If we were starting this dataset from the beginning, we would basically have three options:
text files,
a spreadsheet,
or a database.

Text files are easiest to create,
and work well with version control (e.g., GitHub, not covered in DC),
but then we would then have to build search and analysis tools ourselves.
Spreadsheets are good for doing simple analysis,
they don't handle large or complex data sets very well.
We would therefore like to put this data in a database,
and these lessons will show how to do that.

<div class="objectives" markdown="1">
#### Objectives

*   Explain the difference between a table, a record, and a field.
*   Explain the difference between a database and a database manager.
*   Explain data types
*   Import the data
*   Write a query to select all values for specific fields from a single table.
</div>

### A Few Definitions


A [relational database](../../gloss.html#relational-database)
is a way to store and manipulate information
that is arranged as [tables](../../gloss.html#table).
Each table has columns (also known as [fields](../../gloss.html#field)) which describe the data,
and rows (also known as [records](../../gloss.html#record)) which contain the data.
  
When we are using a spreadsheet (like this morning),
we can put formulas into cells to calculate new values based on old ones.
When we are using a database,
we send commands
(usually called [queries](../../gloss.html#query))
to a [database manager](../../gloss.html#database-manager):
a program that manipulates the database for us.
The database manager does whatever lookups and calculations the query specifies,
returning the results in a tabular form
that we can then use as a starting point for further queries.
  
> Every database manager&mdash;Oracle,
> IBM DB2, PostgreSQL, MySQL, Microsoft Access, and SQLite&mdash;stores
> data in a different way,
> so a database created with one cannot be used directly by another.
> However,
> every database manager can import and export data in a variety of formats,
> so it *is* possible to move information from one to another.

Queries are written in a language called [SQL](../../gloss.html#sql),
which stands for "Structured Query Language".
SQL provides hundreds of different ways to analyze and recombine data;
we will only look at a handful,
but that handful accounts for most of what scientists do.

**INSTRUCTOR NOTE: We will have 3 tables in our database. Draw on board and point out the relationships between the tables. Build on notes from first half of the day**

<i>The tables below show the database we will use in our examples:</i>

<table>
<tr>
<td valign="top">
<strong>plots</strong>: information about each of the study plots/sites.

<table>
  <tr> <th>ident</th> <th>personal</th> <th>family</th> </tr>
  <tr> <td>dyer</td> <td>William</td> <td>Dyer</td> </tr>
  <tr> <td>pb</td> <td>Frank</td> <td>Pabodie</td> </tr>
  <tr> <td>lake</td> <td>Anderson</td> <td>Lake</td> </tr>
  <tr> <td>roe</td> <td>Valentina</td> <td>Roerich</td> </tr>
  <tr> <td>danforth</td> <td>Frank</td> <td>Danforth</td> </tr>
</table>

<strong>species</strong>: information about each of the species that have been seen at the site.

<table>
  <tr> <th>name</th> <th>lat</th> <th>long</th> </tr>
  <tr> <td>DR-1</td> <td>-49.85</td> <td>-128.57</td> </tr>
  <tr> <td>DR-3</td> <td>-47.15</td> <td>-126.72</td> </tr>
  <tr> <td>MSK-4</td> <td>-48.87</td> <td>-123.4</td> </tr>
</table>

<strong>surveys</strong>: measurements taken for each individual animal captured at the site.

<table>
  <tr> <th>ident</th> <th>site</th> <th>dated</th> </tr>
  <tr> <td>619</td> <td>DR-1</td> <td>1927-02-08</td> </tr>
  <tr> <td>622</td> <td>DR-1</td> <td>1927-02-10</td> </tr>
  <tr> <td>734</td> <td>DR-3</td> <td>1939-01-07</td> </tr>
  <tr> <td>735</td> <td>DR-3</td> <td>1930-01-12</td> </tr>
  <tr> <td>751</td> <td>DR-3</td> <td>1930-02-26</td> </tr>
  <tr> <td>752</td> <td>DR-3</td> <td bgcolor="red">&nbsp;</td> </tr>
  <tr> <td>837</td> <td>MSK-4</td> <td>1932-01-14</td> </tr>
  <tr> <td>844</td> <td>DR-1</td> <td>1932-03-22</td> </tr>
</table>
</td>
</table>
</tr>


Notice that three entries&mdash;one in the `Species` table,
and two in the `Survey` table&mdash;are shown in red
because they don't contain any actual data:
we'll return to these missing values [later](#s:null).

For now,
let's get started by importing the data ourselves and
writing our first SQL query.
We do this using the SQL command `select`,
giving it the names of the columns we want and the table we want them from.


##Loading the data into Firefox SQLite Manager
-----------------

###Import

Data can be added that is already in a sqlite databae, or by entering CSV or TXT files manually.

__If__ a .sqlite file already exists: 
   1. Open your database: **Database -> Connect Database** Skip the other steps. (The icon for this is the folder with an arrow pointing out of it) - From the [data link] (https://figshare.com/articles/Portal_Project_Teaching_Database/1314459) you'll notice a sqlite file. This is a database file that could be opened directly, but let's start with separate csv files so we can see how to build up the database ourselves.
   
__If__ you are putting together a database from .csv files: 
**Instructor, demonstrate using the surveys table, ask students to watch and follow along**
   1. Download the three CSV files from the Portal Database (plots.csv, species.csv, surveys.csv)
   2. Start a New Database **Database -> New Database**  You'll be asked to enter the name of the database you want to create and where you want to save it.
   3. Start to import the tables **Database -> Import** 
   4. Select the file to import
   5. Give the table a name (or use the default). Here, you will want to match the file name (surveys, species, plots).
   6. If the first row has column headings, check the appropriate box (In our examples they do)
   7. Make sure the delimiter and quotation options are correct for the CSV files. Ensure 'Ignore trailing separator/delimiter' is left *unchecked*
   8. Press **OK**
   9. When asked if you want to modify the table, click **OK**
   10. Set the data types for each field ** This is important because the type matters what you can do with the data **. Choose TEXT for fields with text (`species_id`, `genus`, `sex`, etc.) and INT for fields with numbers (`day`, `month`, `year`, `weight`, etc.).

   ####EXERCISE: 
   **Import the other tables (plots and species). If you get stuck, ask a neighbor for advice or request help from one of the    helpers!**
   *Once the data has been imported, go ahead and explore the different options for displaying the data in the SQL Manager**
      * Structure
      * Browse and Search

You can also use this same approach to append new data to an existing table.

### Adding data to existing tables
   * Browse & Search -> Add
   * Enter data into a CSV file and append to existing table (it must have the same structure - e.g. same columns)

### Data Types

<table>
  <tr> <th>Data type</th> <th>Description</th> </tr>
  <tr> <td>CHARACTER(n) </td> <td>Character string. Fixed-length n</td> </tr>
  <tr> <td>VARCHAR(n) or CHARACTER VARYING(n)</td> <td>Character string. Variable length. Maximum length n</td> </tr>
  <tr> <td>BINARY(n)</td> <td>Binary string. Fixed-length n</td> </tr>
  <tr> <td>BOOLEAN</td> <td>Stores TRUE or FALSE values</td> </tr>
  <tr> <td>VARBINARY(n) or BINARY VARYING(n)</td> <td>Binary string. Variable length. Maximum length n</td> </tr>
  <tr> <td>INTEGER(p) </td> <td>Integer numerical (no decimal).</td> </tr>
  <tr> <td>SMALLINT</td> <td>Integer numerical (no decimal).</td> </tr>
  <tr> <td>INTEGER</td> <td>Integer numerical (no decimal).</td> </tr>
  <tr> <td>BIGINT</td> <td>Integer numerical (no decimal).</td> </tr>
  <tr> <td>DECIMAL(p,s)</td> <td>Exact numerical, precision p, scale s.</td> </tr>
  <tr> <td>NUMERIC(p,s) </td> <td>Exact numerical, precision p, scale s. (Same as DECIMAL)</td> </tr>
  <tr> <td>FLOAT(p)</td> <td>Approximate numerical, mantissa precision p. A floating number in base 10 exponential notation.</td> </tr>
  <tr> <td>REAL</td> <td>Approximate numerical</td> </tr>
  <tr> <td>FLOAT</td> <td>Approximate numerical</td> </tr>
  <tr> <td>DOUBLE PRECISION</td> <td>Approximate numerical</td> </tr>
  <tr> <td>DATE</td> <td>Stores year, month, and day values</td> </tr>
  <tr> <td>TIME</td> <td>Stores hour, minute, and second values</td> </tr>
  <tr> <td>TIMESTAMP</td> <td>Stores year, month, day, hour, minute, and second values</td> </tr>
  <tr> <td>INTERVAL</td> <td>Composed of a number of integer fields, representing a period of time, depending on the type of interval</td> </tr>
  <tr> <td>ARRAY</td> <td>A set-length and ordered collection of elements</td> </tr>
    <tr> <td>MULTISET</td> <td>A variable-length and unordered collection of elements</td> </tr>
  <tr> <td>XML</td> <td>Stores XML data</td> </tr>
  <tr> <td>SQL</td> <td>Data Type Quick Reference</td> </tr>
</table>

Different databases offer different choices for the data type definition.

The following table shows some of the common names of data types between the various database platforms:
<table>
  <tr> <th>Data type</th> <th>Access</th> <th>SQLServer</th> <th>Oracle</th> <th>MySQL</th> <th>PostgreSQL</th> </tr>
  <tr> <td>boolean</td> <td>Yes/No</td> <td>Bit</td> <td>Byte</td> <td>N/A</td> <td>Boolean</td> </tr>
  <tr> <td>integer</td> <td>Number (integer)</td> <td>Int</td> <td>Number</td> <td>Int/Integer</td> <td>Int/Integer</td> </tr>
  <tr> <td>float</td> <td>Number (single)</td> <td>Float/Real</td> <td>Number</td> <td>Float</td> <td>Numeric</td> </tr>
  <tr> <td>currency</td> <td>Currency</td> <td>Money</td> <td>N/A</td> <td>N/A</td> <td>Money</td> </tr>
  <tr> <td>string (fixed)</td> <td>N/A</td> <td>Char</td> <td>Cjar</td> <td>Char</td> <td>Char</td> </tr>
  <tr> <td>string (variable)</td> <td>Text(<256) / Memo (65k+)</td> <td>Varchar</td> <td>Varchar / Varchar2</td> <td>Varchar</td> <td>Varchar</td> </tr>
  <tr> <td>binary object OLE Object Memo Binary (fixed up to 8K)</td> <td>Varbinary (<8K) </td> <td>Image (<2GB) Long</td> <td>Raw Blob</td> <td>Text Binary</td> <td>Varbinary</td> </tr>
</table>

**Discuss different data types with students. Have students discuss with partner examples of when you might use certain data types, and ask for a few examples. Ask if there are any questions**

# Basic Queries

### Writing a Query
Let's make our first SQL query!
Let's start by using the **surveys** table. Here, we have data on every individual that was captured at the site, including when they were captured, what plot they were captured on, their species ID, sex, and weight in grams.

Go to the "Execute SQL" tab in the SQLite Manager. This is the place that we will use to write our queries in this tool. If we decide later that we would like to save a summary table, we can use "Create View" under the "View" toolbar (more on this later).

Our query and its output look like this:

<pre class="in"><code>%SELECT * FROM table;</code></pre>

In the above example, `*` represents all the columns in the table. But we can pick and choose which columns we would like to see.

Let's write an SQL query that selects only the year column from the surveys table.

<pre class="in"><code>SELECT year FROM surveys;</code></pre>

If we want more information, we can just add a new column to the list of fields, right after the SELECT statement:

<pre class="in"><code>SELECT year, month, day FROM surveys;</code></pre>

In the Firefox SQLite Manager, we don't need to end our statement with a semi-colon (although we can), but in many other tools you do. The semi-colon at the end of the query tells the database manager that the query is complete and ready to run.

We have capitalized the words SELECT and FROM because they are SQL keywords, or commands. SQL is case insensitive, but it helps for readability - good style (more on the importance of style tomorrow!).
We have written our commands and column names in lower case, and the table name in Title Case,
but we don't have to:
as the example below shows, SQL is [case insensitive](../../gloss.html#case-insensitive).

<pre class="in"><code>SeLeCt YeAr, MonTH, DaY FrOm SuRvEyS;</code></pre>

**Note:**
Whatever casing convention you choose, please be consistent:
complex queries are hard enough to read without the extra cognitive load of random capitalization. Here, I have capitalized the words SELECT and FROM because they are SQL keywords. For me, this helps with readability – good style.


Going back to our query, it's important to understand that
the rows and columns in a database table aren't actually stored in any particular order.
They will always be *displayed* in some order,but we can control that in various ways.
For example,
we could swap the columns in the output by writing our query as:


<pre class="in"><code>SELECT day, month, year FROM surveys;</code></pre>

or even repeat columns:

<pre class="in"><code>SELECT day, day, day FROM surveys;</code></pre>

And remember, as a shortcut,
we can select all of the columns in a table using `*`.

#### Challenges

1.  Write a query that selects only the plotID and description from the `plots` table.

2.  Many people format queries as:

    ~~~
    SELECT personal, family FROM person;
    ~~~

    or as:

    ~~~
    select Personal, Family from PERSON;
    ~~~

    What style do you find easiest to read, and why?


<div class="keypoints" markdown="1">
#### Key Points
</div>

*    A relational database stores information in tables,
    each of which has a fixed set of columns and a variable number of records.
 *   A database manager is a program that manipulates information stored in a database.
 *   We write queries in a specialized language called SQL to extract information from databases.
 *   SQL is case-insensitive.
