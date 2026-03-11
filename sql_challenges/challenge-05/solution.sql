-- Complete this query to return a list of all the colours in the two tables. Each colour must only appear once:

SELECT colour FROM my_brick_collection
UNION
SELECT colour FROM your_brick_collection
ORDER BY colour;

-- Complete the following query to return a list of all the shapes in both tables. There must show one row for each row in the source tables:

SELECT shape FROM my_brick_collection
UNION ALL
SELECT shape FROM your_brick_collection
ORDER BY shape;

-- Complete the following query to return a list of all the shapes in my collection not in yours:

SELECT shape FROM my_brick_collection
MINUS
SELECT shape FROM your_brick_collection;

-- Complete the following query to return a list of all the colours that are in both tables:

SELECT colour FROM my_brick_collection
INTERSECT
SELECT colour FROM your_brick_collection
ORDER BY colour;