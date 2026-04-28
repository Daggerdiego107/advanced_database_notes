### Lesson 04: Transactions

#### Setup

- Create the `accounts` table and seed sample data.
	#### SOLUTION:
	```sql
	DROP TABLE accounts PURGE;

	CREATE TABLE accounts (
		account_id   NUMBER PRIMARY KEY,
		owner_name   VARCHAR2(50) NOT NULL,
		balance      NUMBER(10,2) NOT NULL CHECK (balance >= 0)
	);

	INSERT INTO accounts VALUES (1, 'Alice',  1000.00);
	INSERT INTO accounts VALUES (2, 'Bob',     500.00);
	INSERT INTO accounts VALUES (3, 'Charlie', 250.00);
	COMMIT;
	```

- Verify starting balances.
	#### SOLUTION:
	```sql
	SELECT account_id, owner_name, balance FROM accounts ORDER BY account_id;
	```

#### Demo 1: No transaction (broken transfer)

- Debit Alice by $500.
	#### SOLUTION:
	```sql
	UPDATE accounts SET balance = balance - 500 WHERE account_id = 1;
	```

- Simulate a crash before crediting Bob and inspect the state.
	#### SOLUTION:
	```sql
	SELECT account_id, owner_name, balance FROM accounts ORDER BY account_id;
	```

- Roll back to clean up.
	#### SOLUTION:
	```sql
	ROLLBACK;
	SELECT account_id, owner_name, balance FROM accounts ORDER BY account_id;
	```

#### Demo 2: With transaction (COMMIT)

- Transfer $200 from Alice to Bob and verify before commit.
	#### SOLUTION:
	```sql
	UPDATE accounts SET balance = balance - 200 WHERE account_id = 1;
	UPDATE accounts SET balance = balance + 200 WHERE account_id = 2;

	SELECT account_id, owner_name, balance FROM accounts ORDER BY account_id;
	```

- Commit and verify results.
	#### SOLUTION:
	```sql
	COMMIT;
	SELECT account_id, owner_name, balance FROM accounts ORDER BY account_id;
	```

#### Demo 3: ROLLBACK

- Attempt a $300 transfer and inspect the pending state.
	#### SOLUTION:
	```sql
	UPDATE accounts SET balance = balance - 300 WHERE account_id = 1;
	UPDATE accounts SET balance = balance + 300 WHERE account_id = 2;

	SELECT account_id, owner_name, balance FROM accounts ORDER BY account_id;
	```

- Roll back and verify balances return to last commit.
	#### SOLUTION:
	```sql
	ROLLBACK;
	SELECT account_id, owner_name, balance FROM accounts ORDER BY account_id;
	```

#### Demo 4: SAVEPOINT

- Debit Alice, set a savepoint, credit the wrong account, then roll back to savepoint.
	#### SOLUTION:
	```sql
	UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;

	SAVEPOINT after_alice;

	UPDATE accounts SET balance = balance + 100 WHERE account_id = 3;

	ROLLBACK TO SAVEPOINT after_alice;
	SELECT account_id, owner_name, balance FROM accounts ORDER BY account_id;
	```

- Credit the correct account and commit.
	#### SOLUTION:
	```sql
	UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;

	SELECT account_id, owner_name, balance FROM accounts ORDER BY account_id;
	COMMIT;
	```
