### Lesson 07: KPI Dashboards — Class Exercises

#### Step 1 — Enrich Schema

- Add analytics columns and constraints.
	#### SOLUTION:
	```sql
	ALTER TABLE tasks ADD (
		priority      VARCHAR2(10)  DEFAULT 'medium',
		due_date      DATE,
		completed_at  TIMESTAMP,
		tags          VARCHAR2(200)
	);

	ALTER TABLE tasks ADD CONSTRAINT chk_task_priority
		CHECK (priority IN ('low', 'medium', 'high', 'critical'));

	ALTER TABLE tasks DROP CONSTRAINT chk_task_status;
	ALTER TABLE tasks ADD CONSTRAINT chk_task_status
		CHECK (status IN ('open', 'in_progress', 'blocked', 'completed', 'cancelled'));

	COMMIT;

	SELECT column_name, data_type, nullable
	FROM   user_tab_columns
	WHERE  table_name = 'TASKS'
	ORDER  BY column_id;
	```

#### Step 2 — Seed Dashboard Data

- Load the tasks dataset for KPI exercises.
	#### SOLUTION:
	```sql
	DELETE FROM tasks;
	COMMIT;

	INSERT INTO tasks (title, description, status, priority, assigned_to, created_at, due_date, completed_at, tags) VALUES
	('Fix login bug', 'Users cannot log in with SSO after password reset', 'completed', 'high', 1, TIMESTAMP '2026-05-01 09:00:00', DATE '2026-05-03', TIMESTAMP '2026-05-02 14:30:00', 'bug,sso,auth'),
	('Design new dashboard', 'Create mockups for analytics page with KPI cards', 'in_progress', 'medium', 3, TIMESTAMP '2026-05-01 10:00:00', DATE '2026-05-10', NULL, 'design,ui,dashboard'),
	('Update dependencies', 'Upgrade numpy and pandas to latest stable', 'completed', 'low', 2, TIMESTAMP '2026-05-01 11:00:00', DATE '2026-05-05', TIMESTAMP '2026-05-04 16:00:00', 'maintenance,deps'),
	('API rate limiting', 'Implement rate limiting on public endpoints', 'open', 'high', 1, TIMESTAMP '2026-05-02 09:00:00', DATE '2026-05-08', NULL, 'api,security,backend'),
	('Write unit tests for auth', 'Cover login, logout, token refresh flows', 'in_progress', 'medium', 2, TIMESTAMP '2026-05-02 10:00:00', DATE '2026-05-09', NULL, 'testing,auth,qa'),
	('Database backup script', 'Automate daily backup to S3 with retention', 'completed', 'medium', 1, TIMESTAMP '2026-05-02 11:00:00', DATE '2026-05-04', TIMESTAMP '2026-05-03 10:00:00', 'devops,backup,s3'),
	('Mobile responsive nav', 'Menu does not collapse on screens < 768px', 'blocked', 'high', 3, TIMESTAMP '2026-05-03 09:00:00', DATE '2026-05-07', NULL, 'bug,mobile,ui,css'),
	('User profile page', 'Allow users to edit avatar and bio', 'open', 'low', 3, TIMESTAMP '2026-05-03 10:00:00', DATE '2026-05-15', NULL, 'feature,profile,frontend'),
	('Optimize slow query', 'Report generation takes 45 seconds', 'completed', 'critical', 1, TIMESTAMP '2026-05-03 11:00:00', DATE '2026-05-04', TIMESTAMP '2026-05-03 18:00:00', 'performance,sql,optimization'),
	('Set up CI/CD pipeline', 'GitHub Actions for test + deploy', 'in_progress', 'medium', 2, TIMESTAMP '2026-05-04 09:00:00', DATE '2026-05-12', NULL, 'devops,cicd,github'),
	('Error tracking integration', 'Connect Sentry for production error alerts', 'open', 'medium', 1, TIMESTAMP '2026-05-04 10:00:00', DATE '2026-05-11', NULL, 'monitoring,sentry,ops'),
	('Dark mode toggle', 'Add theme switcher with CSS variables', 'completed', 'low', 3, TIMESTAMP '2026-05-04 11:00:00', DATE '2026-05-06', TIMESTAMP '2026-05-05 15:00:00', 'feature,ui,theming'),
	('Password strength meter', 'Visual indicator for password complexity', 'open', 'low', 2, TIMESTAMP '2026-05-05 09:00:00', DATE '2026-05-14', NULL, 'feature,auth,frontend'),
	('Export to CSV', 'Allow users to download report as CSV', 'in_progress', 'medium', 3, TIMESTAMP '2026-05-05 10:00:00', DATE '2026-05-13', NULL, 'feature,export,reporting'),
	('Redis caching layer', 'Cache frequent queries to reduce DB load', 'open', 'high', 1, TIMESTAMP '2026-05-05 11:00:00', DATE '2026-05-10', NULL, 'backend,redis,performance'),
	('Email notification service', 'Send task assignment emails via SendGrid', 'completed', 'medium', 2, TIMESTAMP '2026-05-06 09:00:00', DATE '2026-05-08', TIMESTAMP '2026-05-07 12:00:00', 'feature,email,notifications'),
	('Audit log table', 'Track all changes to tasks with timestamps', 'in_progress', 'medium', 1, TIMESTAMP '2026-05-06 10:00:00', DATE '2026-05-15', NULL, 'feature,audit,logging'),
	('Two-factor auth', 'Add TOTP support for admin accounts', 'open', 'critical', 2, TIMESTAMP '2026-05-06 11:00:00', DATE '2026-05-09', NULL, 'feature,security,auth'),
	('Load testing script', 'Simulate 1000 concurrent users with k6', 'completed', 'medium', 1, TIMESTAMP '2026-05-07 09:00:00', DATE '2026-05-08', TIMESTAMP '2026-05-07 17:00:00', 'testing,performance,k6'),
	('Documentation site', 'Set up MkDocs for API documentation', 'open', 'low', 3, TIMESTAMP '2026-05-07 10:00:00', DATE '2026-05-20', NULL, 'docs,mkdocs,technical-writing'),
	('Fix memory leak', 'Node process grows to 2GB after 24 hours', 'blocked', 'critical', 1, TIMESTAMP '2026-05-07 11:00:00', DATE '2026-05-09', NULL, 'bug,performance,memory'),
	('Webhook integrations', 'Allow third-party services to subscribe to events', 'open', 'medium', 2, TIMESTAMP '2026-05-08 09:00:00', DATE '2026-05-16', NULL, 'feature,api,integrations'),
	('Search autocomplete', 'Typeahead search with debounced API calls', 'in_progress', 'low', 3, TIMESTAMP '2026-05-08 10:00:00', DATE '2026-05-14', NULL, 'feature,search,frontend'),
	('GDPR data export', 'Allow users to download all their data', 'open', 'high', 1, TIMESTAMP '2026-05-08 11:00:00', DATE '2026-05-12', NULL, 'compliance,gdpr,privacy'),
	('Slack bot integration', 'Post task updates to team Slack channel', 'completed', 'low', 2, TIMESTAMP '2026-05-09 09:00:00', DATE '2026-05-11', TIMESTAMP '2026-05-10 11:00:00', 'feature,slack,bot'),
	('Database migration tool', 'Evaluate Flyway vs Liquibase for schema changes', 'open', 'medium', 1, TIMESTAMP '2026-05-09 10:00:00', DATE '2026-05-17', NULL, 'research,db,migrations'),
	('Image upload resizing', 'Resize avatars to 256x256 on upload', 'in_progress', 'low', 3, TIMESTAMP '2026-05-09 11:00:00', DATE '2026-05-13', NULL, 'feature,images,processing'),
	('Session timeout bug', 'Users stay logged in after 30 days', 'open', 'high', 2, TIMESTAMP '2026-05-10 09:00:00', DATE '2026-05-11', NULL, 'bug,auth,sessions'),
	('Analytics event tracking', 'Track page views and clicks with Mixpanel', 'completed', 'medium', 3, TIMESTAMP '2026-05-10 10:00:00', DATE '2026-05-12', TIMESTAMP '2026-05-11 09:00:00', 'feature,analytics,tracking'),
	('Kubernetes deployment', 'Migrate from EC2 to EKS with Helm charts', 'open', 'critical', 1, TIMESTAMP '2026-05-10 11:00:00', DATE '2026-05-15', NULL, 'devops,k8s,infrastructure'),
	('Legacy API deprecation', 'Sunset the v1 API endpoints', 'cancelled', 'low', 2, TIMESTAMP '2026-05-01 08:00:00', DATE '2026-05-20', NULL, 'api,deprecation,legacy'),
	('Manual data migration', 'One-time script to migrate old records', 'cancelled', 'medium', 1, TIMESTAMP '2026-05-02 08:00:00', DATE '2026-05-10', NULL, 'migration,data,one-time'),
	('Third-party auth provider', 'Integrate with Okta for enterprise SSO', 'cancelled', 'high', 3, TIMESTAMP '2026-05-03 08:00:00', DATE '2026-05-18', NULL, 'auth,sso,enterprise'),
	('Security audit remediation', 'Fix findings from Q1 penetration test', 'open', 'critical', 1, TIMESTAMP '2026-05-01 09:00:00', DATE '2026-05-05', NULL, 'security,audit,compliance'),
	('Customer data retention policy', 'Implement automatic data purging', 'in_progress', 'high', 2, TIMESTAMP '2026-05-02 09:00:00', DATE '2026-05-06', NULL, 'compliance,gdpr,data'),
	('Payment gateway integration', 'Add Stripe support for subscriptions', 'blocked', 'medium', 3, TIMESTAMP '2026-05-03 09:00:00', DATE '2026-05-07', NULL, 'payments,stripe,billing'),
	('Performance regression fix', 'Query latency spike after last deploy', 'open', 'critical', 1, TIMESTAMP '2026-05-04 09:00:00', DATE '2026-05-08', NULL, 'performance,regression,sql');

	COMMIT;

	SELECT status, COUNT(*) AS task_count
	FROM   tasks
	GROUP  BY status
	ORDER  BY task_count DESC;
	```

#### Exercise 1 — Team Velocity

- Define velocity and compare to overall average.
	#### SOLUTION:
	```sql
	-- Contract: velocity = completed tasks per active day per team.
	WITH team_counts AS (
		SELECT t.name AS team_name,
		       COUNT(*) AS completed_tasks,
		       COUNT(DISTINCT TRUNC(ts.completed_at)) AS active_days
		FROM   tasks ts
		JOIN   users u ON u.id = ts.assigned_to
		JOIN   teams t ON t.id = u.team_id
		WHERE  ts.status = 'completed'
		  AND  ts.completed_at IS NOT NULL
		GROUP  BY t.name
	),
	team_velocity AS (
		SELECT team_name,
		       completed_tasks,
		       active_days,
		       ROUND(completed_tasks / NULLIF(active_days, 0), 2) AS velocity_per_day
		FROM   team_counts
	)
	SELECT team_name,
	       completed_tasks,
	       active_days,
	       velocity_per_day,
	       CASE
	           WHEN velocity_per_day < AVG(velocity_per_day) OVER () THEN 'below_avg'
	           ELSE 'at_or_above_avg'
	       END AS velocity_flag
	FROM   team_velocity
	ORDER  BY velocity_per_day DESC;
	```

#### Exercise 2 — On-Time Delivery Rate

- Define on-time and compute rate by priority.
	#### SOLUTION:
	```sql
	-- Contract: on-time = completed_at < (due_date + 1). Exclude NULL due_date.
	SELECT priority,
	       COUNT(*) AS completed_with_due_date,
	       SUM(CASE WHEN completed_at < (due_date + 1) THEN 1 ELSE 0 END) AS on_time_count,
	       ROUND(
	           SUM(CASE WHEN completed_at < (due_date + 1) THEN 1 ELSE 0 END) * 100.0
	           / NULLIF(COUNT(*), 0),
	           1
	       ) AS on_time_rate_pct,
	       ROUND(
	           AVG(CASE WHEN completed_at > due_date THEN (completed_at - due_date) * 24 END),
	           1
	       ) AS avg_lateness_hours
	FROM   tasks
	WHERE  status = 'completed'
	  AND  completed_at IS NOT NULL
	  AND  due_date IS NOT NULL
	GROUP  BY priority
	ORDER  BY CASE priority
	              WHEN 'critical' THEN 1
	              WHEN 'high'     THEN 2
	              WHEN 'medium'   THEN 3
	              WHEN 'low'      THEN 4
	          END;
	```

#### Exercise 3 — Improve Tasks per Team

- Add total, active, completion rate, and health score.
	#### SOLUTION:
	```sql
	SELECT t.name AS team_name,
	       COUNT(ts.id) AS total_tasks,
	       SUM(CASE WHEN ts.status IN ('open', 'in_progress', 'blocked') THEN 1 ELSE 0 END) AS active_tasks,
	       ROUND(
	           SUM(CASE WHEN ts.status = 'completed' THEN 1 ELSE 0 END) * 100.0
	           / NULLIF(SUM(CASE WHEN ts.status != 'cancelled' THEN 1 ELSE 0 END), 0),
	           1
	       ) AS completion_rate,
	       CASE
	           WHEN SUM(CASE WHEN ts.status IN ('open', 'in_progress', 'blocked') THEN 1 ELSE 0 END) > 10 THEN 'Overloaded'
	           WHEN SUM(CASE WHEN ts.status IN ('open', 'in_progress', 'blocked') THEN 1 ELSE 0 END) BETWEEN 5 AND 10 THEN 'Healthy'
	           ELSE 'Underutilized'
	       END AS health_score
	FROM   teams t
	LEFT   JOIN users u ON u.team_id = t.id
	LEFT   JOIN tasks ts ON ts.assigned_to = u.id
	GROUP  BY t.id, t.name
	ORDER  BY active_tasks DESC;
	```

#### Exercise 4 — Improve Avg Resolution Time

- Break down resolution time by priority with median and SLA targets.
	#### SOLUTION:
	```sql
	WITH completed AS (
		SELECT priority,
		       (EXTRACT(DAY FROM (completed_at - created_at)) * 24 +
		        EXTRACT(HOUR FROM (completed_at - created_at)) +
		        EXTRACT(MINUTE FROM (completed_at - created_at)) / 60) AS resolution_hours
		FROM   tasks
		WHERE  status = 'completed'
		  AND  completed_at IS NOT NULL
	)
	SELECT priority,
	       COUNT(*) AS completed_task_count,
	       ROUND(AVG(resolution_hours), 1) AS avg_resolution_hours,
	       ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY resolution_hours), 1) AS median_resolution_hours,
	       ROUND(MIN(resolution_hours), 1) AS min_resolution_hours,
	       ROUND(MAX(resolution_hours), 1) AS max_resolution_hours,
	       CASE
	           WHEN priority = 'critical' AND AVG(resolution_hours) <= 24 THEN 'met'
	           WHEN priority = 'high'     AND AVG(resolution_hours) <= 72 THEN 'met'
	           WHEN priority = 'medium'   AND AVG(resolution_hours) <= 168 THEN 'met'
	           WHEN priority = 'low'      AND AVG(resolution_hours) <= 336 THEN 'met'
	           ELSE 'missed'
	       END AS target_met
	FROM   completed
	GROUP  BY priority
	ORDER  BY CASE priority
	              WHEN 'critical' THEN 1
	              WHEN 'high'     THEN 2
	              WHEN 'medium'   THEN 3
	              WHEN 'low'      THEN 4
	          END;
	```

#### Exercise 5 — Improve Overdue Tasks

- Build a detailed overdue report with severity and summary rows.
	#### SOLUTION:
	```sql
	WITH overdue AS (
		SELECT ts.title,
		       u.full_name AS assignee,
		       t.name AS team,
		       ts.priority,
		       ts.due_date,
		       (TRUNC(SYSDATE) - ts.due_date) AS days_overdue,
		       CASE
		           WHEN ts.priority = 'critical' AND (TRUNC(SYSDATE) - ts.due_date) > 0 THEN 'CRITICAL'
		           WHEN ts.priority = 'high'     AND (TRUNC(SYSDATE) - ts.due_date) > 2 THEN 'HIGH'
		           WHEN ts.priority = 'medium'   AND (TRUNC(SYSDATE) - ts.due_date) > 5 THEN 'MEDIUM'
		           ELSE 'LOW'
		       END AS severity
		FROM   tasks ts
		LEFT   JOIN users u ON u.id = ts.assigned_to
		LEFT   JOIN teams t ON t.id = u.team_id
		WHERE  ts.due_date < TRUNC(SYSDATE)
		  AND  ts.status NOT IN ('completed', 'cancelled')
		  AND  ts.due_date IS NOT NULL
	)
	SELECT title,
	       assignee,
	       team,
	       priority,
	       due_date,
	       days_overdue,
	       severity,
	       NULL AS overdue_count,
	       NULL AS avg_days_overdue,
	       1 AS sort_group,
	       CASE severity
	           WHEN 'CRITICAL' THEN 1
	           WHEN 'HIGH'     THEN 2
	           WHEN 'MEDIUM'   THEN 3
	           ELSE 4
	       END AS severity_order
	FROM overdue
	UNION ALL
	SELECT 'SUMMARY' AS title,
	       NULL AS assignee,
	       NULL AS team,
	       NULL AS priority,
	       NULL AS due_date,
	       NULL AS days_overdue,
	       severity,
	       COUNT(*) AS overdue_count,
	       ROUND(AVG(days_overdue), 1) AS avg_days_overdue,
	       2 AS sort_group,
	       CASE severity
	           WHEN 'CRITICAL' THEN 1
	           WHEN 'HIGH'     THEN 2
	           WHEN 'MEDIUM'   THEN 3
	           ELSE 4
	       END AS severity_order
	FROM overdue
	GROUP BY severity
	ORDER BY severity_order, sort_group, days_overdue DESC NULLS LAST;
	```

#### Exercise 6 — Fix Productivity Score

- Explain the flaw and rewrite the KPI.
	#### SOLUTION:
	```sql
	-- Problem: counts all tasks (open/blocked) as productivity.
	SELECT u.full_name,
	       ROUND(
	           SUM(CASE
	                   WHEN ts.priority = 'critical' THEN 4
	                   WHEN ts.priority = 'high'     THEN 3
	                   WHEN ts.priority = 'medium'   THEN 2
	                   ELSE 1
	               END) / NULLIF(COUNT(DISTINCT TRUNC(ts.completed_at)), 0),
	           2
	       ) AS weighted_completed_per_day
	FROM   users u
	JOIN   tasks ts ON ts.assigned_to = u.id
	WHERE  ts.status = 'completed'
	  AND  ts.completed_at IS NOT NULL
	GROUP  BY u.id, u.full_name
	ORDER  BY weighted_completed_per_day DESC;
	```

#### Exercise 7 — Fix Team Efficiency

- Explain the flaw and write a meaningful ratio.
	#### SOLUTION:
	```sql
	-- Problem: AVG(task_id) is meaningless.
	SELECT t.name AS team_name,
	       SUM(CASE WHEN ts.status = 'completed' THEN 1 ELSE 0 END) AS completed_tasks,
	       SUM(CASE WHEN ts.status != 'cancelled' THEN 1 ELSE 0 END) AS total_non_cancelled,
	       ROUND(
	           SUM(CASE WHEN ts.status = 'completed' THEN 1 ELSE 0 END) * 100.0
	           / NULLIF(SUM(CASE WHEN ts.status != 'cancelled' THEN 1 ELSE 0 END), 0),
	           1
	       ) AS completion_rate_pct
	FROM   teams t
	LEFT   JOIN users u ON u.team_id = t.id
	LEFT   JOIN tasks ts ON ts.assigned_to = u.id
	GROUP  BY t.id, t.name
	ORDER  BY completion_rate_pct DESC;
	```

#### Exercise 8 — Fix Urgency Index

- Explain the flaw and create a weighted urgency score.
	#### SOLUTION:
	```sql
	-- Problem: mixing strings with numbers; no real urgency logic.
	SELECT title,
	       priority,
	       due_date,
	       CASE priority
	           WHEN 'critical' THEN 4
	           WHEN 'high'     THEN 3
	           WHEN 'medium'   THEN 2
	           ELSE 1
	       END AS priority_weight,
	       CASE WHEN due_date IS NULL THEN NULL ELSE (due_date - TRUNC(SYSDATE)) END AS days_until_due,
	       (CASE priority
	           WHEN 'critical' THEN 4
	           WHEN 'high'     THEN 3
	           WHEN 'medium'   THEN 2
	           ELSE 1
	        END * 10)
	       - NVL(due_date - TRUNC(SYSDATE), 0) AS urgency_score
	FROM   tasks
	ORDER  BY urgency_score DESC, due_date NULLS LAST;
	```
