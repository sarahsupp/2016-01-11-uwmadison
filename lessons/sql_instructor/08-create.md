---
layout: lesson
root: ../..
---

## Creating and Modifying Data


<div class="objectives" markdown="1">
#### Objectives
</div>
*   Write queries that creates tables.
*   Write queries to insert, modify, and delete records.

**Cover only if there is time, if students are following along, if they've asked about it, and it seems to make sense**

So far we have only looked at how to get information out of a database,
both because that is more frequent than adding information,
and because most other operations only make sense
once queries are understood.
If we want to create and modify data,
we need to know two other sets of commands.

### Creating and Removing Tables

The first pair are `create table` and `drop table`.
While they are written as two words,
they are actually single commands.
The first one creates a new table;
its arguments are the names and types of the table's columns.
For example,
the following statements create the four tables in our survey database:

**modify below for actual colnames and data types**
~~~
CREATE TABLE plots(ident text, personal text, family text);
CREATE TABLE species(name text, lat real, long real);
CREATE TABLE surveys(ident integer, site text, dated text);
~~~

We can get rid of one of our tables using:

~~~
DROP TABLE surveys;
~~~

Be very careful when doing this:
most databases have some support for undoing changes,
but it's better not to have to rely on it.

**One of the best things about learning these concepts is that you can read and laugh at XKCD comics now! Here's one about [little Bobby Tables](https://xkcd.com/327/).**
  
Different database systems support different data types for table columns,
but most provide the following:

<table>
  <tr> <td>integer</td> <td>a signed integer</td> </tr>
  <tr> <td>real</td> <td>a floating point number</td> </tr>
  <tr> <td>text</td> <td>a character string</td> </tr>
  <tr> <td>blob</td> <td>a "binary large object", such as an image</td> </tr>
</table>

Most databases also support Booleans and date/time values;
SQLite uses the integers 0 and 1 for the former,
and represents the latter as discussed [earlier](#a:dates).
An increasing number of databases also support geographic data types,
such as latitude and longitude.
Keeping track of what particular systems do or do not offer,
and what names they give different data types,
is an unending portability headache.

**For these reasons,my recommendation is to keep things as simple as possible, but no simpler...**
  
When we create a table,
we can specify several kinds of constraints on its columns.
For example,
a better definition for the `surveys` table would be:

~~~
CREATE TABLE Survey(
    taken   integer not null, -- where reading taken
    person  text,             -- may not know who took it
    quant   real not null,    -- the quantity measured
    reading real not null,    -- the actual reading
    primary key(taken, quant),
    foreign key(taken) references Visited(ident),
    foreign key(person) references Person(ident)
);
~~~

Once again,
exactly what constraints are avialable
and what they're called
depends on which database manager we are using.


### Adding, Removing, and Updating Data

Once tables have been created,
we can add, change, and remove records using our other set of commands,
`insert`, `update`, and `delete`.

The simplest form of `insert` statement lists values in order:

~~~
INSERT INTO species VALUES('PI', 'Heteromyidae', 'Chaetodipus', 'intermedius', 'rodent');
~~~

We can also insert values into one table directly from another:

~~~
CREATE TABLE JustLatLong(lat text, long text);
INSERT INTO JustLatLong SELECT lat, long FROM site;
~~~


~~~
DROP TABLE JustLatLong(lat text, long text);
~~~


Modifying existing records is done using the `update` statement.
To do this we tell the database which table we want to update,
what we want to change the values to for any or all of the fields,
and under what conditions we should update the values.

For example, if we made a mistake when entering the lat and long values
of the last `insert` statement above:

~~~
UPDATE species SET genus='Perognathus' WHERE species_id='PB'
~~~

**Be care to not forget the `where` clause or the update statement will
modify *all* of the records in the database.**

Deleting records can be a bit trickier,
because we have to ensure that the database remains internally consistent.
If all we care about is a single table,
we can use the `delete` command with a `where` clause
that matches the records we want to discard.
For example,
if we have a species in the species table that never occurs in our surveys table (e.g. it has never been observed or measured),
we can remove it from the `species` table like this:

~~~
DELETE FROM species WHERE species.id = "ZZ";
~~~

But what if we removed a species that *is* found in the surveys instead, like *Dipodomys ordii*?
Our `surveys` table would still contain records
of measurements of 'DO',
but that's never supposed to happen:
`surveys.species_id` is a foreign key into the `species` table,
and all our queries assume there will be a row in the latter
matching every value in the former.
  
This problem is called [referential integrity](../../gloss.html#referential-integrity):
we need to ensure that all references between tables can always be resolved correctly.
One way to do this is to delete all the records
that use `'DO'` as a foreign key
before deleting the record that uses it as a primary key.
If our database manager supports it,
we can automate this
using [cascading delete](../../gloss.html#cascading-delete).
However,
this technique is outside the scope of this chapter. **And it is unlikely that we would want to rid ourselves of this information, unless  it truly represented a mistake or error**

> Many applications use a hybrid storage model
> instead of putting everything into a database:
> the actual data (such as astronomical images) is stored in files,
> while the database stores the files' names,
> their modification dates,
> the region of the sky they cover,
> their spectral characteristics,
> and so on.
> This is also how most music player software is built:
> the database inside the application keeps track of the MP3 files,
> but the files themselves live on disk.


#### Challenges

1.  Write an SQL statement to replace all uses of `R`
    in `surveys.sex`
    with the string `'unknown'`.

2.  One of our colleagues has sent us a [CSV](../../gloss.html#comma-separeted-values) file
    containing surveys on a new nearby plots, 25,
    which is formatted like this:

    ~~~
    plot,type
    25, control, DO, M, 34
    25, control, DO, F, 40
    25, control, PP, M, 14
    25, control, PB, M, 26
    ~~~
    
    **What would you need to update to add this information to your database? Which tables? Use `update` to add the data to your table.**



<div class="keypoints" markdown="1">
#### Key Points
</div>
*   Database tables are created using queries that specify their names and the names and properties of their fields.
*   Records can be inserted, updated, or deleted using queries.
*   It is simpler and safer to modify data when every record has a unique primary key.
</div>
