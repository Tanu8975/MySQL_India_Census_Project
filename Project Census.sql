USE project_sensus;

SELECT * FROM dataset1;
SELECT * FROM dataset2;

-- Q1) How many rows are present in the table dataset1?
SELECT count(*) FROM dataset1; 
-- Total 640 rows are present in the table dataset1.



-- Q2) How many rows are present in the table dataset2?
SELECT count(*) FROM dataset2;
-- Total 640 rows are present in the table dataset2.



-- Q3) Extract the information from dataset1 for 2 states named Jharkhand and Bihar.
SELECT * FROM dataset1
 WHERE state in ('Jharkhand', 'Bihar');



-- Q4) Calculate the total population of India from table dataset2.
SELECT * FROM dataset2;
SELECT round(sum(Population), 0) as Popoulation FROM dataset2;
-- Total Population of India is around 13175



-- Q5) What is the average growth displayed by India as compared to the previous census conducted?
SELECT*FROM dataset1;
SELECT avg(Growth)*100 as average_growth FROM dataset1;
-- The average growth of India is around 1924.5921.



-- Q6) What is the average growth percentage of India by statewise.
SELECT State, avg(Growth)*100 as avg_growth FROM dataset1
 GROUP BY State;



-- Q7) What is the average sex ratio of India?
SELECT avg(Sex_Ratio) FROM dataset1;
-- The average sex-ratio of India is around 945.4328



-- Q8) What is the average sex ratio of India as per the state?
SELECT State, round(avg(Sex_Ratio),0) avg_Sex_Ratio FROM dataset1 
GROUP BY State;



-- Q9) Which state has a higest average sex ratio?
SELECT State, round(avg(Sex_Ratio), 0) avg_Sex_Ratio FROM dataset1 
GROUP BY State
 ORDER BY avg_Sex_Ratio DESC;
-- Kerala has the highest average sex ratio with 1080, followed by Puducherry with 1075 and then Uttarakhand with 1010.



-- Q10) Which state has a lowest average sex ratio?
SELECT State, round(avg(Sex_Ratio), 0) avg_Sex_Ratio FROM dataset1 
GROUP BY State 
ORDER BY avg_Sex_Ratio ASC;
-- Dadra and Nagar Haveli has the lowest average sex ratio of 774, followed by Daman and Diu with 783, and the Chandigarh with 818.



-- Q11) Which state has a highest literacy rate?
SELECT * FROM dataset1;
SELECT State, Literacy FROM dataset1 
GROUP BY State 
ORDER BY Literacy DESC;
-- Mizoram has the highest literacy rate of 97.89 followed by the Kerala with 93.57 and Lakshadweep with 91.85.



-- Q12) Which state has a lowest literacy rate?
SELECT State, Literacy FROM dataset1 
GROUP BY State 
ORDER BY Literacy ASC;
-- Bihar has the lowest Literacy rate of 70.68 followed by Orissa with 71.09 and Uttar Pradesh and Assam with 72.32 and 72.37 respectively.



-- Q13) Which state has average literacy rate greater than 90?
SELECT State, round(avg(Literacy), 0) as avg_literacy_ratio FROM dataset1
GROUP BY State HAVING round(avg(Literacy), 0) > 90 ORDER BY avg_literacy_ratio DESC;
-- Kerala and Lakshadweep has average literacy rate greater than 90. 



 -- Q14) Which state has average literacy rate smaller than 40?
 SELECT State, round(avg(Literacy), 0) as avg_literacy_ratio FROM dataset1
 GROUP BY State HAVING round(avg(Literacy), 0) < 65 ORDER BY avg_literacy_ratio ASC;
 -- Bihar and Arunachal Pradesh has average literacy rate less than 65 with 62 and 64 respectively.alter
 
 
 
 -- Q15) Which are the top 3 states which has displayed the highgest average growth rate?
 SELECT State, avg(Growth) as avg_growth FROM dataset1 
 GROUP BY State
 ORDER BY avg_growth DESC
 LIMIT 3;
 -- Nagaland, Dadra and Nagar Haveli and Daman and Diu has displayed the highest average growth rate.
 
 
 
 -- Q16) Which are the bottom 3 states which has displayed the lowest sex ratio.
 SELECT State, round(avg(sex_ratio), 0) as avg_sex_ratio FROM dataset1
 GROUP BY State 
 ORDER BY avg_sex_ratio ASC
 LIMIT 3;
 -- Dadra and Nagar haveli, Daman and Diu and Chandigarh has the lowest sex ratio.
 
 
 
 -- Q17) Displaying bottom and top 3 states in Literacy
 DROP TABLE topstates;
 CREATE TABLE IF NOT EXISTS topstates(
 State VARCHAR(50),
 topstates VARCHAR(50)
 )
 AS
 SELECT State, round(avg(Literacy), 0) as topstates FROM dataset1
 GROUP BY State 
 ORDER BY topstates DESC
 LIMIT 3;
 
 SELECT * FROM topstates ORDER BY topstates DESC;
-- The Kerala has the highest Literacy rate of 94 followed by Lakshadweep with 92 and Goa with 89



-- Q18) Displaying the states with low literacy rate.
CREATE TABLE IF NOT EXISTS bottom_states(
State VARCHAR(50),
bottom_state VARCHAR(50)
)
AS
SELECT State, round(avg(Literacy),0) as bottom_state FROM dataset1
GROUP BY State
ORDER BY bottom_state ASC
LIMIT 3;
SELECT * FROM bottom_states ORDER BY bottom_state ASC;
-- Bihar has the lowest literacy rate of 62 followed by Arunachal Pradesh and Rajasthan with 64 and 65 respectively.



-- Q19) Using union operator to combine the result of both topstates and bottom_states results.
SELECT * FROM(
SELECT State, round(avg(Literacy), 0) as topstates FROM dataset1
 GROUP BY State 
 ORDER BY topstates DESC
 LIMIT 3) as a
UNION
SELECT * FROM (
SELECT State, round(avg(Literacy),0) as bottom_state FROM dataset1
GROUP BY State
ORDER BY bottom_state ASC
LIMIT 3) AS B



-- Q20) Filtering the state whose name starts with letter A
SELECT DISTINCT State FROM dataset1
WHERE lower(State) LIKE 'a%';
-- There are 4 states starting from letter a.



-- Q21) Filtering the state whose name starts with letter A or letter B.
SELECT DISTINCT State FROM dataset1
WHERE lower(State) LIKE 'a%' OR lower(State) LIKE 'b%';



-- Q22) Filtering the state whose name starts with letter A but ending with letter M.
SELECT DISTINCT State FROM dataset1
WHERE lower(State) LIKE 'a%' AND lower(State) LIKE '%m';

-----------------------------------------------------------------------------------------------------------------------
-- Using Statistics for Data Analytics


-- Q23) Calculating the total number of Male and total number of Female.
-- Joining both the table
SELECT a.district, a.State, a.Sex_Ratio, b.Population FROM dataset1 AS a
INNER JOIN
dataset2 as b
ON a.district = b.district

-- Logic behind the Formula:
-- Females/males = sex_ratio ------- 1
-- Females + Males = population ------2
-- Females = Population - Males ------3
-- (Population - Males) = (Sex_Ratio)* Males
-- Population = Males(Sex_Ratio + 1)-------- Males
-- Females = Population - Population/ (Sex_Ratio + 1) ---- Females
-- Females = Population(1 -1 / (Sex_Ratio + 1))
--         = (Population * (Sex_Ratio))/(Sex_Ratio + 1)



SELECT d.state, sum(d.males) as Total_males, sum(d.females) as Total_females FROM 
(SELECT c.district, c.state, round(c.population/(c.sex_ratio + 1), 0) males, round((c.population*c.sex_ratio)/(c.sex_ratio + 1), 0) as Females FROM
(SELECT a.district, a.state, a.sex_ratio/1000  Sex_Ratio, b.population FROM dataset1 as a
INNER JOIN dataset2 as b
ON a.district = b.district) as c) as d
GROUP BY d.state;



-- Q 24) What is the total literacy rate of each state?
-- Total Literate people/ Population = Literacy_ratio
-- Total literate people = Literacy_ratio* Population
-- Total illliterate People = (1 - Literacy_ratio)*Population
SELECT c.State, sum(Literate_People) as Total_Literate_People, sum(illiterate_people) as Total_Illiterate_People FROM
(SELECT d.district, d.State, round(d.Literacy_ratio* d.Population, 0) as Literate_People, round((1-d.Literacy_Ratio)* d.Population, 0) as Illiterate_People FROM
(SELECT a.district, a.State, a.Literacy/ 100 as Literacy_Ratio, b.Population FROM dataset1 AS a
INNER JOIN dataset2 as b
ON a.district = b.district) as d) AS c
GROUP BY c.State;



-- Q25) What was the population in the previous census?
-- For Population:
-- Previous_Census + Growth * Previous_Census = Population
-- Previous_Census = Population/(1+ Growth)

SELECT e.State, e.Previous_Census_Population, e.Current_Census_Population FROM
(SELECT d.district, d.State, d.Population/(1 + d.Growth) as Previous_Census_Population, d.Population as Current_Census_Population FROM
(SELECT a.district, a.State, a.Growth as Growth, b.Population FROM dataset1 AS a
INNER JOIN dataset2 AS b
ON a.district = b.district)d)AS e
GROUP BY e.State;
 
 
 
 -- Q26) What is the total population of India in Previous Census Vs Current Census?
 
 SELECT sum(m.Previous_Census_Population) AS Previous_Census_Population, sum(m.Current_Census_Population) AS Current_Census_Population FROM 
 (SELECT e.State, sum(e.Previous_Census_Population) AS Previous_Census_Population, sum(e.Current_Census_Population) AS Current_Census_Population FROM
(SELECT d.district, d.State, d.Population/(1 + d.Growth) as Previous_Census_Population, d.Population as Current_Census_Population FROM
(SELECT a.district, a.State, a.Growth as Growth, b.Population FROM dataset1 AS a
INNER JOIN dataset2 AS b
ON a.district = b.district)d)AS e
GROUP BY e.State)m;

----------------------------------------------------THE END --------------------------------------------------------------------------

 




