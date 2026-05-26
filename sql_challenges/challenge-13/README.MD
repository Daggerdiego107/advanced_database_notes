### Lesson 08: Exercise — Assignment History

#### Step 1 — Source Tables (OLTP)

- Create `tickets` for current state.
- Create `ticket_assignments` for assignment history.

#### Step 2 — Sample Data

- Insert at least 5 tickets.
- Reassign at least one ticket.

#### Step 3 — Trigger

- On INSERT/UPDATE of `assigned_to`, log to `ticket_assignments`.
- Close the previous active assignment (set `valid_to`).
- Insert the new active assignment with `valid_from = SYSTIMESTAMP`.

#### Verification

- Reassign a ticket and query `ticket_assignments` to confirm history.
