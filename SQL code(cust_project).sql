drop database market_star_schema;
drop database demonstration;
create database customer_db;
use customer_db;
select*from customer_data;

##1 total revenue 
select gender,sum(purchase_amount) as revenue
from customer_data
group by gender;

##2 
select customer_id,purchase_amount
from customer_data
where discount_applied ='yes' and purchase_amount >=(select avg(purchase_amount)from customer_data);

##3
select item_purchased,
       ROUND(AVG(CAST(review_rating AS DOUBLE)), 2) as "Average Product Rating"
from customer_data
group by item_purchased
order by AVG(CAST(review_rating AS DOUBLE)) desc
limit 5;

##4
select shipping_type,
ROUND(AVG(purchase_amount),2)
from customer_data
where shipping_type in ('Standard','Express')
group by shipping_type;

##5
select subscription_status,
COUNT(customer_id) as total_customers,
ROUND(AVG(purchase_amount),2) as avg_spend,
ROUND(SUM(purchase_amount),2) as total_revenue
from customer_data
group by subscription_status
order by total_revenue, avg_spend desc;

##6
select item_purchased,
ROUND(100 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END)/COUNT(*),2) as discount_rate
from customer_data
group by item_purchased
order by discount_rate desc
limit 5;

##7
with customer_type as (
select customer_id, previous_purchases,
CASE
    WHEN previous_purchases = 1 THEN 'New'
    WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
    ELSE 'Loyal'
END AS customer_segment
from customer_data
)

select customer_segment, count(*) as "Number of Customers"
from customer_type
group by customer_segment;

##8
with item_counts as (
select category,
item_purchased,
COUNT(customer_id) as total_orders,
ROW_NUMBER() over(partition by category order by count(customer_id) DESC) as item_rank
from customer_data
group by category, item_purchased
)

select item_rank, category, item_purchased, total_orders
from item_counts
where item_rank <= 3;

##9
select subscription_status,
count(customer_id) as repeat_buyers
from customer_data
where previous_purchases > 5
group by subscription_status;

##10
select age_group,
SUM(purchase_amount) as total_revenue
from customer_data
group by age_group
order by total_revenue desc;