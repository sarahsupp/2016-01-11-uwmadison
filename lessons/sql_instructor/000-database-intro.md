Databases using SQL
===================

**You will need the Firefox Mozilla browser and the Firefox SQLite Manager plugin.**

*Turn to your neighbor: Do you have dataset(s) that you currently work with? What kind of data is it? Where do you store it? Have you ever had a problem with data being TOO BIG?*

Relational databases
--------------------
* Relational databases store data in tables and with fields (columns) and records (rows)
* Data in tables has types, just like in R (or Python or any other program), and all values in a field have the same type* 

###A flood of data!

  * Databases help us organize and keep track of our data
  * Writing programs (which is what we'll do tomorrow) helps us wade through all the data
  * Sometimes, relational databases are necessary to efficiently get through the data

### Why use relational databases

* databases can help you
  * ask more complex questions
  * write faster code
  * run faster analyses

* Queries let us look up data or make calculations based on columns
* This is important because it **keeps our daqta separate from analysis**
  * No risk of accidentally changing the data when we analyze it
  * Queries are distinct from the data, so if we change the data we can just rerun the query
* Fast for large amounts of data
* Improve quality control of data entry (type constraints and use of forms in Access, Filemaker, etc.)
  * *Remember the problems we identified in the previous lesson with mismatched data types and mistakes in the data?*
* The concepts of relational database querying are core to understanding how to do similar things using programming languages such as R and Python --> Once you learn SQL basics, you can translate easily to other programs used in your workplace or research!

###Database Management Systems
There are many different database management systems for working with relational data. We're going to use SQLite today, but basically everything we teach you will apply to the other database systems as well (e.g., MySQL, PostgreSQL, MS Access, Filemaker Pro, Oracle, etc.). The ony things that will differ are the details of exactly how to import and export data, the details of data types, and things that are specific to the GUI (e.g. where the shortcut buttons are).

* A database manager is a program that manipulates a database
* Commands or queries in a database manager are usually written in SQL
* rows and columns of a database table are not stored in any particular order
* Database design takes practice (but revist example of geek vs. non-geek problem solving)
  * Lots of literature on designing database schema - need good knowledge of data!
* Yes, you can eventually ask the same questions using your programming ninja skills, but it can get really complicated, take a long time to do, and be difficult to debug.
  * Step 1: Read a really really big file
  * Step 2: Select, find and filter the data we need from the file
  * Then do analyses
  *Databases: Step 1: data is already indexed, so move right to selecting and filtering data!!
  
###SQL

* MySQL most popular database system for bioinformatics
* FREE!
* Many Genome browsers, Entrez, Ensembl, Gene Ontology use MySQL to run Web Portals
* Can update, modify tables, save queries (repetitive tasks)
* Combine database skills with programming environments
  * Now you are omnipotent!

### Database Design
**Sketch basics of database design on whiteboard to illustrate**
  1. Every row-column combination contains a single *atomic* value, i.e., not containing parts we might want to work with separately
  2. One field per type of information (a *field* is a column of data)
  3. No redundant information
   * split into separate tables with one table per class of information
    * Needs an identifier that is in common between tables - shared column - to reconnect (foreign key)

*Any questions so far?*

### Introduction to SQLite Manager
Let's all open the database we downloaded in SQLite Manager by clicking on the open file icon.

You can see the tables in the database by looking at the left hand side of the screen under Tables.

To see the contents of a table, click on that table and then click on the Browse and search tab in the right hand section of the screen.

If we want to write a query, we click on the Execute SQL tab.

**Give everyone a minute to explore the SQLite interface, make sure they can successfully open the file, and to ask questions of their neighbors or the helpers**

###Our Lesson Today:
There are lots of different ways to interact with relational databases. The important thing is to get a sense of how to structure your data, and to use the tool that makes the most sense based on your database size and your collaborator's tools and skill sets. There are commands to interact with databases through the command line, in R, Python, and there are visual ways such as Microsoft Access, Oracle (business) and Firefox. 

**Dataset Description:** 
The data we will be using is a time-series for a small mammal community in southern Arizona. This is part of a project studying the effects of rodents and ants on the plant community that has been running for almost 40 years. The rodents are sampled on a series of 24 plots, with different experimental manipulations controlling which rodents are allowed to access which plots.

This is a real dataset that has been used in over 100 publications. We've simplified it just a little bit for the workshop, but you can download the [full dataset](http://esapubs.org/archive/ecol/E090/118/) and work with it using exactly the same tools we'll learn about today.
