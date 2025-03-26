create database Human_Resources;
use Human_resources;

select * from hr;

-- DATA CLEANING

-- Rename id column to emp_id
ALTER TABLE hr
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;


-- Check data types of all columns
DESCRIBE hr;



SELECT birthdate FROM hr;


-- Change birthdate values to date
UPDATE hr
SET birthdate = CASE
	WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;


-- Change birthdate column datatype
ALTER TABLE hr
MODIFY COLUMN birthdate DATE;



-- Convert hire_date values to date
UPDATE hr
SET hire_date = CASE
	WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;


-- Change hire_date column data type
ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

SELECT termdate FROM hr WHERE termdate = '' OR termdate IS NULL;

UPDATE hr 
SET termdate = NULL 
WHERE termdate = '';

SELECT termdate FROM hr 
WHERE STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC') IS NULL 
AND termdate IS NOT NULL AND termdate != '';

ALTER TABLE hr
MODIFY COLUMN termdate DATE;

ALTER TABLE hr ADD COLUMN age INT;

UPDATE hr
SET age = timestampdiff(YEAR, birthdate, CURDATE());

SELECT 
	min(age) AS youngest,
    max(age) AS oldest
FROM hr;

SELECT count(*) FROM hr WHERE age < 18;

SELECT COUNT(*) FROM hr WHERE termdate > CURDATE();

SELECT location FROM hr;


-- EXPLORATORY DATA ANALYSIS



-- gender breakdown of employees in the company
SELECT gender, COUNT(*) AS count
FROM hr
WHERE age >= 18
GROUP BY gender;



-- race/ethnicity breakdown of employees in the company
SELECT race, COUNT(*) AS count
FROM hr
WHERE age >= 18
GROUP BY race
ORDER BY count DESC;



-- age distribution of employees in the company
SELECT 
  MIN(age) AS youngest,
  MAX(age) AS oldest
FROM hr
WHERE age >= 18;

SELECT FLOOR(age/10)*10 AS age_group, COUNT(*) AS count
FROM hr
WHERE age >= 18
GROUP BY FLOOR(age/10)*10;



SELECT 
  CASE 
    WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
    ELSE '65+' 
  END AS age_group, 
  COUNT(*) AS count
FROM 
  hr
WHERE 
  age >= 18
GROUP BY age_group
ORDER BY age_group;



SELECT 
  CASE 
    WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
    ELSE '65+' 
  END AS age_group, gender,
  COUNT(*) AS count
FROM 
  hr
WHERE 
  age >= 18
GROUP BY age_group, gender
ORDER BY age_group, gender;



-- employees work at headquarters versus remote locations
SELECT location, COUNT(*) as count
FROM hr
WHERE age >= 18
GROUP BY location;



-- average length of employment for employees who have been terminated
SELECT ROUND(AVG(DATEDIFF(termdate, hire_date)),0)/365 AS avg_length_of_employment
FROM hr
WHERE termdate <= CURDATE() AND age >= 18;



-- gender distribution vary across departments and job titles
SELECT department, gender, COUNT(*) as count
FROM hr
WHERE age >= 18
GROUP BY department, gender
ORDER BY department;
 
 
 
-- distribution of job titles across the company
SELECT jobtitle, COUNT(*) as count
FROM hr
WHERE age >= 18
GROUP BY jobtitle
ORDER BY jobtitle DESC;



-- distribution of employees across locations by city and state
SELECT location_state, COUNT(*) as count
FROM hr
WHERE age >= 18
GROUP BY location_state
ORDER BY count DESC;

