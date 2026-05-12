### Lesson 03: SQLAlchemy ORM Models + Alembic Migrations

#### Step 1: Install dependencies

```bash
!pip install sqlalchemy oracledb -q
```

#### Step 2: Define ORM models

```python
from sqlalchemy import (
	create_engine, Column, Integer, String,
	Text, ForeignKey, DateTime, func
)
from sqlalchemy.orm import declarative_base, relationship, Session

Base = declarative_base()

class Team(Base):
	__tablename__ = "teams"
	id          = Column(Integer, primary_key=True)
	name        = Column(String(50), nullable=False, unique=True)
	description = Column(String(200))
	created_at  = Column(DateTime, server_default=func.current_timestamp())
	users = relationship("User", back_populates="team")
	priority = Column(String(20), default="medium")
	due_date = Column(DateTime)
	tags = Column(String(500))

class User(Base):
	__tablename__ = "users"
	id         = Column(Integer, primary_key=True)
	username   = Column(String(50), nullable=False, unique=True)
	email      = Column(String(100), nullable=False)
	full_name  = Column(String(100))
	team_id    = Column(Integer, ForeignKey("teams.id"))
	created_at = Column(DateTime, server_default=func.current_timestamp())
	team  = relationship("Team", back_populates="users")
	tasks = relationship("Task", back_populates="assignee")

class Task(Base):
	__tablename__ = "tasks"
	id           = Column(Integer, primary_key=True)
	title        = Column(String(200), nullable=False)
	description  = Column(String(1000))
	status       = Column(String(20), default="open")
	assigned_to  = Column(Integer, ForeignKey("users.id"))
	created_at   = Column(DateTime, server_default=func.current_timestamp())
	updated_at   = Column(DateTime, onupdate=func.current_timestamp())
	assignee = relationship("User", back_populates="tasks")
```

#### Step 3: Connect and query

```python
USERNAME = ""
PASSWORD = ""
DSN = "tcps://db.freesql.com:2484/23ai_34ui2"

engine = create_engine(
	"oracle+oracledb://:@",
	connect_args={
		"user": USERNAME,
		"password": PASSWORD,
		"dsn": DSN,
	},
)

with Session(engine) as session:
	for team in session.query(Team).all():
		for user in team.users:
			pass

	for task in session.query(Task).all():
		assignee = task.assignee.full_name if task.assignee else "Unassigned"
```

#### Alembic migrations (pure Python)

```bash
!pip install sqlalchemy oracledb alembic -q
```

```python
from alembic.config import Config
from alembic import command

alembic_cfg = Config()
alembic_cfg.set_main_option("script_location", "/content/alembic")
alembic_cfg.set_main_option("sqlalchemy.url", "oracle+oracledb://:@")

command.revision(alembic_cfg, autogenerate=True, message="Initial schema")
command.upgrade(alembic_cfg, "head")
command.downgrade(alembic_cfg, "-1")
```
