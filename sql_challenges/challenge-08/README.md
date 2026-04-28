### Indexes: Setup

#### Exercises to complete:

- Create the `patient_visits` table and load sample data (run once before the exercises).
- Gather stats for `patient_visits`.
- Verify row counts and basic distributions.

### Lesson 03: Indexes - Class Exercises

- Exercise 1: Find the slow query and inspect the execution plan.
- Exercise 2: Create an index on `visit_date`, then compare plans for ranges (30, 7, 700 days).
- Exercise 3: Create a composite index on `(patient_id, visit_date)` and test queries for both columns, only `patient_id`, and only `visit_date`.
- Exercise 4: Compare index usage with and without a function on `patient_id`.
- Exercise 5: Discuss indexing choices for the three scenarios.

#### Cleanup

- Drop any indexes created in the exercises.
