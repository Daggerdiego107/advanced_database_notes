### Lesson 05: Schema Backup and Restore

#### Exercise 1: Explore your schema

- List schema objects and counts by `object_type`.
	#### SOLUTION:
	```sql
	SELECT object_type, COUNT(*) AS cnt
	FROM user_objects
	GROUP BY object_type
	ORDER BY object_type;
	```

- List object details ordered by type and name.
	#### SOLUTION:
	```sql
	SELECT object_name, object_type, created, last_ddl_time
	FROM user_objects
	ORDER BY object_type, object_name;
	```

#### Exercise 2: Basic `DBMS_METADATA.GET_DDL`

- Configure transform parameters for clean DDL output.
	#### SOLUTION:
	```sql
	BEGIN
	  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'PRETTY', true);
	  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'SQLTERMINATOR', true);
	  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'SEGMENT_ATTRIBUTES', false);
	  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'STORAGE', false);
	  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'TABLESPACE', false);
	END;
	/
	```

- Extract DDL for one table and for all tables.
	#### SOLUTION:
	```sql
	SELECT DBMS_METADATA.GET_DDL('TABLE', 'MY_TABLE') FROM DUAL;

	SELECT DBMS_METADATA.GET_DDL('TABLE', table_name)
	FROM user_tables
	ORDER BY table_name;
	```

#### Exercise 3: Clean DDL for portability

- Disable schema emission in DDL output.
	#### SOLUTION:
	```sql
	BEGIN
	  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'EMIT_SCHEMA', false);
	  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'PRETTY', true);
	  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'SQLTERMINATOR', true);
	  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'SEGMENT_ATTRIBUTES', false);
	  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'STORAGE', false);
	  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'TABLESPACE', false);
	END;
	/
	```

- Compare output with and without schema names.
	#### SOLUTION:
	```sql
	SELECT DBMS_METADATA.GET_DDL('TABLE', table_name)
	FROM user_tables
	WHERE ROWNUM = 1;
	```

#### Exercise 4: Plan a migration

- Inspect DDL for schema-qualified references.
	#### SOLUTION:
	```sql
	SELECT DBMS_METADATA.GET_DDL('TABLE', table_name)
	FROM user_tables
	WHERE table_name = 'ANY_TABLE_WITH_FK';
	```

- Review FK constraints and build a checklist.
	#### SOLUTION:
	```sql
	SELECT constraint_name, table_name, r_constraint_name
	FROM user_constraints
	WHERE constraint_type = 'R';
	```

	Checklist:
	- Export all DDL with `EMIT_SCHEMA = false`.
	- Review FK constraints for schema references.
	- Update references if needed.
	- Reload in order: tables, constraints, indexes, views, code.

#### Exercise 5: Dependency order

- Inspect all dependencies.
	#### SOLUTION:
	```sql
	SELECT referenced_name, referencing_name, referencing_type
	FROM user_dependencies
	ORDER BY referenced_name;
	```

- Identify objects that depend on tables.
	#### SOLUTION:
	```sql
	SELECT referencing_name, referencing_type
	FROM user_dependencies
	WHERE referenced_name IN (
	  SELECT table_name FROM user_tables
	)
	ORDER BY referencing_type, referencing_name;
	```

- Build a dependency list for PL/SQL objects.
	#### SOLUTION:
	```sql
	SELECT referencing_name, referencing_type,
		   LISTAGG(referenced_name, ', ') WITHIN GROUP (ORDER BY referenced_name) AS dependencies
	FROM user_dependencies
	WHERE referencing_type IN ('PACKAGE', 'PROCEDURE', 'FUNCTION')
	GROUP BY referencing_name, referencing_type
	ORDER BY referencing_type, referencing_name;
	```

#### Exercise 6: Design a backup strategy (SQL-only)

- Document schema structure.
	#### SOLUTION:
	```sql
	SELECT object_type, COUNT(*) FROM user_objects GROUP BY object_type;
	SELECT table_name, num_rows FROM user_tables ORDER BY num_rows DESC;
	```

- Extract DDL for all object types.
	#### SOLUTION:
	```sql
	BEGIN
	  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'PRETTY', true);
	  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'SQLTERMINATOR', true);
	  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'SEGMENT_ATTRIBUTES', false);
	  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'STORAGE', false);
	  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'TABLESPACE', false);
	END;
	/

	SELECT DBMS_METADATA.GET_DDL('TABLE', table_name) FROM user_tables;
	SELECT DBMS_METADATA.GET_DDL('INDEX', index_name) FROM user_indexes;
	SELECT DBMS_METADATA.GET_DDL('VIEW', view_name) FROM user_views;
	SELECT DBMS_METADATA.GET_DDL('SEQUENCE', sequence_name) FROM user_sequences;
	SELECT DBMS_METADATA.GET_DDL('CONSTRAINT', constraint_name) FROM user_constraints;
	SELECT DBMS_METADATA.GET_DDL('PROCEDURE', object_name) FROM user_objects WHERE object_type = 'PROCEDURE';
	SELECT DBMS_METADATA.GET_DDL('FUNCTION', object_name) FROM user_objects WHERE object_type = 'FUNCTION';
	SELECT DBMS_METADATA.GET_DDL('PACKAGE', object_name) FROM user_objects WHERE object_type = 'PACKAGE';
	```

- Define reload order and verification checks.
	#### SOLUTION:
	Reload order:
	- Tables (without constraints)
	- Sequences
	- Indexes
	- Constraints
	- Views
	- Procedures, functions, packages
	- Triggers

	Verification queries:
	```sql
	SELECT object_type, COUNT(*) FROM user_objects GROUP BY object_type;
	SELECT table_name, num_rows FROM user_tables ORDER BY table_name;
	SELECT index_name, table_name FROM user_indexes ORDER BY index_name;
	```

#### Discussion Questions

- DBMS_METADATA limitations vs expdp.
	#### SOLUTION:
	DBMS_METADATA exports DDL only, needs manual spooling, and is slower for large schemas.
	expdp exports data and DDL, scales better, but needs directory privileges.

- Handling circular dependencies.
	#### SOLUTION:
	Create base objects first and enable constraints later. For PL/SQL, create package specs
	before bodies to break cycles.

- Plan for read-only source to new schema migration.
	#### SOLUTION:
	Document schema, extract DDL with `EMIT_SCHEMA = false`, review schema-qualified references,
	apply DDL in dependency order, and verify with object counts and sample queries.
