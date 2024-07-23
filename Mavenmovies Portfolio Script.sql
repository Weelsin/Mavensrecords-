USE mavenmovies;

-- creating single table queries 
SELECT *
FROM rental;

SELECT *
FROM address;

-- selecting Specific columns 
SELECT customer_id, rental_date
FROM rental;

SELECT first_name, Last_name, email
FROM customer;

-- Running a select Distinct
SELECT distinct rating 
FROM film;

Select distinct rental_duration
FROM Film;

-- Running a where clause
SELECT
customer_id, rental_id, amount, payment_date
FROM payment 
WHERE amount =0.99; 

SELECT
customer_id, rental_id, amount, payment_date
FROM payment 
WHERE payment_date > '2006-01-01'; 

SELECT customer_id, rental_id, amount, payment_date
FROM payment 
WHERE customer_id <= 100;

-- Using WHERE & AND clause
SELECT customer_id,rental_id, amount, payment_date
FROM payment 
WHERE amount= 0.99
AND payment_date > '2006-01-01';

SELECT customer_id,rental_id, amount, payment_date
FROM payment 
WHERE amount > 5
AND payment_date > '2006-01-01';

-- Using WHERE & OR clause
SELECT customer_id,rental_id, amount, payment_date
FROM payment 
WHERE customer_id =5
OR customer_id = 11
OR customer_id =29;

SELECT customer_id,rental_id, amount, payment_date
FROM payment 
WHERE amount > 5
OR customer_id = 53
OR customer_id = 60
OR customer_id = 75
OR customer_id =42;

SELECT customer_id,rental_id, amount, payment_date
FROM payment 
WHERE amount > 5
OR customer_id IN (42,53,60,75);

-- Using LIKE 
SELECT title, special_features
FROM film
WHERE Special_features LIKE '%behind the scenes%';

-- Using GroupBY 
SELECT
rating,
COUNT(film_id) as RTG_COUNT
FROM film
GROUP BY 
rating;

SELECT
rental_duration,
COUNT(film_id) as Films_with_this_rental_duration
FROM film
GROUP BY 
Rental_duration;

SELECT 
rating, rental_duration,
COUNT(film_id) AS count_of_films
FROM film
GROUP BY
rating, rental_duration;


SELECT
 Replacement_cost,
MIN(rental_rate) AS number_of_films,
MAX(rental_rate) AS most_expensive_rental,
AVG(rental_rate) AS avg_rental
FROM film
GROUP BY 
replacement_cost;

-- Using ORDER BY 
SELECT 
customer_id, rental_id, amount, payment_date
FROM payment 
ORDER BY amount DESC;


SELECT
title,
length,
rental_rate
FROM film 
ORDER BY length DESC;


-- CASE STATEMENT 
SELECT DISTINCT
length, 
CASE
WHEN length < 60 THEN 'under 1 hr'
WHEN length BETWEEN 60 and 90 THEN '1-1.5 hrs'
WHEN length > 90 THEN 'over 1.5 hrs'
ELSE 'uh oh...check logic'
END AS length_bucket
FROM film;

SELECT DISTINCT
length, 
CASE
WHEN length < 60 THEN 'under 1 hr'
WHEN length < 90 THEN '1-1.5 hrs'
WHEN length > 120 THEN 'over 2 hrs'
ELSE 'uh oh...check logic'
END AS length_bucket
FROM film;

SELECT DISTINCT 
title,
 CASE 
 WHEN rental_duration <= 4 THEN ' rental_too_short'
 WHEN rental_rate >= 3.99 THEN 'too_expensive'
 WHEN rating IN ('NC-17','R') THEN 'too_adult'
 WHEN length NOT BETWEEN 60 AND 90 THEN 'too_short_or_too_long'
 WHEN description LIKE '%Shakr%;' THEN 'nope_has_sharks'
 ELSE 'Great_recommendation'
 END AS fit_for_recommendation
 FROM film;
 
 SELECT *
 FROM customer ;
 
 SELECT
 Last_name, First_name,
 CASE
 WHEN store_id = 1 AND active = 1 THEN 'Store 1 Active'
 WHEN store_id = 1 AND active = 0 THEN 'store 1 in active'
 WHEN Store_id = 2 AND active = 1 THEN ' store 2 Active'
 WHEN Store_id = 2 AND active = 0 THEN 'store 2 in active'
  ELSE 'Great_recommendation'
  END AS Store_and_status
 FROM customer;
 
SELECT 
film_id,
COUNT(CASE WHEN Store_id = 1 THEN inventory_id ELSE NULL END) AS store_1_copies,
COUNT(CASE WHEN store_id = 2 THEN inventory_id ELSE NULL END) AS store_2_copies, 
COUNT(inventory_id) AS total_copies 
FROM inventory 
GROUP BY 
film_id 
ORDER BY 
film_id;

-- using JOIN
-- INNER JION 

SELECT DISTINCT 
inventory.inventory_id
FROM inventory 
INNER JOIN rental
ON inventory.inventory_id = rental.inventory_id;

SELECT 
inventory_id,
store_id,
Film.title,
film.description

FROM inventory 
INNER JOIN film 
ON inventory.film_id = film.film_id;

-- LEFT JOIN

SELECT 
actor.first_name,
actor.last_name,
COUNT(film_actor.film_id) AS number_of_files
FROM actor
LEFT JOIN film_actor
ON actor.actor_id = Film_actor.actor_id
GROUP BY 
actor.first_name,
actor.last_name;

-- RIGHT JOIN

SELECT 
actor.actor_id,
actor.first_name AS actor_first,
Actor.last_name AS actor_last,
actor_award.first_name AS award_first,
actor_award.last_name AS award_last,
actor_award.awards
FROM actor
RIGHT JOIN actor_award
ON actor.actor_id = actor_award.actor_id 
ORDER BY actor_id;

-- BRIDGING 

USE mavenmovies;
SELECT film.film_id,
film.title,
catrgory.name
FROM film 
INNER JOIN film.category 
ON film.film_id = film_category.film_id
INNER JOIN catrgory
ON film_category.category_id = catergory.category_id;

-- USING UNION

SELECT
'advisor' AS type,
first_name,
last_name
FROM
advisor

UNION
Select
'investor' AS type,
first_name,
last_name
FROM investor;

SELECT 
first_name,
last_name
FROM advisor
 
 UNION
 SELECT 
first_name,
last_name
FROM staff;
 
 
 -- DATA VISUALISATION
 
 -- Table 1 top 10 longest movies
 
 SELECT DISTINCT
 title,length
 From 
 film
 ORDER BY length DESC
 Limit 10 OFFSET 10;
 
 -- Table 2 Number of Inventory per items
 SELECT 
 inventory.store_id,
 film.rating,
 COUNT(inventory_id) AS inventory_items
 FROM inventory
 LEFT JOIN film
 ON inventory.film_id = film.film_id
 GROUP BY inventory.store_id,
 film.rating;
SELECT *
FROM inventory;
-- Table 3 
SELECT
Store_id,
category.name AS category,
COUNT(inventory.inventory_id) AS films,
AVG(film.replacement_cost) AS avg_replacement_cost,
SUM(film.replacement_cost) AS total_replacement_cost

FROM inventory
LEFT JOIN film
ON inventory.film_id = film.film_id
LEFT JOIN film_category
ON film.film_id = film_category.film_id
LEFT JOIn category
ON category.category_id = film_category.category_id

GROUP BY 
store_id,
category.name;

-- Table 4
SELECT 
    payment.rental_id,
    rental.rental_id
FROM
    payment
LEFT JOIN 
    rental ON payment.rental_id = rental.rental_id;
    
-- Table 5
    SELECT 
    rental.rental_id,
    SUM(payment.amount) AS total_payment
FROM
    payment
LEFT JOIN 
    rental ON payment.rental_id = rental.rental_id
GROUP BY 
    rental.rental_id;






