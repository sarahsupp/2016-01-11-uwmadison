---
layout: lesson
root: ../..
---

## Aggregation


<div class="objectives" markdown="1">
#### Objectives
</div>

*   Define "aggregation" and give examples of its use.
*   Write queries that compute aggregated values.
*   Trace the execution of a query that performs aggregation.
*   Explain how missing data is handled during aggregation.

Aggregation allows us to combine results by grouping records based on value and calculating combined values in groups. We know how to select all of the data from a column, but to combine them, we must use an aggregation function. Each of these functions takes a set of records as input, and produces a single record as output. 
**If it helps, draw on board to explain what the computer is doing here**

###COUNT and GROUP BY
Let's go to the surveys table and find out how many individuals there are. Using the wildcard (*) simply counts the number of records (rows).

<pre class="in"><code>SELECT COUNT(*) FROM surveys;</code></pre>

We can also find out how much those individuals weigh, all together:

<pre class="in"><code>SELECT COUNT(*), SUM(weight) FROM surveys;</code></pre>

We can output this value in kilograms, rounded to 3 decimal places:

<pre class="in"><code>SELECT ROUND(SUM(weight)/1000.0, 3) FROM surveys;</code></pre>

There are many other aggregate functions included in SQL including `MAX`, `MIN`, and `AVG`.

####Challenge
   
   Write a query that returns:
*  total weight
*  average weight
*  min weight
*  max weight

for all animals captured over the duration of the study. Can you modify it so that it outputs that for a range of weights?
   
**Now**, let's see how many individuals were counted in each species. We can do this using a GROUP BY clause:

<pre class="in"><code>SELECT species_id, COUNT(*) FROM surveys GROUP BY species_id;</code></pre>

GROUP BY tells SQL what field or fields we want to use to aggregate the data. You can see that this quickly becomes more powerful as we have more species, or dates, or whatever that we are interested in. In theory, we could write a small query to get the data for a single species, but as we expand to 10, 50, or 100s of species, this quickly would become tedious.

#### Using `AS` to rename aggregated columns
It's also getting difficult to read some of our aggregated column names after running our queries. We can fix this too using `AS`:

<pre class="in"><code>SELECT species_id, count(*) AS num_indivs, ROUND(AVG(weight),2) AS avg_weight
FROM surveys
WHERE year=2007
GROUP BY species_id;</code></pre>

Just as we can sort by multiple criteria at once, we can also group by multiple criteria. To get the average weight by species and year measured, for example, we just add another field to the `GROUP BY` clause:  If we want to group by multiple fields, we give GROUP BY a comma separated list. Note that we might also want to add this new GROUP BY field to the SELECT clause, if it's not already there - otherwise the results won't make much sense.

#### Challenge
Write queries that return:
   1. How many individuals were counted in each year: a) in total, b) per each species
   2. Average weight of each species in each year. 
   3. Can you modify the above queries, combining them into one?
  
**Select student(s) to volunteer their results, and then walk through each of the steps the database manager is taking one by one. Remind students that these kind of queries can be difficult to write all at once, but that building up to them slowly, it is much easier**
   
### Ordering aggregated results
We can order the results of our aggregation by a specific column, including the aggregated column. Let's count the number of individuals of each species captured, ordered by the count.

<pre class="in"><code>SELECT species_id, COUNT(*) FROM surveys GROUP BY species_id ORDER BY COUNT(species_id);</code></pre>

####Challenge
Write a query that returns the number of each species captured in each year, sorted from the most frequently captured species to the least, within each year starting from the most recent records .

**Remind students that SQL is a hierarchical language. If you reorder your arguments (e.g. swap GROUP BY and WHERE), the query doesn't execute. REVISIT COMMANDS LEARNED SO FAR ON THE BOARD and add WHERE, GROUP BY to it.**


###When Aggregate seems to go wrong...

#### 1. If you try to combine aggregated results with raw results:

<pre class="in"><code>SELECT species_id, count(*) FROM surveys WHERE (year=1998) AND (plot=1);</code></pre>

   **ASK CLASS: Why does SPECIES X appear rather than SPECIES Y OR SPECIES Z?**

The answer is that when the computer has to aggregate a field,
but isn't told how to,
the database manager chooses an actual value from the input set.
It might use the first one processed,
the last one,
or something else entirely. 
*So this isn't probably what we wanted. It is a good idea to always do a quick sanity check on your results. Sometimes getting an answer isn't proof that the program did what you intended!*

We can also combine aggregated results with raw results,
although the output might surprise you:

#### 2. What if there are no values to aggregate?

In this case, the aggregations result is "don't know" rather than zero or some other arbitrary value:

<pre class="in"><code>SELECT species_id, MAX(weight), sum(weight) FROM surveys WHERE quant='missing';</code></pre>
 
Here, the table would just show 3 columns that say "None".

#### 3. What if I try to aggregate values and one of them is NULL?

Aggregation function are inconsistent with the rest of SQL in a very useful way. 
Normally, if we add two values and one of them is null, the result is null.
By extension, if we use `sum` to add all the values in a set, and any of those values are null,
the result should also be null.

It's much more useful though, for aggregation functions to ignore null values and only combine those that are non-null.
This behavior lets us write our queries as:

<pre class="in"><code>SELECT MIN(weight) FROM surveys;</code></pre>

instead of needing to explicitly filter for NULL values:

<pre class="in"><code>SELECT MIN(weight) FROM surveys WHERE weight IS NOT NULL;</code></pre>

#### Challenges (Work in pairs)

1.  How many individuals of Neotoma albigula (pack rat) were captured,
    and what was their average weight?

2.  The average of a set of values is the sum of the values
    divided by the number of values.
    Does this mean that the `avg` function returns 2.0 or 3.0
    when given the values 1.0, `null`, and 5.0?
    
    **ANSWER: should return 3 becasue aggregate functions ignore NULL rows**

3.  We want to calculate the difference between
    each individual weight
    and the average of all the weights for Neotoma.
    We write the query:

    ~~~
    SELECT weight - avg(weight) FROM survey WHERE species_id='NA';
    ~~~

   **What does this actually produce, and why?**
    

<div class="keypoints" markdown="1">
#### Key Points
</div>
*   An aggregation function combines many values to produce a single new value.
*   Aggregation functions ignore `null` values.
*   Aggregation happens after filtering.
</div>
