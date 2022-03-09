/* Objectives of Data Driven Decision making
	Short term: Information for operational decisions e.g
	   - Popularity of actors to decide which movies to invest in.
           - Revenue of the last months to estimate budget for short term investments.
	Long term: Information for strategic decisions or planning e.g
	   - Success across countries to decide on market extensions.
           - Development of revenue for long term investments.
		
    KPIs: Key Performance Indicators
    Extracting information from the data which is relevant to measure the success of the film rental service. e.g
       - Total number of rentals: revenue
       - Customer satisfaction
       - Number of active customers: Customer engagement. */

/*
Query #1: What is the total number of rentals?
*/
SELECT 
   -- Count the number of times renting of films took place
   COUNT(*) AS num_of_rentals
FROM rental;

/*
Query #2 What is the total number of rentals per month?
*/
SELECT
   -- Extract the months of the year
   EXTRACT(MONTH FROM rental_date) AS rental_month,
   -- Count the number of times renting took place per month
   COUNT(rental_date) AS num_of_rentals
FROM rental
GROUP BY rental_month
ORDER BY rental_month DESC;

/* 
Query #3: What is the total revenue generated from this rental service?
*/
SELECT
   -- Sum total amount paid in
   SUM(amount) AS total_revenue
FROM payment;
    
/*
Query #4: What is the total revenue generated per month from the rental service?
*/
SELECT
	-- Extract months of the year
    EXTRACT(MONTH FROM rental_date) AS rental_month,
    -- total amount paid for rental in each category
    SUM(p.amount) AS total_revenue
FROM rental AS r
INNER JOIN payment AS p
	ON r.rental_id = p.rental_id
GROUP BY rental_month
ORDER BY total_revenue DESC;

/*
Query #5: What is the total revenue generated per country for this service?
*/
SELECT 
    country,
    -- Sum of payment from each country
    SUM(amount) AS total_revenue
FROM customer AS c
INNER JOIN rental AS r
	ON c.customer_id = r.customer_id
INNER JOIN address AS a
	ON c.address_id = a.address_id
INNER JOIN city AS ci
	ON a.city_id = ci.city_id
INNER JOIN country AS co
	ON ci.country_id = co.country_id
INNER JOIN payment AS p
	ON r.rental_id = p.rental_id
GROUP BY country
ORDER BY total_revenue DESC;

/*
Query #6: Number of customers per country
*/
SELECT 
    country,
    -- Count number of unique customers from each country
    COUNT(DISTINCT c.customer_id) AS num_of_customers 
FROM customer AS c
INNER JOIN rental AS r
	ON c.customer_id = r.customer_id
INNER JOIN address AS a
	ON c.address_id = a.address_id
INNER JOIN city AS ci
	ON a.city_id = ci.city_id
INNER JOIN country AS co
	ON ci.country_id = co.country_id
INNER JOIN payment AS p
	ON r.rental_id = p.rental_id
GROUP BY country
ORDER BY num_of_customers DESC;

/*
Query #7: Number of films by category and their average price for categories with more than two movies
*/
SELECT 
    name AS category,
    -- Number of unique films per category
    COUNT(DISTINCT f.film_id) AS num_of_films,
    -- Average price of films per category
    ROUND(AVG(rental_rate), 2) AS avg_price
FROM film AS f
INNER JOIN film_category AS fc
    ON f.film_id = fc.film_id
INNER JOIN category AS c
    ON fc.category_id = c.category_id
GROUP BY name
HAVING COUNT(DISTINCT f.film_id) > 2
ORDER BY num_of_films DESC;

/*
Query #8: Popularity of actors in films
*/
-- Get the actors in films
WITH film_actors AS
    (SELECT
        first_name,
        last_name,
        f.film_id
    FROM actor AS a
    INNER JOIN film_actor AS fa
        ON a.actor_id = fa.actor_id
    INNER JOIN film AS f
        ON fa.film_id = f.film_id)
-- Count how often an actor feature in different films
SELECT
    first_name,
    last_name,
    COUNT( DISTINCT film_id) AS popularity
FROM film_actors
GROUP BY first_name, last_name
ORDER BY popularity DESC;

/*
Query #9: List films whose rental rate is greater or equal to $3 and are of the sports category
*/
SELECT
    name AS category,
    title,
    rental_rate
FROM film AS f
INNER JOIN film_category AS fc
    ON f.film_id = fc.film_id
INNER JOIN category AS c
    ON fc.category_id = c.category_id
WHERE rental_rate >= 3.0 AND name = 'Sports'

    
    





