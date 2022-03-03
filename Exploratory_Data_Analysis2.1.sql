/* 
Query #1: Select few rows from the film table
*/
SELECT *
FROM film
LIMIT 5;

/*
Query #2: Count number of rows in the film table
*/
SELECT 
	COUNT(*) AS num_of_rows
FROM film;

/* 
Query #3: Count number of non-null values of the rating column in the film table
*/
SELECT 
	COUNT(rating) 
FROM film;

/* 
Query #4: Count number of distinct  non-null values of the rating column in the film table
*/
SELECT 
	COUNT(DISTINCT rating) AS ratings
FROM film;

/* 
Query #5: List the distinct ratings of the films, including null
*/
SELECT
	DISTINCT rating
FROM film;

/* 
Query #6: Count number of missing values in the rating column
*/
SELECT 
	COUNT(*) - COUNT(rating) AS num_missing_rating
FROM film;

/*
Query #7: The average rental rate of films
*/
SELECT 
	AVG(rental_rate) AS avg_rental_rate
FROM film;

/*
Query #8: The range of rental rate of the films
*/
SELECT
	MAX(rental_rate) - MIN(rental_rate) AS rental_range
FROM film;