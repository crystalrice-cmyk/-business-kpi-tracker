-- =====================================================
-- BUSINESS KPI TRACKER
-- Project Performance & Labor Risk Analysis
-- =====================================================
-- Purpose:
-- Analyze project labor performance, identify projects
-- exceeding or approaching budget risk, and summarize
-- performance by department.
-- =====================================================


-- ANALYSIS 1: PROJECT BUDGET VARIANCE
-- Identifies projects that have exceeded budgeted labor hours.

SELECT
    project_name,
    department,
    budget_hours,
    actual_hours,
    actual_hours - budget_hours AS hours_variance
FROM projects
WHERE actual_hours > budget_hours
ORDER BY hours_variance DESC;


-- =====================================================
-- ANALYSIS 2: PROJECT RISK IDENTIFICATION
-- Compares percentage of labor budget consumed against
-- percentage of project completion.
--
-- Risk Logic:
-- Over Budget = Actual hours exceed budget hours
-- At Risk     = Labor consumption is 10+ percentage
--               points ahead of project completion
-- On Track    = Project does not meet either risk condition
-- =====================================================

SELECT
    project_name,
    department,
    budget_hours,
    actual_hours,
    percent_complete,

    ROUND(
        actual_hours * 100.0 / budget_hours,
        1
    ) AS budget_consumed_pct,

    ROUND(
        (actual_hours * 100.0 / budget_hours)
        - percent_complete,
        1
    ) AS risk_variance,

    CASE
        WHEN actual_hours > budget_hours
            THEN 'Over Budget'

        WHEN (actual_hours * 100.0 / budget_hours)>= percent_complete + 10
            THEN 'At Risk'

        ELSE 'On Track'
    END AS risk_status

FROM projects
ORDER BY risk_variance DESC;


-- =====================================================
-- ANALYSIS 3: DEPARTMENT PERFORMANCE SUMMARY
-- Aggregates project labor performance to provide
-- management-level visibility by department.
-- =====================================================

SELECT
    department,
    COUNT(*) AS project_count,
    SUM(budget_hours) AS total_budget_hours,
    SUM(actual_hours) AS total_actual_hours,

    SUM(
        actual_hours - budget_hours
    ) AS total_hours_variance,

    ROUND(
        SUM(actual_hours) * 100.0
        / SUM(budget_hours),
        1
    ) AS budget_consumed_pct

FROM projects
GROUP BY department
ORDER BY total_hours_variance DESC;
