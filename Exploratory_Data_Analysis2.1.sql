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

/*
Query #9: What are the latest films released?
*/
SELECT 
	title,
    description,
    release_year
FROM film
WHERE release_year = 
			(SELECT MAX(release_year)
			FROM film);

/*
Query #10: Which categories of films were released in 2006?
*/
SELECT 
	f.title,
    c.name
FROM film AS f
INNER JOIN film_category AS fc
	ON f.film_id = fc.film_id
INNER JOIN category AS c
	USING(category_id)
WHERE release_year = 2006;

/* 
Query #11: What are the three most revenue generating film categories?
*/
SELECT
	c.name AS category_name,
    -- total amount paid for rental in each category
    SUM(p.amount) AS revenue
FROM film AS f
INNER JOIN film_category AS fc
	ON f.film_id = fc.film_id
INNER JOIN category AS c
	ON fc.category_id = c.category_id
INNER JOIN inventory AS i
	ON f.film_id = i.film_id
INNER JOIN rental AS r
	ON i.inventory_id = r.inventory_id
INNER JOIN payment AS p
	ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY revenue DESC
LIMIT 3;
