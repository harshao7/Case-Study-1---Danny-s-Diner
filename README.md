# Case-Study-1---Danny-s-Diner


create database if not exists DannysDiner;
use DannysDiner;



CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INTEGER
);

INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
  
  select * from sales;

CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');  

 CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);

INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
 
 -- 1. What is the total amount each customer spent at the restaurant?
 
 select s.customer_id, sum(price) total_amount_spent from sales s
	join menu m
		on s.product_id = m.product_id
	group by s.customer_id;
 
-- 2. How many days has each customer visited the restaurant?

select customer_id, count(distinct order_date) customer_visited from sales
group by customer_id;


-- 3. What was the first item from the menu purchased by each customer?

with order_purchased as
	(select distinct customer_id, product_name, row_number() over(partition by customer_id order by order_date) first_time_purchased 
			from sales s 
			join menu m
				on s.product_id = m.product_id)
	select customer_id, product_name from order_purchased
    where first_time_purchased = 1;
    
    
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

select m.product_name, count(s.order_date) most_purchased, s.customer_id from sales s 
	join menu m
		on s.product_id = m.product_id
        group by s.product_id
        order by most_purchased desc
        limit 1;
        
-- 5. Which item was the most popular for each customer?

with most_popular_table as (select s.product_id, m.product_name, count(s.product_id) as most_popular, s.customer_id, 
							row_number() over(partition by s.customer_id order by count(s.product_id) desc )row_num from sales s 
							join menu m
							on s.product_id = m.product_id
							group by  s.product_id, s.customer_id
							order by most_popular desc)
select product_id, product_name, customer_id, most_popular from most_popular_table
		where row_num =1;
        
-- 6. Which item was purchased first by the customer after they became a member?

with cte as (select s.product_id, mem.customer_id, s.order_date, row_number() over(partition by mem.customer_id order by s.order_date) ranking  from members mem
left join sales s        
 on  mem.customer_id = s.customer_id
 Where S.order_date >= Mem.join_date)
 select product_id, customer_id, order_date from cte 
 where ranking = 1;

-- 7. Which item was purchased just before the customer became a member?

with cte as (select s.product_id, mem.customer_id, s.order_date, dense_rank() over(partition by mem.customer_id order by s.order_date) ranking  from members mem
left join sales s        
 on  mem.customer_id = s.customer_id
 Where S.order_date < Mem.join_date)
 select product_id, customer_id, order_date from cte 
 where ranking = 1;

-- 8. What is the total items and amount spent for each member before they became a member?

with cte as (select s.order_date, s.product_id, product_name, price, s.customer_id from sales s
 join menu m 
 on s.product_id = m.product_id
 join members mem
 on s.customer_id = mem.customer_id
 Where S.order_date < Mem.join_date)
 select sum(price) spent_for_each_member, count(product_id) total_items, customer_id from cte
 group by customer_id;
 
 
 SELECT
  sales.customer_id,
  SUM(price) AS spent_for_each_member,
  COUNT(sales.product_id) AS total_items
FROM sales
JOIN menu ON sales.product_id = menu.product_id
JOIN members ON sales.customer_id = members.customer_id
WHERE sales.order_date < members.join_date
GROUP BY customer_id;


-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

with product_points as (select *,
	case 
		when product_name = 'sushi' then price * 20
			else price * 10 
		end as points
	from menu)
	select s.customer_id, sum(p.points) as points from product_points p
    join sales s 
    on p.product_id = S.product_id
    group by s.customer_id;
