-- Create a file named 3.11_more_exercises.sql to do your work in. Write the appropriate USE statements to switch databases as necessary.

-- Employees Database
-- 1. How much do the current managers for each department get paid, relative to the average for the department? Is there any department where the department manager gets paid LESS than the average salary?
USE employees;

SELECT a.dept_name as department_name, d.dept_no as dept_no, a.dmsal as dm_salary, AVG(salary) as avg_salary
FROM salaries as s
JOIN dept_emp as de using (emp_no)
JOIN departments as d using (dept_no)
LEFT JOIN (SELECT salary as dmsal, d.dept_name
	  FROM salaries as s 
	  JOIN dept_manager as dm using (emp_no)
	  JOIN departments as d using (dept_no)
	  WHERE dm.emp_no = s.emp_no AND s.to_date = '9999-01-01' AND dm.to_date = '9999-01-01') as a ON (a.dept_name = d.dept_name)
WHERE s.to_date = '9999-01-01' AND de.to_date = '9999-01-01'
GROUP by a.dept_name, a.dmsal,d.dept_no
ORDER BY dmsal;

-- World Database
-- Use the world database for the questions below.

USE world;

-- What languages are spoken in Santa Monica?

SELECT language, percentage
FROM countrylanguage
JOIN city using(CountryCode)
WHERE CountryCode Like 'USA'
GROUP BY language, percentage
ORDER BY percentage;

 -- How many different countries are in each region?
 
 SELECT region, count(name) as num_countries
 FROM country
 GROUP by region
 ORDER BY num_countries;
 
 -- What is the population for each region?
 
 SELECT region, SUM(population) as population
 FROM country
 GROUP by region
 ORDER by population DESC;
 
 -- What is the population of each continent?
 
 SELECT continent, SUM(population) as population
 FROM country
 GROUP BY continent
 ORDER by population DESC;
 
 -- What is the average life expectancy globally?
 SELECT AVG(LifeExpectancy)
 FROM country;
 
 -- What is the average life expectancy for each region, each continent? Sort the results from shortest to longest
 
 SELECT region, AVG(LifeExpectancy) as life_expectancy
 FROM country
 GROUP BY region
 ORDER BY life_expectancy ASC;
 
 SELECT continent, AVG(LifeExpectancy) as life_expectancy
 FROM country
 GROUP BY continent
 ORDER BY life_expectancy;
 
 -- BONUS
 -- Find all the coutries whose local name is different from the official name
 
 SELECT Name as country, LocalName
 FROM country
 WHERE Name Not Like LocalName;
 
 -- How many countries have a life expectancy less than X?
 SELECT COUNT(LifeExpectancy)
 FROM country
 WHERE LifeExpectancy < (SELECT AVG(LifeExpectancy) FROM country)
ORDER BY LifeExpectancy DESC;

 -- What state is city x located in?
 SELECT Name, District
 From city
 WHERE Name Like 'Santa Monica';
 
 SELECT Name,District
 From city
 ORDER BY District;
 
 -- What region of the world is city x located in?
 SELECT city.Name, Region
 FROM city
 LEFT JOIN country as cntry
 	ON (city.CountryCode = cntry.code)
 WHERE city.NAME LIKE 'Austin';
 
 -- Extra: ALL city's with their regions.
 
SELECT c.Name, Region
 FROM city as c
 LEFT JOIN country as cntry
 	ON (c.CountryCode = cntry.code);
 	
-- What country (use the human readabel name) is city x located in?

SELECT c.Name as city, cntry.Name as country
FROM city as c
LEFT JOIN country as cntry 
	 ON (c.CountryCode = cntry.code);
	 
SELECT c.Name as city, cntry.Name as country
FROM city as c
LEFT JOIN country as cntry
	ON (c.CountryCode = cntry.code)
WHERE c.Name LIKE 'Kabul';

-- What is the life expectancy in city x?

SELECT c.Name, LifeExpectancy
FROM city as c
LEFT JOIN country as cntry
	ON (cntry.code = c.CountryCode);

SELECT c.Name, LifeExpectancy
FROM city as c
LEFT JOIN country as cntry
	ON (cntry.code = c.CountryCode)
WHERE c.NAME LIKE 'Kabul';

-- Sakila Database
USE sakila;

-- 1. Display the first and last names in all lowercase of all the actors.

SELECT lower(CONCAT(first_name, ' ',last_name)) as full_name
FROM actor;

-- 2. You need to find the ID number, first name, and last name of an actor, of whom you only know the first name, "Joe." What is one query you could use to obtain this information?

SELECT actor_id, CONCAT(first_name, ' ', last_name) as full_name
FROM actor
WHERE first_name LIKE '%Joe%';

-- 3. Find all actors whose last name contain the letters "gen".

SELECT first_name as FirstName, last_name as LastName
FROM actor
WHERE last_name LIKE '%gen%';

-- 4. Find all actors whose last names contain the letters 'li'. This time, order the rows by last name and first name, in that order.

SELECT first_name as FirstName, last_name as LastName 
From actor
WHERE last_name Like '%li%'
ORDER BY last_name, first_name;

-- 5. Using In, display the country_id and country columns for the following countries: Afghanistan, Bangladesh, and China.

SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 6. List the names of all the actors, as well as how many actors have that last name;

SELECT last_name as LastName, count(last_name)
from actor
GROUP BY last_name;

-- ****(HELP/COMPLETE)7. List last names of actors and the number of actors who have that last name, but only for names shared by at least two actors.

SELECT last_name as LastName, count(last_name) as count
FROM actor
GROUP BY last_name;

SELECT count(last_name) as count, last_name
FROM actor
GROUP BY last_name
HAVING count >= 2 ;

-- 8. You cannot locate the schemea of the address table. Which query would you use to re-create it?

USE bayes_826;
CREATE TABLE `address` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`)
  ) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;

CREATE TEMPORARY TABLE address2 (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`)
  ) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;
 

-- 9. Use JOIN to display the first and last names, as well as the addess, of each staff member.

USE sakila;

SELECT CONCAT(first_name, ' ', last_name) as full_name, address, city, country, a.postal_code
FROM staff as s
JOIN address as a using (address_id)
JOIN city as c using (city_id)
JOIN country as cntry using (country_id);

-- USE JOIN to display the total amount rung up by each staff member in August of 2005.

SELECT CONCAT(first_name, ' ', last_name) as full_name, SUM(amount) as total_payment
FROM staff
JOIN payment using(staff_id)
WHERE payment_date BETWEEN '2005-08-01' AND '2005-08-31'
GROUP BY staff_id;

-- 11. List each film and the number of actors who are listed for that film

SELECT title, count(actor_id)
FROM film_actor
RIGHT JOIN film using(film_id)
GROUP BY title;

-- 12. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT title, count(film_id) as inventory_amount
FROM film
LEFT JOIN inventory using (film_id)
GROUP BY title
HAVING title LIKE 'Hunchback Impossible';

-- 13. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in populartiy. Use the subqueries to display the titles of movies starting with the letters K and Q whose language is English.

SELECT kq.title
FROM film as f
JOIN (SELECT title, film_id FROM film WHERE title LIKE 'K%' or  title LIKE 'Q%') as kq ON kq.film_id = f.film_id
;

-- 14. Use the subqueries to display all actors who appear in the film Alone Trip

SELECT CONCAT(first_name, ' ', last_name) as full_name
FROM actor
LEFT JOIN film_actor using (actor_id)
LEFT JOIN film using (film_id)
WHERE title LIKE (SELECT title FROM film WHERE title LIKE 'Alone Trip');

-- 15. You want to run an email marketing campaign in Canada for which you will need the names and email address of all Canadian customers.

SELECT CONCAT(first_name, ' ', last_name) as full_name, email
FROM customer as c
JOIN address as a using(address_id)
JOIN city using (city_id)
JOIN country using (country_id)
WHERE country = 'Canada';

-- 16. Sales have been laggin amoung young families, and you wish to target all family movies for a promotion. Identify all moves catagorized as family films.

SELECT title
FROM film
JOIN film_category using (film_id)
JOIN category using (category_id)
WHERE name = 'family';

-- 17. Write a query to display how much business, in dollars each store brought in.

SELECT SUM(amount)
FROM payment
JOIN staff using (staff_id)
JOIN store ON (manager_staff_id = staff_id)
GROUP BY store.store_id;

-- 18. Write a query to display for each store it's store ID, city, and country.

SELECT store_id, city, country
FROM store
JOIN address using (address_id)
JOIN city using (city_id)
JOIN country using (country_id);

-- 19. List the top five genres in gross revenue in decending order. (Hint: you make need to use the following tables: category, film_category, inventory, payment, and rental)
USE sakila;

SELECT name as category, SUM(amount) as gross_revenue
FROM category
JOIN film_category using (category_id)
JOIN inventory using (film_id)
JOIN rental using (inventory_id)
JOIN payment using (rental_id)
GROUP BY category
ORDER BY gross_revenue DESC
LIMIT 5;

-- 1. SELECT statements
-- a. Select all columns from the actor table.

SELECT * FROM actor;

-- b. Select only the last_name from the actor table.

SELECT last_name FROM actor;

-- c. Select only the following columns from the film table.

SELECT title, release_year FROM film;

-- 2. DISTINCT operator

-- a. Select all distinct (different) last names from the actor table.

SELECT DISTINCT last_name from actor;

-- b. Select all distinct (different) postal codes from the address table.

SELECT DISTINCT postal_code from address;

-- c. Select all distinct (different) ratings from the film table.

SELECT DISTINCT rating from film;

-- 3. WHERE clause

-- a. Select the title, description, rating, movie length columns from the films table that last 3 hours or longer. 

SELECT title, description, rating, length
FROM film
WHERE length >= 180;

-- b. Select the payment id, amount, and payment date columns from the payment table for payments made on 05/27/2005.

SELECT payment_id, amount, payment_date
FROM payment
WHERE payment_date >= '2005-05-27';

-- c. Select the primary key, amount, and payment date columns from the payment table for payments made on 05/27/2005.

DESCRIBE payment;

SELECT payment_id,  amount, payment_date
FROM payment
WHERE payment_date LIKE '%2005-05-27%';

-- d. Select all columns from the customer table for rows that have a last name beginning with S and a first name ending with N.

SELECT *
FROM customer
WHERE last_name LIKE 'S%' and first_name LIKE '%N';

-- e. Select all columns from the customer table for rows where the customer is inactive or has a last name beginning with "M"

SELECT *
FROM customer 
WHERE active = 0 and last_name LIKE 'M%';

-- f. Select all columns from the category table for rows where the primary key is greater than 4 and the name filed begins with either C,S, or T.

DESCRIBE category;

SELECT * 
FROM category
WHERE category_id > 4 and (name LIKE 'C%'or name LIKE 'S%'or name LIKE'T%');

-- (HELP)g. Select all columns minus the password column from the staff table for rows that contain a password.

SELECT *
FROM staff
WHERE ISNULL(password);

-- (HELP) h. Select all columns minus the password column from the staff table for rows that do not contrain a password.

SELECT *	
FROM staff
WHERE NOT ISNULL(password);

-- 4. In Operator

-- a. Select the phone and district columns from the address table for addresses in California, England, Taipaie, or West Java.

SELECT phone, district
FROM address
WHERE district IN ('California', 'England', 'Taipei', 'West Java');

-- b. Select the payment id, amount, and payment date columns from the payment table for payments made on 05/25/2005, 05/27/2005, and 05/29/2005 (Use the IN operator as in previous exercises.)

SELECT payment_id, amount, payment_date
FROM payment
WHERE date(payment_date) IN ('2005-05-25', '2005-05-27', '2005-05-29')
ORDER BY payment_date;

-- c. Select all columns from the film table for films rated G, PG-13, or NC-17

SELECT * 
FROM film
WHERE rating IN ('G','PG-13','NC-17');

-- 5. BETWEEEN operator

-- a. Select all columns from the payment table for payments made between midnight 05/25/2005 and 1 second before midnight 05/26/2005;

SELECT *
FROM payment
WHERE date(payment_date) BETWEEN '2005-05-25' AND '2005-05-25 23:59:59';

-- b. Select the following columns from the film table for films where the length of the description is between 100 and 120

USE sakila;

SELECT title, description
FROM film
WHERE length(description) BETWEEN 100 AND 120;

-- 6. LIKE operator

-- a. Select the following columns from the film table for rows where the description begins with "A Thoughtful".

SELECT title, description
FROM film
WHERE description LIKE 'A thoughtful%';

-- b. Select the following columns for the film table for rows where the description ends with the word 'Boat'.

SELECT title, description
FROM film
WHERE description LIKE '%Boat';

-- c. Select the following columns from the film where the description contains the word "Database" and the length of the film is greater than 3 hours.

SELECT title, description, length
FROM film
WHERE description LIKE '%Database%' and length > 180;

-- 7. LIMIT Operator

-- a. Select all columns from the payment table and only include the first 20 rows.

SELECT *
FROM payment
LIMIT 20;

-- b. Select the payment date and amount columns from the payment table for rows where the payment amount is greater than 5, and only select rows whose zero-based index in the result set is between 1000 and 2000.

SELECT payment_id,payment_date, amount
FROM payment
WHERE amount > 5
ORDER BY payment_id ASC
LIMIT 1001 OFFSET 999
;

-- c. Select all columns from the customer table, limiting results to those where the zero-based index is between 101-200.

SELECT * 
FROM customer
LIMIT 100 offset 100;

-- 8. ORDER BY statement

-- a. Select all columns from the film table and order rows by the length of the field in ascending order.
USE sakila;

SELECT *
FROM film
ORDER BY length;

-- b. Select all distinct ratings from the film table ordered by rating in descending order.
SELECT DISTINCT rating
FROM film
ORDER BY rating DESC;

-- c. Select the payment date and amount columns from the payment table for the first 20 payments ordered by payment amount in descending order.

SELECT payment_date, amount
FROM payment
ORDER BY amount DESC
LIMIT 20;

-- d. Select the title, description, special features, length, and rental duration columns from the film table for the first 10 films with behind the scenes footage under 2 hours in length and a rental duration between 5 and 7 days, ordered by length in descending ordered

SELECT title, description, special_features, length, rental_duration
FROM film
WHERE special_features LIKE '%Behind%' AND (length < 120) AND rental_duration BETWEEN 5 AND 7
ORDER BY length DESC
LIMIT 20;

-- 9. JOIN s

-- a. Select customer first_name/last_name and actor first_name/last_name columns from performing a LEFT JOIN between the customer and actor column on the last_name column in each table. (i.e. customer.last_name = actor.last_name).
	 -- Label customer first_name/last_name columns as customer_first_name/customer_last_name
	 -- Label actor first_name/last_name in a similar fashion.
	 -- returns correct number of records: 599.
	 
SELECT c.first_name as customer_first_name, c.last_name as customer_last_name, a.first_name as actor_first_name, a.last_name as actor_last_name
FROM customer as c
LEFT JOIN actor as a ON (a.last_name = c.last_name)
;

SELECT
		c.first_name cust_first_name
		,c.last_name cust_last_name
		,a.first_name actor_first_name
		,a.last_name actor_last_name
	FROM
		customer c
	 LEFT JOIN
		actor a
		using(last_name)
	;

-- b. Select the customer first_name/last_name and actor first_name/last_name columns from performing a /right join between the customer and actor column on the last_name column in each table. (i.e. customer.last_name = actor.last_name). Returns correct number of records: 200.

USE sakila;

SELECT c.first_name as customer_first_name, c.last_name as customer_last_name, a.first_name as actor_first_name, a.last_name as actor_last_name
FROM customer  c
RIGHT JOIN actor a ON (c.last_name = a.last_name);

-- c. Select the customer first_name/last_name and actor first_name/last_name columns from performing an inner join between the customer and actor column on the last_name column in each table (i.e. customer.last_name = actor.last_name). Returns correct number of records:43

SELECT c.first_name as customer_first_name, c.last_name as customer_last_name, a.first_name as actor_first_name, a.last_name as actor_last_name
FROM customer as c
JOIN actor as a ON (c.last_name = a.last_name);

-- d. Select the title, description, release_year, and language name columns from the film table, performing a left join with the language table to get the "language" column. 
	-- Label the language.name column as "language"
	-- Returns 1000 rows
	
SELECT title, description, release_year, name
FROM film f
LEFT JOIN language l ON (l.language_id = f.language_id);

-- f. Select the first_name, last_name, address, address2, city name, district, and postal code columns from the staff table, performing 2 left joins with the address table then the city table to get the address and city related columns. Returns 2 rows.

SELECT first_name, last_name, address, address2, city, district, postal_code
FROM staff as s
LEFT JOIN address using (address_id)
LEFT JOIN city using (city_id);

-- 1. What is the average replacement cost of a film? Does this change depending on the rating of the film?
SELECT AVG(replacement_cost)
FROM film;

SELECT rating, AVG(replacement_cost)
FROM film
GROUP BY rating;

-- 2. How many different films of each genre are in the datbase?

SELECT name, COUNT(title)
FROM film AS f
JOIN film_category AS fc ON (fc.film_id = f.film_id)
JOIN category as c ON (c.category_id = fc.category_id)
GROUP BY name;

-- 3. What are the 5 frequently rented films?

SELECT title, COUNT(rental_id) as total
FROM film as f
LEFT JOIN inventory as i using (film_id)
LEFT JOIN rental as r using (inventory_id)
GROUP BY title
ORDER BY total DESC, title
LIMIT 7;

-- 4. What are the most profitable films (in terms of gross revenue)?

SELECT title, SUM(amount) as total
FROM film
JOIN inventory using(film_id)
JOIN rental using(inventory_id)
JOIN payment using(rental_id)
GROUP BY title
ORDER BY total DESC
LIMIT 5;

-- 5. Who is the best customer?

SELECT CONCAT(first_name, ' ', last_name) as name, SUM(amount) as total
FROM customer
JOIN payment using (customer_id)
GROUP BY name
ORDER BY total DESC
LIMIT 1;

-- 6. Who are the most popular actors (that have appeared in the most films?)

SELECT CONCAT(first_name, ' ', last_name) as actor_name, COUNT(*) as total
FROM film_actor
JOIN actor using (actor_id)
GROUP BY actor_id
ORDER BY total DESC
LIMIT 5;
 
-- 7. What are the sales for each store for each month in 2005

USE sakila;

SELECT SUBSTRING(payment_date,1,7) as month, store_id, SUM(amount)
FROM inventory as i
JOIN rental as r using (inventory_id)
JOIN payment as p using (rental_id)
WHERE year(payment_date) = 2005
GROUP BY month, store_id;

-- BONUS: Find the film title, customer name, customer phone number, and customer address for all the outstanding DVDs.

USE sakila;

SELECT title, CONCAT(last_name, ', ', first_name), phone, address
FROM film
JOIN inventory using (film_id)
JOIN rental using (inventory_id)
JOIN customer using (customer_id)
JOIN address using (address_id)
WHERE ISNULL(return_date);










 
	
	









