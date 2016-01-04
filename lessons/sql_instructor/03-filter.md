---
layout: lesson
root: ../..
---

## Filtering


<div class="objectives" markdown="1">
#### Objectives
</div>
*   Write queries that select records that satisfy user-specified conditions.
*   Explain the order in which the clauses in a query are executed.


One of the most powerful features of a database is
the ability to [filter](../../gloss.html#filter) data,
i.e.,
to select only those records that match certain criteria.
For example,
let's say we only want data for *Dipodomys merriami*, which has a species code of DM.
We need to add a WHERE clause to our query:

<pre class="in"><code>SELECT * FROM surveys WHERE species_id = 'DM';</code></pre>

We can do the same thing with numbers. Here, we only want the data since 2000:

<pre class="in"><code>SELECT * FROM surveys WHERE year >= 2000;</code></pre>

**Note:** 'DM' is in quotes because it is a character string. 2000 is not because it is a number.

The database manager executes this kind of query in two stages.
  
   1. it checks at each row in the `Visited` table
to see which ones satisfy the `where`.
   2. It then uses the column names following the `select` keyword
to determine what columns to display.

We can use more sophisticated conditions by combining tests with AND or OR. For example, suppose we want the data on *Dipodomys merriami* starting in the year 2000:

<pre class="in"><code>SELECT * FROM surveys WHERE (year >= 2000) AND (species_id='DM');</code></pre>

Note that the parentheses aren't needed, but again, they help with readability. **Your worst collaborator is yourself from 6 months ago - this is why style is important!** They also ensure that the computer combines AND and OR in the way we intend.

If we wanted to get data for any of the *Dipodomys* species, which have species codes DM, DO, and DS, we could combine the tests using OR:

<pre class="in"><code>SELECT * FROM surveys WHERE (species_id='DM') OR (species_id='DO') OR (species_id='DS');</code></pre>

####Challenge
   Write a query that returns the day, month, year, species_id, and weight (in kg) for individuals caught on plot 1 that weigh more than 75 g. 
   Sort by weight and species_id.


Remember how the computer is doing the filtering? (Hint: it first checks for the filtering condition to be met, then determines what to display in the output.) This processing order means that
we can filter records using `where`
based on values in columns that aren't then displayed:

<pre class="in"><code>SELECT genus, species FROM species WHERE (species_id='DM') OR (species_id='DO') OR (species_id='DS');</code></pre>

Alternatively,
we can use `IN` to see if a value is in a specific set:

<pre class="in"><code>SELECT * FROM surveys WHERE species_id IN ('DM','DO','DS');</code></pre>

We can combine `and` with `or`,
but we need to be careful about which operator is executed first.
If we *don't* use parentheses,
we get this:

<pre class="in"><code>SELECT * FROM surveys WHERE year=1998 AND species_id='OL' OR species_id='OT';</code></pre>

**DISCUSS: What did this query return? Was it what you wanted? How do you think you might fix it?**

The query would return measurements of OL in 1998, and *any* measurements of OT.
We probably want this instead:

<pre class="in"><code>SELECT * FROM surveys WHERE year=1998 AND (species_id='OL' OR species_id='OT');</code></pre>

Finally,
we can use `distinct` with `where`
to give a second level of filtering - if we want to know in what years different cotton rat species were captured:

<pre class="in"><code>SELECT DISTINCT year, species_id FROM Survey WHERE (species_id='SH') OR (species_id='SO') OR (species_id='SF');</code></pre>

But remember:
`distinct` is applied to the values displayed in the chosen columns,
not to the entire rows as they are being processed.

> What we have just done is how most people "grow" their SQL queries.
> We started with something simple that did part of what we wanted,
> then added more clauses one by one,
> testing their effects as we went.
> This is a good strategy&mdash;in fact,
> for complex queries it's often the *only* strategy&mdash;but
> it depends on quick turnaround,
> and on us recognizing the right answer when we get it.
>     
> The best way to achieve quick turnaround is often
> to put a subset of data in a temporary database
> and run our queries against that,
> or to fill a small database with synthesized records.
> For example,
> instead of trying our queries against an actual database of 20 million Australians,
> we could run it against a sample of ten thousand,
> or write a small program to generate ten thousand random (but plausible) records
> and use that.

**A note on Dates:**

> Most database managers have a special data type for dates.
> In fact, many have two:
> one for dates,
> such as "May 31, 1971",
> and one for durations,
> such as "31 days".
> SQLite doesn't:
> instead,
> it stores dates as either text
> (in the ISO-8601 standard format "YYYY-MM-DD HH:MM:SS.SSSS"),
> real numbers
> (the number of days since November 24, 4714 BCE),
> or integers
> (the number of seconds since midnight, January 1, 1970).
> If this sounds complicated,
> it is,
> but not nearly as complicated as figuring out
> [historical dates in Sweden](http://en.wikipedia.org/wiki/Swedish_calendar).

**This is why for several of my ecological databases, I have stored dates as 3 separate columns. It's a bit clunky, but this allows me to store them as integers (for year, month, and day separately) that can be queried easily. e.g. all rodents captured in July and August, or species captured before 1989).**


#### Challenges

1.  Suppose we want to select all plots that are in the center of the site (plots 7-19).
    Our first query is:

    ~~~
    select * from plots where (plot_id > 7) or (plot_id < 19);
    ~~~

    **Explain why this is wrong**,
    and rewrite the query so that it is correct.

2.  The upper range for rodent weights are around 200 grams (Pack rats can get very large) and the lower range is around 5 grams (silky pocket mice are very small). Write a query that selects all the records from survey with weight values outside this range. 

3.  The SQL test `*column-name* like *pattern*`
    is true if the value in the named column
    matches the pattern given;
    the character '%' can be used any number of times in the pattern
    to mean "match zero or more characters". Compare your work with a partner.

    <table>
      <tr> <th>Expression</th> <th>Value</th> </tr>
      <tr> <td><code>'a' like 'a'</code></td> <td>True</td> </tr>
      <tr> <td><code>'a' like '%a'</code></td> <td>True</td> </tr>
      <tr> <td><code>'b' like '%a'</code></td> <td>False</td> </tr>
      <tr> <td><code>'alpha' like 'a%'</code></td> <td>True</td> </tr>
      <tr> <td><code>'alpha' like 'a%p%'</code></td> <td>True</td> </tr>
    </table>
    The expression `*column-name* not like *pattern*`inverts the test.
    Using `like`,
    write a query that finds all the records in `species`
    that *aren't* from genera starting with 'Pe'-somthing.

**SELECT * FROM species WHERE genus not like 'Pe%'**

<div class="keypoints" markdown="1">
</div>
#### Key Points

*   Use `where` to filter records according to Boolean conditions.
*   Filtering is done on whole records,
    so conditions can use fields that are not actually displayed.
