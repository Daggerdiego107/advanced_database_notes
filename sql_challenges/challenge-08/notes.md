### Indexes: Setup

- Create the `patient_visits` table and load sample data (run once before the exercises).
    #### SOLUTION:
    ```sql
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE patient_visits';
    EXCEPTION
        WHEN OTHERS THEN NULL;
    END;
    /

    CREATE TABLE patient_visits (
        visit_id     NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        patient_id   NUMBER         NOT NULL,
        site_id      NUMBER         NOT NULL,
        visit_date   DATE           NOT NULL,
        status       VARCHAR2(20)   NOT NULL,
        diagnosis    VARCHAR2(100),
        amount_usd   NUMBER(10,2)
    );

    INSERT INTO patient_visits (patient_id, site_id, visit_date, status, diagnosis, amount_usd)
    SELECT
        TRUNC(DBMS_RANDOM.VALUE(1, 10001))           AS patient_id,
        TRUNC(DBMS_RANDOM.VALUE(1, 6))               AS site_id,
        SYSDATE - TRUNC(DBMS_RANDOM.VALUE(0, 730))  AS visit_date,
        CASE TRUNC(DBMS_RANDOM.VALUE(1, 4))
            WHEN 1 THEN 'scheduled'
            WHEN 2 THEN 'completed'
            ELSE        'cancelled'
        END                                          AS status,
        CASE TRUNC(DBMS_RANDOM.VALUE(1, 6))
            WHEN 1 THEN 'Hypertension'
            WHEN 2 THEN 'Diabetes'
            WHEN 3 THEN 'Routine checkup'
            WHEN 4 THEN 'Fracture'
            ELSE        'Respiratory infection'
        END                                          AS diagnosis,
        ROUND(DBMS_RANDOM.VALUE(50, 500), 2)         AS amount_usd
    FROM dual
    CONNECT BY LEVEL <= 50000;

    COMMIT;
    ```

- Gather stats for `patient_visits`.
    #### SOLUTION:
    ```sql
    BEGIN
        DBMS_STATS.GATHER_TABLE_STATS(
            ownname => USER,
            tabname => 'PATIENT_VISITS',
            cascade => TRUE
        );
    END;
    /
    ```

- Verify row counts and basic distributions.
    #### SOLUTION:
    ```sql
    SELECT COUNT(*) AS total_rows FROM patient_visits;
    SELECT status, COUNT(*) AS cnt FROM patient_visits GROUP BY status ORDER BY status;
    SELECT MIN(patient_id), MAX(patient_id), COUNT(DISTINCT patient_id) AS unique_patients
    FROM patient_visits;
    ```

### Lesson 03: Indexes - Class Exercises

- Exercise 1: Find the slow query and inspect the execution plan.
    #### SOLUTION:
    ```sql
    EXPLAIN PLAN FOR
    SELECT * FROM patient_visits WHERE site_id = 3;

    SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
    ```

- Exercise 2: Create an index on `visit_date`, then compare plans for ranges (30, 7, 700 days).
    #### SOLUTION:
    ```sql
    CREATE INDEX idx_pv_visit_date ON patient_visits(visit_date);

    BEGIN
        DBMS_STATS.GATHER_TABLE_STATS(USER, 'PATIENT_VISITS', cascade => TRUE);
    END;
    /

    EXPLAIN PLAN FOR
    SELECT * FROM patient_visits
    WHERE visit_date BETWEEN SYSDATE - 30 AND SYSDATE;

    SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

    EXPLAIN PLAN FOR
    SELECT * FROM patient_visits
    WHERE visit_date BETWEEN SYSDATE - 7 AND SYSDATE;

    SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

    EXPLAIN PLAN FOR
    SELECT * FROM patient_visits
    WHERE visit_date BETWEEN SYSDATE - 700 AND SYSDATE;

    SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
    ```

- Exercise 3: Create a composite index on `(patient_id, visit_date)` and test queries for both columns, only `patient_id`, and only `visit_date`.
    #### SOLUTION:
    ```sql
    CREATE INDEX idx_pv_patient_date ON patient_visits(patient_id, visit_date);

    BEGIN
        DBMS_STATS.GATHER_TABLE_STATS(USER, 'PATIENT_VISITS', cascade => TRUE);
    END;
    /

    EXPLAIN PLAN FOR
    SELECT * FROM patient_visits
    WHERE patient_id = 1234
      AND visit_date > SYSDATE - 90;

    SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

    EXPLAIN PLAN FOR
    SELECT * FROM patient_visits
    WHERE patient_id = 1234;

    SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

    EXPLAIN PLAN FOR
    SELECT * FROM patient_visits
    WHERE visit_date > SYSDATE - 90;

    SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
    ```

- Exercise 4: Compare index usage with and without a function on `patient_id`.
    #### SOLUTION:
    ```sql
    EXPLAIN PLAN FOR
    SELECT * FROM patient_visits WHERE patient_id = 5432;

    SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

    EXPLAIN PLAN FOR
    SELECT * FROM patient_visits WHERE TO_CHAR(patient_id) = '5432';

    SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

    SELECT * FROM patient_visits WHERE patient_id = 5432;
    ```

- Exercise 5: Discuss indexing choices for the three scenarios.
    #### SOLUTION:
    - Scenario A: Add a B-tree index on the date column for range queries; batch loads can tolerate the write cost.
    - Scenario B: Index `customer_id`; consider a composite index `(customer_id, order_status)` if filters are combined; avoid indexing `order_status` alone due to low cardinality and heavy inserts.
    - Scenario C: Create a unique index on `email` for fast lookups and uniqueness enforcement.

#### Cleanup

- Drop any indexes created in the exercises.
    ```sql
    DROP INDEX idx_pv_patient_date;
    DROP INDEX idx_pv_visit_date;
    ```
