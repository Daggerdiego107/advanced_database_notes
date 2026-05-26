-- Lesson 08: Exercise — Assignment History

-- Step 1: Source Tables (OLTP)
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

-- Step 2: Sample Data
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

-- Step 3: Trigger to log assignment history
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

-- Reassign a ticket to test the trigger
UPDATE tickets
SET assigned_to = 106
WHERE ticket_id = 3;

COMMIT;

-- Verify assignment history
SELECT ta.ticket_id,
	   ta.assigned_to,
	   ta.valid_from,
	   ta.valid_to
FROM   ticket_assignments ta
WHERE  ta.ticket_id = 3
ORDER  BY ta.valid_from;
