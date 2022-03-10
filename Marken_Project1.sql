/*
Project 1: Excelsior Mobile Report
Gabriel Marken
*/

USE [21WQ_BUAN4210_Lloyd_ExcelsiorMobile];

-- RESULTS WITH VISUALIZATIONS

-- 1 --
-- A
-- This query returns the first and last names of our customers along with their minute usage, 
-- data usage, text usage and total bill. Order them by their full name.
-- Return: FirstName, LastName, Minutes, DataInMB, Texts, Total
-- Tables: Subscriber, LastMonthUsage, Bill


SELECT CONCAT(FirstName, ' ', LastName) AS UserName, Minutes AS MinuteUsage, DataInMB, Texts, Total AS TotalBill$
FROM Subscriber AS S, LastMonthUsage AS LMU,  Bill AS B
WHERE S.MIN = LMU.MIN AND LMU.MIN = B.MIN
ORDER BY UserName;


-- B
-- This query shows us the average of the minutes, data, texts and total bills by city.(Sort by city)
-- Returns/Use: Total, Minutes, Data, Texts, City
-- Tables: Bill, LastMonthUsage, Subscriber

SELECT City, AVG(Minutes) AS AVGMin, AVG(DataInMB) AS AVGData, AVG(Texts) AS AVGTexts, AVG(Total) AS AVGBill$
FROM LastMonthUsage AS LMU, Subscriber AS SUB, Bill AS B
WHERE  LMU.MIN = SUB.MIN AND SUB.MIN = B.MIN
GROUP BY City
ORDER BY City ASC;

-- C
-- This query shows us the sum of the minutes, data, texts and total bills by city.
-- Returns/Use: Total, Minutes, Data, Texts, City
-- Tables: Bill, LastMonthUsage, Subscriber
SELECT City, SUM(Minutes) AS TotalMin, SUM(DataInMB) AS TotalData, SUM(Texts) AS TotalTexts, SUM(Total) AS TotalBill$
FROM LastMonthUsage AS LMU, Subscriber AS SUB, Bill AS B
WHERE  LMU.MIN = SUB.MIN AND SUB.MIN = B.MIN
GROUP BY City
ORDER BY City ASC;

-- D
-- This query shows us the average of the minutes, data, texts and total bills by mobile plan.
-- Returns/Use: Total, Minutes, Data, Texts, City
-- Tables: Bill, LastMonthUsage, Subscriber
SELECT PlanName, AVG(Minutes) AS AVGMin, AVG(DataInMB) AS AVGData, AVG(Texts) AS AVGTexts, AVG(Total) AS AVGBill$
FROM LastMonthUsage AS LMU, Bill AS B, Subscriber AS SUB
WHERE  LMU.MIN = SUB.MIN AND SUB.MIN = B.MIN
GROUP BY PlanName
ORDER BY PlanName ASC;

-- E
-- This query shows us the sum of the minutes, data, texts and total bills by mobile plan.
-- Returns/Use: Total, Minutes, Data, Texts, City
-- Tables: Bill, LastMonthUsage, Subscriber

SELECT PlanName, SUM(Minutes) AS TotalMin, SUM(DataInMB) AS TotalData, SUM(Texts) AS TotalTexts, SUM(Total) AS TotalBill$
FROM LastMonthUsage AS LMU, Subscriber AS SUB, Bill AS B
WHERE  LMU.MIN = SUB.MIN AND SUB.MIN = B.MIN
GROUP BY PlanName
ORDER BY PlanName ASC;

-- RESULTS WITHOUT VISUALIZATIONS

-- 1 --
--A
-- This finds the two cities which have the most customers 
SELECT TOP 2 City, COUNT(MIN) AS NumOfCustomers
FROM Subscriber
GROUP BY City
ORDER BY NumOfCUstomers DESC;

-- B
-- This shows which three cities we should increase our marketing in. 

SELECT TOP 3 City, COUNT(MIN) AS NumOfCustomers
FROM Subscriber
GROUP BY City
ORDER BY NumOfCUstomers ASC;


-- C
-- This shows us which plans have the least amount of our market share and therefore which plans we should aim to increase
SELECT TOP 5 PlanName, COUNT(PlanName) AS NumOfEachPlan
FROM Subscriber
GROUP BY PlanName
ORDER BY NumOfEachPlan ASC;

-- 2 -- 
-- A
-- This shows us the count of cell phone types among our customers and which is the most common
SELECT Type, COUNT(Type) AS NumOfPhoneType
FROM Device
GROUP BY Type
ORDER BY NumOfPhoneType DESC;

-- B
-- This shows us the customer names of which are using the lesser used phone type.
SELECT CONCAT(FirstName, ' ', LastName) AS UserName
FROM Device AS DE, Subscriber AS SUB, DirNums AS DM
WHERE DE.IMEI = DM.IMEI AND DM.MDN = SUB.MDN AND Type = 'Apple';

-- C
-- This query shows us our customers and the year of their phones who have phones released before 2018.
SELECT CONCAT(FirstName, ' ', LastName) AS UserName, YearReleased
FROM Device AS DE, Subscriber AS SUB, DirNums AS DM
WHERE DE.IMEI = DM.IMEI AND DM.MDN = SUB.MDN AND YearReleased < 2018
ORDER BY YearReleased ASC;

-- 3 --
-- A
/* We want to know ultimately if there is a city that uses a lot of data (within the top 3 data using cities)
 but none of our customers in that city are using the Unlimited Plans. If there is a city like that, which one is it? 
 */
 -- return city, data plan, usage 

 -- This query returns the top three cities in terms of data usage. The next few queries search each city individually to look for 
 -- unlimited data plans
 SELECT TOP 3 SUM(DataInMB) AS CityData, City
 FROM LastMonthUsage AS LMU, Subscriber AS SUB
 WHERE SUB.MIN = LMU.MIN
 GROUP BY City
 ORDER BY CityData DESC;

 -- B
 -- This searches for any users using the unlimited data plan in Olympia, one of the top three cities in terms of data usage.
 -- If there are any results, the city is disqualified from our search
 SELECT DataInMB, City, Data AS DataPlan
 FROM MPlan AS MP, LastMonthUsage AS LMU, Subscriber AS SUB
 WHERE MP.PlanName = SUB.PlanName AND SUB.MIN = LMU.MIN AND Data LIKE 'Unlimited'
 AND City = 'Olympia' 
 ORDER BY DataInMB DESC;
 
 -- C
 -- This searches for any users using the unlimited data plan in Bellevue, one of the top three cities in terms of data usage.
 -- If there are any results, the city is disqualified from our search
 SELECT DataInMB, City, Data AS DataPlan
 FROM MPlan AS MP, LastMonthUsage AS LMU, Subscriber AS SUB
 WHERE MP.PlanName = SUB.PlanName AND SUB.MIN = LMU.MIN AND Data LIKE 'Unlimited'
 AND City = 'Bellevue' 
 ORDER BY DataInMB DESC;

 -- D
 -- This searches for any users using the unlimited data plan in Seattle, one of the top three cities in terms of data usage.
 -- If there are any results, the city is disqualified from our search
 SELECT DataInMB, City, Data AS DataPlan
 FROM MPlan AS MP, LastMonthUsage AS LMU, Subscriber AS SUB
 WHERE MP.PlanName = SUB.PlanName AND SUB.MIN = LMU.MIN AND Data LIKE 'Unlimited'
 AND City = 'Seattle'
 ORDER BY DataInMB DESC;

 /*
 As we see, Bellevue, although being one of the top three cities in terms of data usage doesn't 
 have anyone using the unlimited dataplan. 
 */

 -- Looking at the results, bellevue is both in the top three in terms of data usage and has noone using the unlimited plan. 

 -- 4 --
 -- A
 -- This finds the first and last name of the customer who has the most expensive bill each month

 SELECT TOP 1 CONCAT(FirstName, ' ', LastName) AS UserName_HighestBill
 FROM Subscriber AS SUB, Bill AS B
 WHERE SUB.MIN = B.MIN
 ORDER BY Total DESC;

 -- B
 -- This shows which mobile plan brings in the most revenue each month

SELECT TOP 1 MP.PlanName, SUM(Total) AS PlanRevenue
FROM MPlan AS MP, Bill AS B, Subscriber AS SUB
WHERE MP.PlanName = SUB.PlanName AND SUB.MIN = B.MIN
GROUP BY MP.PlanName
ORDER BY PlanRevenue DESC;

-- 5 --
-- A
-- This query returns which area code uses the most minutes.

SELECT TOP 1 LEFT(MDN, 3) AS AreaCode, SUM(Minutes) AS MinutesByA_C
FROM Subscriber AS SUB, LastMonthUsage AS LMU
WHERE LMU.MIN = SUB.MIN
GROUP BY LEFT(MDN, 3)
ORDER BY MinutesByA_C DESC;

-- B
-- This query returns cities that have customers who have used less than 200 minutes, and customers with more than 700 minutes.
SELECT DISTINCT City
FROM LastMonthUsage AS LMU, Subscriber AS SUB
WHERE LMU.MIN = SUB.MIN AND Minutes NOT BETWEEN 200 AND 700;