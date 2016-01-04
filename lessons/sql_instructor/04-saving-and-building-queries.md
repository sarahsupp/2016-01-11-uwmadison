---
layout: lesson
root: ../..
---

## Saving and Exporting Queries


<div class="objectives" markdown="1">
#### Objectives
</div>
*   Keep track of queries as we go. Save and export queries for later use or reference

As we continue to work towards more complicated queries, we can see that it might be useful to be able to save a record of what we're doing so that we don't need to start over every time, or so that we can remember how we got to a certain answer. In your research, it may be necessary to re-run quereies through time, as new data is added. For example, the Portal Project is required to submit an annual report to Arizona Fish and Game on the number of individuals captured, species, sex, and any trap mortalities. Since the same report is submitted every year, it would be silly to rewrite the query every year. By having it saved, generating the report for the new data is as simple as updating the year, and hitting a button!

   * Exporting: **Actions** buton and choosing **Save result to file**.
   * Save: **View** drop down and **Create View**.

### Saving Queries
To enable saving queries from the main menu select **Tools** --> **Use Table for Extension Data**:

You will see an additional 4 icons - "Previous query from the history", "Next query from the history", "Save query by name", and "Clear query history". When you click the query, it will then be available under the list of queries ("Select a Query").

## Building more complex Queries

As you can see, we are already beginning to use the simple queries that we started with, to build up to more complex ones - like when we add sorting or calculations to a basic query. It is a good idea to start this way. If you know that each step works, then finding mistakes in a complex query become much easier than if you try to start out right away with a very long complicated SQL statement!

Let's combine some of the queries we've done so far to get data for the 3 *Dipodomys* species from the year 2000 and later. This tme, lets us IN as one way to make the query easier to understand. It is equivalent to saying 
`WHERE (species_id = 'DM') OR (species_id = 'DO') OR (species_id = 'DS')`, but reads more neatly:

<pre class="in"><code>SELECT * FROM surveys WHERE (year >= 2000) AND (species_id IN ('DM', 'DO', 'DS'));</code></pre>

<pre class="in"><code>SELECT * 
FROM surveys 
WHERE (year >= 2000) AND (species_id IN ('DM', 'DO', 'DS'));</code></pre>

We started with something simple, then added more clauses one by one, testing their effects as we went along. For complex queries, this is a good strategy, to make sure you are getting what you want. Sometimes it helps to take a subset of the data that you can easily see in a temporary database to practice your queries on before working on a larger or more complicated database 
(For example, the Portal database also includes tables for plant surveys, weather, non-target species, and geological coordinates, but we have chosen to use a subset of the data for the workshop!)

#### Challenge

   Write a query that returns year, species, and weight in kg from the surveys table, from the summer months (May - September; when rodents are the most active) sorted with the largest weights at the top.

## Order of execution
Another note for ordering: We don't actually have to display a column to sort by it. For example, let's say we want to order the birds by their species ID, but we only want to see genus and species:

<pre class="in"><code>SELECT genus, species FROM species WHERE taxa = 'Bird' ORDER BY species_id ASC;</code></pre>

We can do this because sorting occurs earlier in the computational pipeline than field selection. 

The computer is basically doing this:
   1. Filtering rows according to WHERE
   2. Sorting results according to ORDER BY
   3. Displaying requested columns or expressions

## Order of clauses
The order of clauses when we write a query is dictated by SQL: In other words, SQL is a hierarchical language, so **order matters**.
SELECT, FROM, WHERE, ORDER BY -- and we often write each of them on their own line for readability.

####Challenge
   Let's try to combine what we've learned so far in a single query. Using the surveys table, write a query to display the three field dates, species_id, and weight in kilograms (rounded to 2 decimal places), for individuals captured in 1999, ordered alphabetically by species_id.


<div class="keypoints" markdown="1">
#### Key Points
</div>
   *   It can be useful and helpful to save queries, especially as they become more complex
   *   It is a good strategy to slowly build up to complex queries, making sure each new clause is working correctly before building up.
   *   We can sort or filter queries by columns that are not displayed in the final output.
   *   Order matters in SQL and a query in the wrong order will return an error.
