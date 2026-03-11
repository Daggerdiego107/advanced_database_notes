### Window Functions and Subqueries Challenge

#### FREESQL CHALLENGE
##### PARTITION BY 
* Complete the following query to return the count and average weight of bricks for each shape:

    ```sql
    select b.*,
        count(*) over (
            partition by shape
        ) bricks_per_shape,
        median ( weight ) over (
            partition by weight
        ) median_weight_per_shape
    from   bricks b
    order  by shape, weight, brick_id;
    ```

* Complete the following query to get the running average weight, ordered by brick_id:

    ```sql
    select b.brick_id, b.weight,
       round ( avg ( weight ) over (
         order by brick_id
       ), 2 ) running_average_weight
    from   bricks b
    order  by brick_id;
    ```

* Complete the windowing clauses to return:

    * The minimum colour of the two rows before (but not including) the current row

    * The count of rows with the same weight as the current and one value following

    ```sql
    select b.*,
       min ( colour ) over (
         order by brick_id
         rows between 1 preceding and current row
       ) first_colour_two_prev,
       count (*) over (
         order by weight
         range between current row and 1 following
       ) count_values_this_and_next
    from   bricks b
    order  by weight;
    ```

* Complete the following query to find the rows where

    * The total weight for the shape
    * The running weight by brick_id

    are both greater than four:

    ```sql
    with totals as (
        select b.*,
                sum ( weight ) over (
                partition by shape
                ) weight_per_shape,
                sum ( weight ) over (
                order by brick_id
                ) running_weight_by_id
        from   bricks b
        )
        select * from totals
        where  weight_per_shape > 4 and running_weight_by_id > 4
        order  by brick_id;
    ```

#### DATALEMUR CHALLENGE
* As part of an ongoing analysis of salary distribution within the company, your manager has requested a report identifying high earners in each department. A 'high earner' within a department is defined as an employee with a salary ranking among the top three salaries within that department.

* You're tasked with identifying these high earners across all departments. Write a query to display the employee's name along with their department name and salary. In case of duplicates, sort the results of department name in ascending order, then by salary in descending order. If multiple employees have the same salary, then order them alphabetically.

* Note: Ensure to utilize the appropriate ranking window function to handle duplicate salaries effectively.
    ```sql
    WITH SalaryRanks AS (
        SELECT 
            d.department_name,
            e.name,
            e.salary,
            DENSE_RANK() OVER (
                PARTITION BY e.department_id 
                ORDER BY e.salary DESC
            ) as salary_rank
        FROM employee e
        JOIN department d ON e.department_id = d.department_id
    )
    SELECT 
        department_name,
        name,
        salary
    FROM SalaryRanks
    WHERE salary_rank <= 3
    ORDER BY 
        department_name ASC, 
        salary DESC, 
        name ASC;
    ```

    
###### Line to merge this file