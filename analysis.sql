-- Business KPI Tracker
-- Initial SQL analysis

SELECT
    Project_ID,
    Project_Name,
    Department,
    Budget_Hours,
    Actual_Hours,
    Actual_Hours - Budget_Hours AS Hours_Variance
FROM projects;