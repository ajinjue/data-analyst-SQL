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
       - Number of active customers: Customer engagement.
*/

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
    -- total amount paid for rental 
    SUM(p.amount) AS total_revenue
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
	ON r.rental_id = p.rental_id;
    
/*
Query #4: What is the total revenue generated per month from the rental service?
*/
SELECT
	-- Extract months of the year
    EXTRACT(MONTH FROM rental_date) AS rental_month,
    -- total amount paid for rental in each category
    SUM(p.amount) AS total_revenue
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
GROUP BY rental_month
ORDER BY total_revenue DESC;






