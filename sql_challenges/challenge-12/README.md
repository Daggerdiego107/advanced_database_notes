### Lesson 07: KPI Dashboards with Plotly + Oracle

#### Step 1: Install dependencies

- Install `oracledb`, `sqlalchemy`, `pandas`, and `plotly`.

#### Step 2: Connect to Oracle FreeSQL

- Configure credentials and test the connection with a simple query.

#### Step 3: KPI 1 — Tasks by Status (Pie Chart)

- Aggregate by `status` and compute percent of total.

#### Step 4: KPI 2 — Tasks per Team (Bar Chart)

- Join teams, users, and tasks to count tasks per team.

#### Step 5: KPI 3 — Workload per User (Horizontal Bar)

- Count open/in-progress/blocked tasks per user.

#### Step 6: KPI 4 & 5 — Completion Rate + Avg Resolution

- Compute completion rate and average resolution time in hours.

#### Step 7: KPI 6 — Tasks Created per Day (Line Chart)

- Group by `TRUNC(created_at)` to trend daily task creation.

#### Step 8: KPI 7 — Overdue Tasks (Alert Table)

- Filter non-completed tasks past their `due_date`.

#### Step 9: KPI 8 — Priority Distribution (Stacked Bar)

- Count statuses by priority to visualize distribution.

#### Step 10: Compose the Full Dashboard

- Combine the key charts into a single Plotly dashboard.

#### Exercise

- Add a **Tasks completed per day** chart and record the SQL in the challenge files.
