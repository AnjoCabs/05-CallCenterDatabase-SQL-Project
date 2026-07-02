-- DISCLAIMER:
-- This query is intended solely for study and practice purposes. It is not reflective of the operations,
-- data, or practices of any actual call center company. The data, structure, and results presented herein 
-- are hypothetical and have been generated for educational purposes only. No real-world companies, organizations,
-- or individuals are associated with this query or its content.

-- DATA SOURCE ( https://www.youtube.com/watch?v=NQfjasDctpM&list=PLwIcJx1aSL1SSbMSGRYCSKzcHTME-xQVq )

CREATE TABLE callcenterdataset
(
	call_ID VARCHAR(50),
	date date,
	Agent_First_Name VARCHAR(50),
	Agent_Last_Name VARCHAR(50),
	Agent_Rating DECIMAL(4,1),
	Product_Discussed VARCHAR(50),
	Call_Duration_Minutes DECIMAL(8,2),
	Call_Outcome VARCHAR(50),
	Customer_Age INT,
	Callers_Name VARCHAR(50),
	Customer_Gender VARCHAR(50),
	State VARCHAR(50),
	Customer_Income_Bracket VARCHAR(50),
	Time_of_Day VARCHAR(50),
	Follow_Up_Call_Required VARCHAR(50),
	Repeat_Customer VARCHAR(50),
	Reason_Call_Abandoned VARCHAR(50));

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:/Users/billy/Desktop/DataSets/SalesMarketingCallCenterSQL/SalesMarketingCallCenter.csv'
INTO TABLE callcenterdataset
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


-- 1. How many total calls got?
SELECT
	COUNT(call_ID) AS total_calls
FROM callcenterdataset;

-- 2. Count of Calls  base on the call_outcome
SELECT
    Call_Outcome,
    COUNT(*) AS call_count
FROM callcenterdataset
GROUP BY Call_Outcome
ORDER BY call_count DESC;

-- 3. Number of call base on gender
SELECT
    Customer_Gender,
    COUNT(*) AS call_count,
    ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM callcenterdataset), 2) AS percentage
FROM callcenterdataset
GROUP BY Customer_Gender
ORDER BY call_count DESC;

-- 4. Number of call base on agent
SELECT
	CONCAT( Agent_First_Name, ' ', Agent_Last_Name) AS full_name,
    COUNT(*) AS call_count
FROM callcenterdataset
GROUP BY full_name
ORDER BY call_count DESC;

-- 5. Agent with the highest number of abandoned calls
SELECT
    CONCAT(Agent_First_Name, ' ', Agent_Last_Name) AS agent_full_name,
    COUNT(*) AS abandoned_call_count
FROM callcenterdataset
WHERE Call_Outcome = 'Abandoned'
GROUP BY agent_full_name
ORDER BY abandoned_call_count DESC
LIMIT 1;

-- 6. Percentage of abandoned calls by agent based on their total calls
SELECT
    CONCAT(Agent_First_Name, ' ', Agent_Last_Name) AS agent_full_name,
    COUNT(CASE WHEN 
				Call_Outcome = 'Abandoned' THEN 1 END) AS abandoned_calls,
    COUNT(*) AS total_calls,
    ROUND(
        COUNT(CASE WHEN 
				Call_Outcome = 'Abandoned' THEN 1 END) * 100.0 / COUNT(*), 
        2
    ) AS abandoned_call_percentage
FROM callcenterdataset
GROUP BY agent_full_name
ORDER BY abandoned_call_percentage DESC;

-- 7. Agent with the highest number of successful calls
SELECT
    CONCAT(Agent_First_Name, ' ', Agent_Last_Name) AS agent_full_name,
    COUNT(CASE WHEN 
			Call_Outcome = 'Success' THEN 1 END) AS success_calls,
    COUNT(*) AS total_calls,
    ROUND(
        COUNT(CASE WHEN 
					Call_Outcome = 'Success' THEN 1 END) * 100.0 / COUNT(*),2) AS success_percentage
FROM callcenterdataset
GROUP BY agent_full_name
ORDER BY success_calls DESC;

-- 8. Agent with the highest total call time
SELECT
    CONCAT(Agent_First_Name, ' ', Agent_Last_Name) AS agent_full_name,
    COUNT(*) AS total_calls,
    SUM(Call_Duration_Minutes) AS total_call_time,
    ROUND(AVG(Call_Duration_Minutes), 2) AS avg_call_duration
FROM callcenterdataset
GROUP BY agent_full_name
ORDER BY total_call_time DESC;

-- 9. Most common reasons why calls were abandoned
SELECT
    Reason_Call_Abandoned AS reason,
    COUNT(*) AS total_abandoned
FROM callcenterdataset
WHERE Call_Outcome = 'Abandoned'
GROUP BY reason
ORDER BY total_abandoned DESC;

-- 10. What time of the day has the highest number of calls
SELECT
    Time_of_Day,
    COUNT(*) AS call_count
FROM callcenterdataset
GROUP BY Time_of_Day
ORDER BY call_count DESC;

-- 11. Which state has the highest number of Abandoned and Success calls
SELECT
	state,
    COUNT(CASE WHEN 
				Call_Outcome = 'Success' THEN 1 END) AS success_call,
    COUNT(CASE WHEN 
				Call_Outcome = 'Failure' THEN 1 END) AS failure_call,
    COUNT(CASE WHEN 
				Call_Outcome = 'Abandoned' THEN 1 END) AS abandoned_call
FROM callcenterdataset
GROUP BY state
ORDER BY
	success_call DESC,
    abandoned_call DESC;

-- 12. What is the most commonly discussed product in successful calls
SELECT
    Product_Discussed,
    COUNT(CASE WHEN Call_Outcome = 'Success' THEN 1 END) AS Success_Count,
    COUNT(*) AS Total_Calls,
    ROUND(COUNT(CASE WHEN Call_Outcome = 'Success' THEN 1 END) * 100.0 / COUNT(*), 2) AS Success_Rate_Percent
FROM callcenterdataset
GROUP BY Product_Discussed
ORDER BY Success_Rate_Percent DESC;

-- 13. Total number of repeat customers
SELECT
    COUNT(*) AS repeat_customers,
    (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM callcenterdataset)) AS repeat_percentage
FROM callcenterdataset
WHERE Repeat_Customer = 'Yes';

-- 14. What is the most common product discussed by repeat customers
SELECT
    Product_Discussed,
    COUNT(*) AS repeat_customer_count
FROM callcenterdataset
WHERE Repeat_Customer = 'Yes'
GROUP BY Product_Discussed
ORDER BY repeat_customer_count DESC;

-- 15. What day has the most calls
SELECT
    DAYNAME(date) AS day_of_week,
    COUNT(*) AS call_count
FROM callcenterdataset
GROUP BY day_of_week
ORDER BY call_count DESC;


-- DISCLAIMER:
-- This query is intended solely for study and practice purposes. It is not reflective of the operations,
-- data, or practices of any actual call center company. The data, structure, and results presented herein 
-- are hypothetical and have been generated for educational purposes only. No real-world companies, organizations,
-- or individuals are associated with this query or its content.

-- DATA SOURCE ( https://www.youtube.com/watch?v=NQfjasDctpM&list=PLwIcJx1aSL1SSbMSGRYCSKzcHTME-xQVq )
