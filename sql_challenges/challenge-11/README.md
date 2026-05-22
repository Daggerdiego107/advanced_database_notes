### Lesson 03: SQLAlchemy ORM Models + Alembic Migrations

#### Step 1: Install dependencies

- Install SQLAlchemy and the Oracle driver.

#### Step 2: Define ORM models

- Create `Team`, `User`, and `Task` with relationships.
- Add the new `Team` columns (`priority`, `due_date`, `tags`).

#### Step 3: Connect and query with ORM

- Configure FreeSQL credentials.
- Query teams, users, and tasks via relationships.

#### Step 4: Alembic migrations (pure Python)

- Install Alembic.
- Initialize the Alembic config and `env.py`.
- Autogenerate a revision and inspect it.
- Apply and then roll back one migration.
- Clean up generated migration files.
