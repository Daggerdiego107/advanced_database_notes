### LESSON 10:
#### QUERIES WITH AGGREGATES (Pt. 1):
* Find the longest time that an employee has been at the studio
    ##### SOLUTION:
    ```sql
    SELECT MAX(years_employed) FROM employees;
    ```

* For each role, find the average number of years employed by employees in that role
    ##### SOLUTION:
    ```sql
    SELECT AVG(years_employed), role
    FROM employees
    GROUP BY role;
    ```

* Find the total number of employee years worked in each building
    ##### SOLUTION:
    ```sql
    SELECT building, SUM(years_employed) 
    FROM employees
    GROUP BY building;
    ```

### LESSON 11:
#### QUERIES WITH AGGREGATES (Pt. 2):
* Find the number of Artists in the studio (without a HAVING clause)
    ##### SOLUTION:
    ```sql
    SELECT Count(role)
    FROM employees
    where role = 'Artist';
    ```

* Find the number of Employees of each role in the studio
    ##### SOLUTION:
    ```sql
    SELECT role, Count(role)
    FROM employees
    GROUP By role;
    ```

* Find the total number of years employed by all Engineers
    ##### SOLUTION:
    ```sql
    SELECT role, Sum(Years_employed)
    FROM employees
    Where role = 'Engineer';
    ```

### FREESQL: 
#### Aggregating Rows: Databases for Developers
* Complete the following query to return the:

    * Number of different shapes
    * The standard deviation (stddev) of the unique weights
    ##### SOLUTION:
    ```sql
    SELECT COUNT(DISTINCT shape) number_of_shapes,
        STDDEV(UNIQUE WEIGHT) distinct_weight_stddev
    FROM bricks;
    ```

* Complete the following query to return the total weight for each shape stored in the bricks table:
    ##### SOLUTION:
    ```sql
    SELECT shape, SUM(WEIGHT) shape_weight
    FROM bricks
    GROUP BY shape;
    ```

* Complete the following query to find the shapes which have a total weight less than four:
    ##### SOLUTION:
    ```sql
    SELECT shape, SUM(WEIGHT) AS sw
    FROM bricks
    GROUP BY shape
    HAVING sw < 4;
    ```