-- TASK 6 MULTI-TABLE QUERIES WITH JOINS

-- Find the domestic and international sales for each movie
SELECT movies.Title, boxoffice.domestic_sales, boxoffice.international_sales 
FROM movies 
INNER JOIN boxoffice 
ON movies.id = boxoffice.movie_id;

-- Show the sales numbers for each movie that did better internationally rather than domestically
SELECT movies.Title, boxoffice.domestic_sales, boxoffice.international_sales 
FROM movies 
INNER JOIN boxoffice 
ON movies.id = boxoffice.movie_id 
WHERE boxoffice.international_sales > boxoffice.domestic_sales;

-- List all the movies by their ratings in descending order
SELECT m.Title, b.rating 
FROM movies AS m 
INNER JOIN boxoffice AS b 
ON m.id = b.movie_id 
ORDER BY b.rating DESC;


-- TASK 7 OUTER JOINS

-- Find the list of all the buildings that have employees

SELECT DISTINCT(b.building_name) AS b_n
FROM employees AS e
LEFT JOIN buildings AS b
ON b_n = e.building;

-- Find the list of all the buildings and their capaity
SELECT * FROM buildings

-- List all buildings and the distinct employee roles in each building (including empty buildings)
SELECT b.building_name, e.role
FROM buildings b
LEFT JOIN employees e
ON b.building_name = e.building
GROUP BY b.building_name, e.role;


-- INTERVIEW QUESTION
-- Assume you're given two tables containing data about Facebook Pages and their respective likes (as in "Like a Facebook Page").

-- Write a query to return the IDs of the Facebook pages that have zero likes. The output should be sorted in ascending order based on the page IDs.

SELECT p.page_id 
FROM pages p
LEFT JOIN page_likes pl
ON p.page_id = pl.page_id
WHERE pl.page_id IS NULL;