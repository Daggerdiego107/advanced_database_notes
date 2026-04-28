-- Check execution plan format
EXPLAIN PLAN FOR
SELECT * FROM patient_visits WHERE site_id = 3;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- Exercise 2: index on visit_date
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

-- Exercise 3: composite index
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

-- Exercise 4: function on indexed column
EXPLAIN PLAN FOR
SELECT * FROM patient_visits WHERE patient_id = 5432;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

EXPLAIN PLAN FOR
SELECT * FROM patient_visits WHERE TO_CHAR(patient_id) = '5432';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- Rewritten version that can use the index
SELECT * FROM patient_visits WHERE patient_id = 5432;

-- Cleanup
DROP INDEX idx_pv_patient_date;
DROP INDEX idx_pv_visit_date;