### LESSON 6: 
##### Multi-table queries with JOINs - Tasks:

* Find the domestic and international sales for each movie
    ```sql
    SELECT movies.Title, boxoffice.domestic_sales, boxoffice.international_sales 
    FROM movies 
    INNER JOIN boxoffice 
    ON movies.id = boxoffice.movie_id;
    ```

* Show the sales numbers for each movie that did better internationally rather than domestically
    ```sql
    SELECT movies.Title, boxoffice.domestic_sales, boxoffice.international_sales 
    FROM movies as m
    INNER JOIN boxoffice as b
    ON m.id = b.movie_id 
    WHERE b.international_sales > b.domestic_sales;
    ```

* List all the movies by their ratings in descending order
    ```sql
    SELECT m.Title, b.rating 
    FROM movies AS m 
    INNER JOIN boxoffice AS b 
    ON m.id = b.movie_id 
    ORDER BY b.rating DESC;
    ```

### LESSON 7: 
##### OUTER JOINS - Tasks:

* Find the list of all the buildings that have employees
    ```sql
    SELECT DISTINCT(b.building_name) AS b_n
    FROM employees AS e
    LEFT JOIN buildings AS b
    ON b_n = e.building;
    ```
* List all the employees and the building they work in, including those that do not have an assigned building
    ```sql
    SELECT DISTINCT(b.building_name) AS b_n, b.capacity
    FROM buildings AS b
    LEFT JOIN employees AS e
    ON b_n = e.building;
    ```
* Find the list of all buildings and their capacity
    ```sql
    SELECT * FROM buildings;
    ```
* List all buildings and the distinct employee roles in each building (including empty buildings)
    ```sql
    SELECT b.building_name, e.role
    FROM buildings b
    LEFT JOIN employees e
    ON b.building_name = e.building
    GROUP BY b.building_name, e.role;
    ```

### INTERVIEW CHALLENGE:
#### Page with no likes
* Assume you're given two tables containing data about Facebook Pages and their respective likes (as in "Like a Facebook Page").

    Write a query to return the IDs of the Facebook pages that have zero likes. The output should be sorted in ascending order based on the page IDs.
    ```sql
    SELECT p.page_id 
    FROM pages p
    LEFT JOIN page_likes pl
    ON p.page_id = pl.page_id
    WHERE pl.page_id IS NULL;
    ```