Databases using SQL
===================

**You will need the Firefox Mozilla browser and the Firefox SQLite Manager plugin. You will also need Wget or cURL installed for your shell**

Relational databases
--------------------

* Relational databases store data in tables and with fields (columns) and records (rows)
* Data in tables has types, just like in Python, and all values in a field have the same type

###A flood of data!

  * Writing programs helps us wade through all the data
  * Sometimes, relational databases are necessary to efficiently get through the data
* databases can help you
  * ask more complex questions
  * write faster code
  * run faster analyses

* Queries let us look up data or make calculations based on columns
* The queries are distinct from the data, so if we change the data we can just rerun the query

###Database managers

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
* Combine database skillz with programming environments
  * Now you are omnipotent!


#
###Our Lesson Today:
There are lots of different ways to interact with relational databases. The important thing is to get a sense of how to structure your data, and to use the tool that makes the most sense based on your database size and your collaborator's tools and skill sets. There are commands to interact with databases through the command line, in R, Python, and there are visual ways such as Microsoft Access, Oracle (business) and Firefox. 

We will use what we have learned about the command line to download and build our database from the web (alhtough it could just as easily be downloaded using a GUI), and then we will interact with it using the Firefox plug-in, because it will work the same on everyone's OSs.