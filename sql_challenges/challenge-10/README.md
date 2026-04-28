### Lesson 05: Schema Backup and Restore

#### Exercise 1: Explore your schema

- List schema objects and counts by `object_type`.
- List object details ordered by type and name.

#### Exercise 2: Basic `DBMS_METADATA.GET_DDL`

- Configure transform parameters for clean DDL output.
- Extract DDL for one table and for all tables.

#### Exercise 3: Clean DDL for portability

- Disable schema emission in DDL output.
- Compare output with and without schema names.

#### Exercise 4: Plan a migration

- Inspect DDL for schema-qualified references.
- Review FK constraints and build a migration checklist.

#### Exercise 5: Dependency order

- Inspect dependencies from `user_dependencies`.
- Identify objects that depend on tables.
- Build a dependency list for PL/SQL objects.

#### Exercise 6: Design a backup strategy (SQL-only)

- Document schema structure.
- Extract DDL for all object types.
- Define a reload order and verification checks.

#### Discussion Questions

- DBMS_METADATA limitations vs expdp.
- Handling circular dependencies.
- Plan for read-only source to new schema migration.
