---
layout: lesson
root: ../..
---

## Combining Data- Joins and Aliases


<div class="objectives" markdown="1">
#### Objectives
</div>
*   Explain the operation of a query that joins two tables.
*   Explain how to restrict the output of a query containing a join to only include meaningful combinations of values.
*   Write queries that join tables on equal keys.
*   Explain what primary and foreign keys are, and why they are useful.
*   Explain what atomic values are, and why database fields should only contain atomic values.

**So far, everything we have done has been about one table. But the real power for databases comes when we consider how data can be linked across tables.**


Database Design
----------------
**Each field in a database should store a single value.
Information should not be duplicated in a database.
Each table should be about a single subject (avoids uneccesary replication).
When naming fields, think about meaning, not presentation.**

**When we divide our data between several tables, we need a way to bring it back together. 
The key is to have an identifier in common between tables - shared columns. 
This will allow us to JOIN tables.
This is what we will discuss now.**

**For example, the species code is included in the Survey table,
but we don’t know the full scientific names if we only look at this table.
That information is stored in the species table and can be
linked to if we need it.
This means that we don't have to record the full family, genus, and species,
information every time a reading is recorded. The same is true for the details of each of the experimental plots
that surveys take place on. As databases get larger, minimizing repeated information is extremely useful!**  

##Joins
To combine data from two (or more) tables, we use the SQL `JOIN` command, which comes after the `FROM` command. 
**Add to hierarchy of terms on the board**

We also need to tell the computer which columns provide the link between the two tables using the word `ON`. What we want is to join the data with the same species codes. To see how this works, lets start by linking the surveys and the species tables:

<pre class="in"><code>SELECT * 
FROM surveys JOIN species
ON surveys.species.id = species.species_id;</code></pre>

ON is like `WHERE`, it filters things things out according to a test condition. We use the `table.colname` format to tell the manager what column in which table we are referring to.

`join` creates
the [cross product](../../gloss.html#cross-product)
of two tables,
i.e.,
it joins each record of one with each record of the other
to give all possible combinations.

**If we forgot to include `ON`:**
Since there are 35549 records in `surveys`
and 54 in `species`,
the join's output has 1,919,646 records.
And since each table has 10 and 4 fields,
the output has 40 fields.
What the join *hasn't* done is
figure out if the records being joined have anything to do with each other.
It has no way of knowing whether they do or not until we tell it how.
To do that,
we add a clause specifying that
we're only interested in combinations that have the same site name, which is what `ON` does for us!

`ON` does the same job as `WHERE`:
it only keeps records that pass some test.
(The difference between the two is that `ON` filters records
as they're being created,
while `WHERE` waits until the join is done
and then does the filtering.)
Once we add this to our query,
the database manager throws away records
that combined information about two different sites,
leaving us with just the ones we want.

We often won't want all of the fields from both tables, so anywhere we would have used a field name in a non-join query, we can use the `table.colname` format under SELECT.

For example, what if we wanted information on when individuals of each species were captured, but instead of their species ID we wanted their actual species names.

<pre class="in"><code>SELECT surveys.year, surveys.month, surveys.day, species.genus, species.species 
FROM surveys JOIN species
ON surveys.species.id = species.species_id;</code></pre>

####Challenge
   Write a query that returns the genus, species, and the weight of every individual captured at the site.

##Aliases (a reminder)
As queries get more complex, names can get long and unwieldy. To help make things clearer we can use aliases to assign new names to things in the query.

We can alias both table names:

<pre class="in"><code>SELECT surv.year, surv.month, surv.day, surv.genus, sp.species
FROM surveys AS surv JOIN species AS sp
ON surv.species.id = sp.species_id;</code></pre>

And column names: 

<pre class="in"><code>SELECT surv.year AS yr, surv.month AS mo, surv.day AS day, surv.genus AS gen, sp.species AS sp 
FROM surveys AS surv JOIN species AS sp
ON surv.species.id = sp.species_id;</code></pre>

The `AS` isn't technically required, so you could do:

<pre class="in"><code>SELECT surv.year yr
FROM surveys surv;</code></pre>

but using `AS` is much clearer, so it's good style to include it. Saving typing is nice, but not if it makes what you've done confusing to read. **Remember, you 6 months ago are your own worst collaborator!**


## Joining More than 2 tables
If joining two tables is good,
joining many tables must be better.
In fact,
we can join any number of tables
simply by adding more `join` clauses to our query,
and more `on` tests to filter out combinations of records
that don't make sense:

<pre class="in"><code>SELECT surv.year AS yr, surv.month AS mo, surv.day AS day, surv.genus AS gen, sp.species AS sp plots.plot_description
FROM surveys AS surv JOIN species AS sp JOIN plots
ON surv.species.id = sp.species_id
AND surv.plot = plots.plot_id
WHERE surv.year > 1999;</code></pre>

*We can tell which records from `surveys`, `species`, and `plots`
correspond with each other
because those tables contain
[primary keys](../../gloss.html#primary-key)
and [foreign keys](../../gloss.html#foreign-key).
A **primary key** is a value,
or combination of values,
that uniquely identifies each record in a table.
A foreign key is a value (or combination of values) from one table
that identifies a unique record in another table.
Another way of saying this is that
a foreign key is the primary key of one table
that appears in some other table.*
In our database,
`plots.plot_id` is the primary key in the `plots` table,
while `surveys.plot` is a foreign key
relating the `surveys` table's entries
to entries in `plots`.

*Most database designers believe that
every table should have a well-defined primary key.
They also believe that this key should be separate from the data itself,
so that if we ever need to change the data,
we only need to make one change in one place.
One easy way to do this is
to create an arbitrary, unique ID for each record
as we add it to the database.
This is actually very common:
those IDs have names like "student numbers" and "patient numbers",
and they almost always turn out to have originally been
a unique record identifier in some database system or other.*

As the query below demonstrates,
SQLite automatically numbers records as they're added to tables,
and we can use those record numbers in queries:

<pre class="in"><code>SELECT rowid, * FROM plots;</code></pre>

## Data Hygiene
Now that we have seen how joins work,
we can see why the relational model is so useful
and how best to use it.

The **first rule** is that every value should be [atomic](../../gloss.html#atomic-value),
i.e.,
not contain parts that we might want to work with separately.
We store personal and family names in separate columns instead of putting the entire name in one column
so that we don't have to use substring operations to get the name's components.
More importantly,
we store the two parts of the name separately because splitting on spaces is unreliable:
just think of a name like "Eloise St. Cyr" or "Jan Mikkel Steubart" or for those of you familiar with species names, 
we might have *dipodomys merriami* or *dipodomys cf merriami*.

The **second rule** is that every record should have a unique primary key.
This can be a serial number that has no intrinsic meaning,
one of the values in the record (like the `plot_id` field in the `plots` table),
or even a combination of values:
the triple `(year, month, day, plot, stake)` from the `surveys` table uniquely identifies every measurement.

The **third rule** is that there should be no redundant information.
For example,
we could get rid of the `plots` table and rewrite the `surveys` table as a single giant data table that would just record all the plot description and experiment type each time...

In fact,
we could use a single table that recorded all the information about each reading in each row,
just as a spreadsheet would.
The problem is that it's very hard to keep data organized this way consistent:
if we realize that the date of a particular visit to a particular site is wrong,
or that a species name has been updated,
we have to change multiple records in the database.
What's worse,
we may have to guess which records to change,
since other sites may also have been visited on that date.

The **fourth rule** is that the units for every value should be stored explicitly.
Our database doesn't do this,
and that's a potential problem:
The weights of Neotoma albigula are several orders of magnitude larger than for Perognathus flavus,
but if we aren't familiar with the data, we don't know if that means that the units of measurement are different, or 
if these species represent truly different size classes.

**Brief discussion on storing metadata, or at least simple README files that explain your data**

Stepping back,
data and the tools used to store it have a symbiotic relationship:
we use tables and joins because it's efficient,
provided our data is organized a certain way,
but organize our data that way because we have tools to manipulate it efficiently
if it's in a certain form.
As anthropologists say,
the tool shapes the hand that shapes the tool.

#####Complex Joins
We won't cover it here today, but there are ways to join the data in more complex ways. 

* `INNER JOIN` returns all rows from both tables where there is a match. If there are rows in first table that do not have matches in second table, those rows will not be listed.
* `LEFT JOIN` returns all the rows from the first table, even if there are no matches in the second table. If there are rows in first table that do not have matches in second table, those rows also will be listed.
* `RIGHT JOIN` returns all the rows from the second table, even if there are no matches in the first table. If there had been any rows in second table that did not have matches in first table, those rows also would have been listed.


#### Challenges

1.  Write a query that lists all measurements taken from the kangaroo rat exclosures.

2.  Write a query that lists all the plots on which a rare species, Baiomys taylori, was captured.

3.  Describe in your own words what the following query produces:

    ~~~
    SELECT plots.plot_id FROM plots JOIN surveys
    ON surveys.year=1999  AND surveys.month = 6 and surveys.day=30 AND plots.plot_id=surveys.plot;
    ~~~

**ANSWER: ON acts like WHERE. Could also be written using WHERE and ON. Would you write this a different way to make it more clear?**

<div class="keypoints" markdown="1">
#### Key Points
</div>
*   Every fact should be represented in a database exactly once.
*   A join produces all combinations of records from one table with records from another.
*   A primary key is a field (or set of fields) whose values uniquely identify the records in a table.
*   A foreign key is a field (or set of fields) in one table whose values are a primary key in another table.
*   We can eliminate meaningless combinations of records by matching primary keys and foreign keys between tables.
*   Keys should be atomic values to make joins simpler and more efficient.
