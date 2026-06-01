### Lesson 08: Exercise — Assignment History

#### Step 1 — Source Tables (OLTP)

- Create `tickets` and `ticket_assignments`.
	#### SOLUTION:
	```sql
	BEGIN EXECUTE IMMEDIATE 'DROP TABLE ticket_assignments'; EXCEPTION WHEN OTHERS THEN NULL; END;
	/
	BEGIN EXECUTE IMMEDIATE 'DROP TABLE tickets'; EXCEPTION WHEN OTHERS THEN NULL; END;
	/

	CREATE TABLE tickets (
		ticket_id    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
		title        VARCHAR2(200) NOT NULL,
		status       VARCHAR2(20)  DEFAULT 'open' NOT NULL,
		priority     VARCHAR2(10)  DEFAULT 'medium' NOT NULL,
		created_at   TIMESTAMP     DEFAULT SYSTIMESTAMP,
		resolved_at  TIMESTAMP,
		assigned_to  NUMBER
	);

	CREATE TABLE ticket_assignments (
		assignment_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
		ticket_id     NUMBER      NOT NULL REFERENCES tickets(ticket_id),
		assigned_to   NUMBER      NOT NULL,
		assigned_by   NUMBER,
		valid_from    TIMESTAMP   NOT NULL,
		valid_to      TIMESTAMP
	);
	```

#### Step 2 — Sample Data

- Insert at least 5 tickets and a reassignment history row.
	#### SOLUTION:
	```sql
	INSERT INTO tickets (title, status, priority, created_at, assigned_to)
	VALUES ('Login error on mobile', 'open', 'high', TIMESTAMP '2026-05-01 09:00:00', 101);

	INSERT INTO tickets (title, status, priority, created_at, assigned_to)
	VALUES ('Export CSV timeout', 'in_progress', 'medium', TIMESTAMP '2026-05-02 10:00:00', 102);

	INSERT INTO tickets (title, status, priority, created_at, assigned_to)
	VALUES ('Broken password reset link', 'open', 'critical', TIMESTAMP '2026-05-03 11:00:00', 103);

	INSERT INTO tickets (title, status, priority, created_at, assigned_to)
	VALUES ('Incorrect invoice totals', 'open', 'high', TIMESTAMP '2026-05-04 12:00:00', 104);

	INSERT INTO tickets (title, status, priority, created_at, assigned_to)
	VALUES ('UI flicker on dashboard', 'open', 'low', TIMESTAMP '2026-05-05 13:00:00', 105);

	COMMIT;

	INSERT INTO ticket_assignments (ticket_id, assigned_to, assigned_by, valid_from, valid_to)
	VALUES (3, 103, NULL, TIMESTAMP '2026-05-03 11:00:00', TIMESTAMP '2026-05-04 09:00:00');

	INSERT INTO ticket_assignments (ticket_id, assigned_to, assigned_by, valid_from, valid_to)
	VALUES (3, 106, NULL, TIMESTAMP '2026-05-04 09:00:00', NULL);

	COMMIT;
	```

#### Step 3 — Trigger

- Log assignment changes into `ticket_assignments`.
	#### SOLUTION:
	```sql
	CREATE OR REPLACE TRIGGER trg_ticket_assignment_log
		AFTER INSERT OR UPDATE OF assigned_to ON tickets
		FOR EACH ROW
	BEGIN
		IF INSERTING THEN
			INSERT INTO ticket_assignments (ticket_id, assigned_to, assigned_by, valid_from)
			VALUES (:NEW.ticket_id, :NEW.assigned_to, NULL, :NEW.created_at);
		ELSIF UPDATING THEN
			UPDATE ticket_assignments
			   SET valid_to = SYSTIMESTAMP
			 WHERE ticket_id = :OLD.ticket_id
			   AND valid_to IS NULL;

			INSERT INTO ticket_assignments (ticket_id, assigned_to, assigned_by, valid_from)
			VALUES (:NEW.ticket_id, :NEW.assigned_to, NULL, SYSTIMESTAMP);
		END IF;
	END;
	/
	```

#### Step 4 — Data Warehouse Tables (Star Schema)

- Create `dim_agent` and `fact_ticket_daily`.
	#### SOLUTION:
	```sql
	BEGIN EXECUTE IMMEDIATE 'DROP TABLE fact_ticket_daily'; EXCEPTION WHEN OTHERS THEN NULL; END;
	/
	BEGIN EXECUTE IMMEDIATE 'DROP TABLE dim_agent'; EXCEPTION WHEN OTHERS THEN NULL; END;
	/

	CREATE TABLE dim_agent (
		agent_key   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
		agent_name  VARCHAR2(100) NOT NULL,
		team        VARCHAR2(50)  NOT NULL
	);

	CREATE TABLE fact_ticket_daily (
		date_key         NUMBER      NOT NULL,
		agent_key        NUMBER      NOT NULL REFERENCES dim_agent(agent_key),
		status           VARCHAR2(20) NOT NULL,
		priority         VARCHAR2(10) NOT NULL,
		tickets_created  NUMBER      DEFAULT 0,
		tickets_resolved NUMBER      DEFAULT 0,
		CONSTRAINT uq_fact_ticket_daily UNIQUE (date_key, agent_key, status, priority)
	);
	```

#### Step 5 — Populate dim_agent

- Insert agents and teams.
	#### SOLUTION:
	```sql
	INSERT INTO dim_agent (agent_name, team) VALUES ('Ava Brooks', 'Support');
	INSERT INTO dim_agent (agent_name, team) VALUES ('Liam Ortiz', 'Support');
	INSERT INTO dim_agent (agent_name, team) VALUES ('Mia Patel', 'Escalations');
	INSERT INTO dim_agent (agent_name, team) VALUES ('Noah Kim', 'Escalations');
	COMMIT;
	```

#### Step 6 — ETL Logic (Colab)

- Use pandas to extract, resolve historical assignees at `created_at` and `resolved_at`,
  aggregate by date/agent/status/priority, and load `fact_ticket_daily`.

#### Step 7 — Verify

- Join fact and dimension to show daily created/resolved counts.
	#### SOLUTION:
	```sql
	SELECT d.agent_name,
	       f.date_key,
	       f.status,
	       f.priority,
	       f.tickets_created,
	       f.tickets_resolved
	FROM   fact_ticket_daily f
	JOIN   dim_agent d ON d.agent_key = f.agent_key
	ORDER  BY f.date_key, d.agent_name, f.status, f.priority;
	```
