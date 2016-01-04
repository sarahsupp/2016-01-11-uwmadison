---
layout: lesson
root: ../..
---

## Sorting and Removing Duplicates


<div class="objectives" markdown="1">
#### Objectives
</div>

*   Write queries that display results in a particular order.
*   Write queries that eliminate duplicate values from data.
</div>

### Unique Values
Data is often redundant,
so queries often return redundant information.
For example,
if we select the species that have been measured
from the `surveys` table,
we get a whole lot of repeated values:


<pre class="in"><code>SELECT species_id FROM surveys;</code></pre>

We can eliminate the redundant output
to make the result more readable (and useful)
by adding the `distinct` keyword
to our query:

<pre class="in"><code>SELECT distinct species_id FROM surveys;</code></pre>

<div class="out"><table>
<tr><td>DM</td></tr>
<tr><td>DO</td></tr>
<tr><td>DS</td></tr>
<tr><td>PB</td></tr>
<tr><td>PP</td></tr>
<tr><td>PE</td></tr>
<tr><td>...</td></tr>
</table></div>

If we select more than one column&mdash;for example,
both the survey site ID and the quantity measured&mdash;then
the distinct pairs of values are returned:

<pre class="in"><code>SELECT distinct year, species_id FROM surveys;</code></pre>

Notice in both cases that duplicates are removed
even if they didn't appear to be adjacent in the database.
Again,
it's important to remember that rows aren't actually ordered:
they're just displayed that way.


#### Challenges

1.  How many days did researchers take measurements at the Portal site? 
2.  write a query that selects the unique dates from the `surveys` table.


### Sorting
As we mentioned earlier,
database records are not stored in any particular order.
This means that query results aren't necessarily sorted,
and even if they are,
we often want to sort them in a different way,
e.g., by the species captured or the size of the individual, rather than the the year or date of the survey.
We can do this in SQL by adding an `order by` clause to our query:

Let's take the query from the example we just did of species by year and sort by the species_id: 

<pre class="in"><code>SELECT distinct year, species_id FROM surveys ORDER BY species_id;</code></pre>

By default,
results are sorted in ascending order
(i.e.,
from least to greatest).
We can sort in the opposite order using `desc` (for "descending"):\

<pre class="in"><code>SELECT distinct year, species_id FROM surveys ORDER BY species_id desc;</code></pre>

(And if we want to make it clear that we're sorting in ascending order,
we can use `asc` instead of `desc`.)
  
We can also sort on several fields at once.
For example,
this query sorts results first in ascending order by `species`,
and then in descending order by `year`
within each group of equal `species` values:

<pre class="in"><code>SELECT year, species_id FROM surveys ORDER BY species_id ASC, year DESC;</code></pre>

This is easier to understand if we also remove duplicates:

<pre class="in"><code>SELECT DISTINCT year, species_id FROM surveys ORDER BY species_id ASC, year DESC;</code></pre>


#### Challenges

   1.  Write a query that returns the year, species, and weight from the surveys table, sorted with the largest weights at the top.

**After 1 minute, ask Students to compare with a partner. Pick 2 people to share thier answers with the class**

### Calculated values
We can also do calculations on the values in a query. For example, if we wanted to look at the mass of each individual on different dates, but we needed to report it to Arizona Fish and Game in kg instead of g, we would use:

<pre class="in"><code>SELECT year, month, day, species_id, weight/1000.0 FROM surveys;</code></pre>

When we run the query, the expression `weight/1000.0` is evaluated for each row adn appended to that row, in a new column. Expressions can use any fields, any arithmetic operators (+ - * /) and a variety of built-in functions (). For example, we could round the values to make them easier to read.

<pre class="in"><code>SELECT year, month, day, species_id, weight, ROUND(weight/1000.0, 2) FROM surveys;</code></pre>

#### Challenges
   1. Write a query that returns the year, month, day, plot_id, species_id, and weight in mg, sorted by plot_id.



<div class="keypoints" markdown="1">
#### Key Points
</div>

*   The records in a database table are not intrinsically ordered:
    if we want to display them in some order,
    we must specify that explicitly.
*   The values in a database are not guaranteed to be unique:
    if we want to eliminate duplicates,
    we must specify that explicitly as well.
*   The values in a database can be manipulated using basic arthimetic operators or built-in functions
*   As we build more complex queries, it is often a good idea to save that query for future use or reference.
