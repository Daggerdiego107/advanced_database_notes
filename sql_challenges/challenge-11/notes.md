### Lesson 03: SQLAlchemy ORM + Alembic Migrations

#### Step 0 — Setup Schema (FreeSQL)

- Run the base schema and seed data in FreeSQL.
	#### SOLUTION:
	```sql
	BEGIN EXECUTE IMMEDIATE 'DROP TABLE tasks PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
	/
	BEGIN EXECUTE IMMEDIATE 'DROP TABLE users PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
	/
	BEGIN EXECUTE IMMEDIATE 'DROP TABLE teams PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
	/

	CREATE TABLE teams (
		id          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
		name        VARCHAR2(50)  NOT NULL UNIQUE,
		description VARCHAR2(200),
		created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
	);

	CREATE TABLE users (
		id          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
		username    VARCHAR2(50)  NOT NULL UNIQUE,
		email       VARCHAR2(100) NOT NULL,
		full_name   VARCHAR2(100),
		team_id     NUMBER,
		created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
		CONSTRAINT fk_users_team
			FOREIGN KEY (team_id) REFERENCES teams(id)
	);

	CREATE TABLE tasks (
		id           NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
		title        VARCHAR2(200) NOT NULL,
		description  VARCHAR2(1000),
		status       VARCHAR2(20)  DEFAULT 'open',
		assigned_to  NUMBER,
		created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
		updated_at   TIMESTAMP,
		CONSTRAINT fk_tasks_user
			FOREIGN KEY (assigned_to) REFERENCES users(id)
	);

	INSERT INTO teams (name, description) VALUES ('Engineering', 'Software development team');
	INSERT INTO teams (name, description) VALUES ('Product', 'Product management team');

	INSERT INTO users (username, email, full_name, team_id)
		VALUES ('alice_dev', 'alice@example.com', 'Alice Smith', 1);
	INSERT INTO users (username, email, full_name, team_id)
		VALUES ('bob_dev', 'bob@example.com', 'Bob Jones', 1);
	INSERT INTO users (username, email, full_name, team_id)
		VALUES ('carol_pm', 'carol@example.com', 'Carol White', 2);

	INSERT INTO tasks (title, description, status, assigned_to)
		VALUES ('Fix login bug', 'Users cannot log in with SSO', 'open', 1);
	INSERT INTO tasks (title, description, status, assigned_to)
		VALUES ('Design new dashboard', 'Create mockups for analytics page', 'in_progress', 3);
	INSERT INTO tasks (title, description, status, assigned_to)
		VALUES ('Update dependencies', 'Upgrade numpy and pandas', 'open', 2);

	COMMIT;
	```

#### Exercise 1 — Model Design

- Add a `Comment` ORM model with required fields and relationships.
	#### SOLUTION:
	```python
	class Comment(Base):
		__tablename__ = "comments"
		id         = Column(Integer, primary_key=True)
		task_id    = Column(Integer, ForeignKey("tasks.id", ondelete="CASCADE"), nullable=False)
		user_id    = Column(Integer, ForeignKey("users.id"), nullable=False)
		content    = Column(Text, nullable=False)
		created_at = Column(DateTime, server_default=func.current_timestamp())

		task = relationship("Task", back_populates="comments")
		author = relationship("User", back_populates="comments")

	# Add relationships on Task and User
	Task.comments = relationship("Comment", back_populates="task", cascade="all, delete-orphan")
	User.comments = relationship("Comment", back_populates="author")
	```
	Questions:
	1. `Comment` should relate to `Task` (many comments per task) and `User` (many comments per user).
	2. `Task` should have `comments` for easy navigation.
	3. Use `ondelete="CASCADE"` and `cascade="all, delete-orphan"` to remove comments with a task.

#### Exercise 2 — Migration Creation

- Autogenerate and inspect a migration for the `comments` table.
	#### SOLUTION:
	```python
	command.revision(
		alembic_cfg,
		autogenerate=True,
		message="add comments table"
	)

	import glob
	migration_files = sorted(
		glob.glob('/content/project/alembic/versions/*.py')
	)

	for f in migration_files:
		print(f)

	latest = migration_files[-1]
	with open(latest) as f:
		print(f.read())
	```
	Questions:
	1. `upgrade()` applies schema changes (creates `comments`).
	2. `downgrade()` reverts changes (drops `comments`).
	3. Downgrading removes the table and data in it.

#### Exercise 3 — CRUD Challenge

- Use ORM-only CRUD to create a team, user, tasks, update, and delete.
	#### SOLUTION:
	```python
	with Session(engine) as session:
		team = Team(name="DevOps", description="Infrastructure and reliability")
		user = User(username="diana_ops", email="diana@example.com", full_name="Diana Ops", team=team)
		
		task1 = Task(title="Set up monitoring", description="Add alerts", status="open", assignee=user)
		task2 = Task(title="Rotate secrets", description="Update secrets", status="open", assignee=user)
		task3 = Task(title="Patch servers", description="Monthly patch", status="open", assignee=user)

		session.add_all([team, user, task1, task2, task3])
		session.commit()

		count = session.query(Task).filter(Task.assignee == user).count()
		print(f"Task count: {count}")

		# Close one task
		task1.status = "completed"
		session.commit()

		# Delete lowest priority task (example: delete by title)
		lowest = session.query(Task).filter(Task.title == "Patch servers").one()
		session.delete(lowest)
		session.commit()
	```

#### Exercise 4 — Migration Rollback

- Roll back the last migration and note what happens.
	#### SOLUTION:
	```python
	command.downgrade(alembic_cfg, "-1")
	```
	Questions:
	1. The column/table from the last migration is removed.
	2. Any data in that column/table is lost after rollback.

#### Exercise 5 — Concept Check

- Answer the conceptual questions briefly.
	#### SOLUTION:
	1. ORM vs raw SQL: ORM gives safer, reusable models, relationships, and DB-agnostic queries; raw SQL is more manual and error-prone for complex apps.
	2. Migrations: They track schema changes over time and keep environments consistent.
	3. Rollback: Use it when a migration introduces a bug or invalid schema change.
	4. `add()` vs `commit()`: `add()` stages objects in the session; `commit()` writes changes to the DB.
	5. Relationships: They simplify joins and navigation between related rows in code.
