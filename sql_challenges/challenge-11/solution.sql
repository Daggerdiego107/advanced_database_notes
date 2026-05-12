-- Lesson 03: SQLAlchemy ORM Models + Alembic Migrations

-- Schema equivalent to the ORM models
BEGIN
	EXECUTE IMMEDIATE 'DROP TABLE tasks PURGE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
	EXECUTE IMMEDIATE 'DROP TABLE users PURGE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
	EXECUTE IMMEDIATE 'DROP TABLE teams PURGE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE teams (
	id          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	name        VARCHAR2(50) NOT NULL UNIQUE,
	description VARCHAR2(200),
	created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	priority    VARCHAR2(20) DEFAULT 'medium',
	due_date    TIMESTAMP,
	tags        VARCHAR2(500)
);

CREATE TABLE users (
	id         NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	username   VARCHAR2(50) NOT NULL UNIQUE,
	email      VARCHAR2(100) NOT NULL,
	full_name  VARCHAR2(100),
	team_id    NUMBER,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT users_team_fk FOREIGN KEY (team_id) REFERENCES teams(id)
);

CREATE TABLE tasks (
	id          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	title       VARCHAR2(200) NOT NULL,
	description VARCHAR2(1000),
	status      VARCHAR2(20) DEFAULT 'open',
	assigned_to NUMBER,
	created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at  TIMESTAMP,
	CONSTRAINT tasks_user_fk FOREIGN KEY (assigned_to) REFERENCES users(id)
);

-- Example queries similar to the ORM traversal
SELECT t.id, t.name, u.full_name, u.username
FROM teams t
LEFT JOIN users u ON u.team_id = t.id
ORDER BY t.id, u.id;

SELECT task.title,
			 NVL(u.full_name, 'Unassigned') AS assignee
FROM tasks task
LEFT JOIN users u ON u.id = task.assigned_to
ORDER BY task.id;
