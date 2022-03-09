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

/*
Query #12: How long did the customers stay with films?
*/
SELECT 
	customer_id,
    -- rental period for each customer per rental in days
    DATEDIFF(return_date, rental_date) AS rental_period
FROM rental;

/*
Query #13: Which customers exceeded the duration of rentals?
*/
SELECT 
	c.customer_id,
    first_name,
    last_name,
    email
FROM customer AS c
INNER JOIN rental AS r
	ON c.customer_id = r.customer_id
INNER JOIN inventory AS i
	ON r.inventory_id = i.inventory_id 
INNER JOIN film AS f
	ON i.film_id = f.film_id
WHERE DATEDIFF(return_date, rental_date) > rental_duration;

/*
Query #14: Which customers have exceeded the duration of rental over ten times? 
*/
-- CTE to create customers who exceed rental duration
WITH exceed_rentals AS
	(SELECT 
		c.customer_id,
		first_name,
		last_name,
		email
	FROM customer AS c
	INNER JOIN rental AS r
		ON c.customer_id = r.customer_id
	INNER JOIN inventory AS i
		ON r.inventory_id = i.inventory_id 
	INNER JOIN film AS f
		ON i.film_id = f.film_id
	WHERE DATEDIFF(return_date, rental_date) > rental_duration)

SELECT
	customer_id,
    first_name,
    last_name,
    -- Count number of rental exceedings from each customer
    COUNT(customer_id) AS num_rental_exceedings
FROM exceed_rentals
GROUP BY customer_id, first_name, last_name
HAVING COUNT(customer_id) > 10
ORDER BY num_rental_exceedings DESC;

/*
Query #15: What is the location of these defaulters above?
*/
SELECT 
	c.customer_id,
    address,
    city,
    country
FROM customer AS c
INNER JOIN rental AS r
	ON c.customer_id = r.customer_id
INNER JOIN inventory AS i
	ON r.inventory_id = i.inventory_id 
INNER JOIN film AS f
	ON i.film_id = f.film_id
INNER JOIN address AS a
	ON c.address_id = a.address_id
INNER JOIN city AS ci
	ON a.city_id = ci.city_id
INNER JOIN country AS co
	ON ci.country_id = co.country_id
WHERE DATEDIFF(return_date, rental_date) > rental_duration;

