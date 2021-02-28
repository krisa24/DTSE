--TASK 1--
--Write query which will match contacts and orders to our customers
select *
from customers
left join orders using (customer_id)
left join contacts using (customer_id);

--TASK 2--
-- There is  suspision that some orders were wrongly inserted more times. Check if there are any duplicated orders. If so, return duplicates with the following details:
-- first name, last name, email, order id and item
with possible_duplicates as 
	(
	select customer_id, order_id, item, order_value, order_currency, order_date	
	from orders
	GROUP by 1,2,3,4,5,6
	having count (*) > 1 --showing duplicates, more than one same row
    )
Select first_name, last_name, email, order_id, item
from possible_duplicates
	LEFT join customers using (customer_id)
	LEFT join contacts using (customer_id)
;

--TASK 3-	
-- As you found out, there are some duplicated order which are incorrect, adjust query from previous task so it does following:
-- Show first name, last name, email, order id and item
-- Does not show duplicates.
-- Order result by customer last name

--as it is requested more times to display unique orders, we will create a view
Create VIEW orders_unique as 
select 	customer_id,
		order_id,
 		item,
 		order_value,
 		order_currency,
 		order_date
 from orders
 GROUP by 1,3,4,5,6;

Select first_name, last_name, email, order_id, item
from orders_unique --not showing duplicates
	LEFT join customers using (customer_id)
	LEFT join contacts using (customer_id)
Order by last_name ASC
;

--TASK 4--
--Our company distinguishes orders to sizes by value like so:
--order with value less or equal to 25 euro is marked as SMALL
--order with value more than 25 euro but less or equal to 100 euro is marked as MEDIUM
--order with value more than 100 euro is marked as BIG
--Write query which shows only three columns: full_name (first and last name divided by space), order_id and order_size
--Make sure the duplicated values are not shown
Select 	first_name||' '||last_name as full_name,
		order_id,
		case 
        	when order_value <= 25 then 'SMALL'
   			when order_value > 25 and order_value <= 100 then 'MEDIUM'
   			else 'BIG' end as order_size
from orders_unique --not showing duplicates
	LEFT join customers using (customer_id)
;


--TASK 5--
-- Show all items from orders table which containt in their name 'ea' or start with 'Key'
select DISTINCT item
from orders
where item like '%ea%' --contain ea
      or item like 'Key%' --stat with Key
;

--TASK 6--
-- Please find out if some customer was referred by already existing customer
-- Return results in following format "Customer Last name Customer First name" "Last name First name of customer who recomended the new customer"     
selecT c.last_name||' '||c.first_name as "Customer Last name Customer First name",
       r.last_name||' '||r.first_name as "Last name First name of customer who recomended the new customer"
from customers c
LEFT join customers r on c.referred_by_id = r.customer_id
Where c.referred_by_id is not '' --customer was recomended by someone
;
 