-- FREESQL

-- PARTITION BY
select b.*,
       count(*) over (
         partition by shape
       ) bricks_per_shape,
       median ( weight ) over (
         partition by weight
       ) median_weight_per_shape
from   bricks b
order  by shape, weight, brick_id;

-- ORDER BY
select b.brick_id, b.weight,
       round ( avg ( weight ) over (
         order by brick_id
       ), 2 ) running_average_weight
    from   bricks b
    order  by brick_id;

-- ROWS BETWEEN AND RANGE

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

-- ANALYTIC FUNCTIONS
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

-- DATALEMUR TOP 3 SALARIES

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

-- LINE TO MERGE SOLUTION