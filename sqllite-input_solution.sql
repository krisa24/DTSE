--TASK 1--
--Write query which will match contacts and orders to our customers
SELECT *
FROM customers
         LEFT JOIN orders USING (customer_id)
         LEFT JOIN contacts USING (customer_id);

--TASK 2--
-- There is  suspision that some orders were wrongly inserted more times. Check if there are any duplicated orders. If so, return duplicates with the following details:
-- first name, last name, email, order id and item
WITH possible_duplicates AS
         (
             SELECT customer_id, order_id, item, order_value, order_currency, order_date
             FROM orders
             GROUP BY 1, 2, 3, 4, 5, 6
             HAVING count(*) > 1 --showing duplicates, more than one same row
         )
SELECT first_name, last_name, email, order_id, item
FROM possible_duplicates
         LEFT JOIN customers USING (customer_id)
         LEFT JOIN contacts USING (customer_id)
;

--TASK 3-	
-- As you found out, there are some duplicated order which are incorrect, adjust query from previous task so it does following:
-- Show first name, last name, email, order id and item
-- Does not show duplicates.
-- Order result by customer last name

--as it is requested more times to display unique orders, we will create a view
CREATE VIEW orders_unique AS
SELECT customer_id,
       order_id,
       item,
       order_value,
       order_currency,
       order_date
FROM orders
GROUP BY 1, 3, 4, 5, 6;

SELECT first_name, last_name, email, order_id, item
FROM orders_unique --not showing duplicates
         LEFT JOIN customers USING (customer_id)
         LEFT JOIN contacts USING (customer_id)
ORDER BY last_name ASC
;

--TASK 4--
--Our company distinguishes orders to sizes by value like so:
--order with value less or equal to 25 euro is marked as SMALL
--order with value more than 25 euro but less or equal to 100 euro is marked as MEDIUM
--order with value more than 100 euro is marked as BIG
--Write query which shows only three columns: full_name (first and last name divided by space), order_id and order_size
--Make sure the duplicated values are not shown
SELECT first_name || ' ' || last_name AS full_name,
       order_id,
       CASE
           WHEN order_value <= 25 THEN 'SMALL'
           WHEN order_value > 25 AND order_value <= 100 THEN 'MEDIUM'
           ELSE 'BIG' END             AS order_size
FROM orders_unique --not showing duplicates
         LEFT JOIN customers USING (customer_id)
;

--TASK 5--
-- Show all items from orders table which contain in their name 'ea' or start with 'Key'
SELECT DISTINCT item
FROM orders
WHERE item LIKE '%ea%' --contain ea
   OR item LIKE 'Key%'; --start with Key
;

--TASK 6--
-- Please find out if some customer was referred by already existing customer
-- Return results in following format "Customer Last name Customer First name" "Last name First name of customer who recommended the new customer"     
SELECT c.last_name || ' ' || c.first_name AS "Customer Last name Customer First name",
       r.last_name || ' ' || r.first_name AS "Last name First name of customer who recomended the new customer"
FROM customers c
         LEFT JOIN customers r ON c.referred_by_id = r.customer_id
WHERE c.referred_by_id IS NOT ''; --customer was recommended by someone
;
 

