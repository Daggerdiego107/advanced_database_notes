### Lesson 04: Transactions

#### Setup

- Create the `accounts` table and seed sample data.
- Verify starting balances.

#### Demo 1: No transaction (broken transfer)

- Debit Alice by $500.
- Simulate a crash before crediting Bob.
- Inspect the inconsistent state and roll back.

#### Demo 2: With transaction (COMMIT)

- Transfer $200 from Alice to Bob.
- Verify balances before commit and after commit.

#### Demo 3: ROLLBACK

- Attempt a $300 transfer, then rollback.
- Verify balances return to the last commit.

#### Demo 4: SAVEPOINT

- Debit Alice, set a savepoint, credit the wrong account, rollback to savepoint.
- Credit the correct account and commit.
