select * from customer;

-- creating a new same data
create table customer_1
like customer;

insert into customer_1
select*
from customer;

select *
from customer_1;

-- total revenue by male and female

select gender, sum(purchase_amount)revenue
from customer_1
group by gender;

-- use discount but still spent more than avg purchase_amount

select customer_id, purchase_amount amount
from customer_1
where discount_applied= 'Yes'and purchase_amount>(select avg(purchase_amount) from customer_1);

-- top 5 product having highest avg rating

select item_purchased, round(avg(review_rating),2)
from customer_1
group by item_purchased
order by 2 desc
limit 5;

-- avg purchase amount between standard and express shipping

select shipping_type, round(avg(purchase_amount),2)
from customer_1
where shipping_type in ('Express','Standard')
group by 1;

-- do suscribed user spend more than avg spend, and total revenue btw sub and non sub

select subscription_status,count(customer_id) total_customer, round(avg(purchase_amount),2) Avg_revenue,sum(purchase_amount)revenue
from customer_1
group by subscription_status;

-- top 5 product with highest % of purchase eith discount

select item_purchased, round(100*sum(case when discount_applied='Yes' then 1 else 0 end)/ count(*),2) discount_rate
from customer_1
group by 1
order by 2 desc limit 5;

-- segment the customer based on their previous puchase onto new,returning and loyal and show count of them all

with cte as(
select customer_id,previous_purchases,
(case 
when previous_purchases= 1 then 'New'
when previous_purchases between 2 and 10 then 'Returning'
else 'Loyal'
end) customer_segment
from customer_1
)
select customer_segment, count(*) as 'Number_of_customer'
from cte
group by customer_segment;

-- top 3 sold product in each catagory

with cte_1 as(
select category,item_purchased,count(customer_id) total_order , 
row_number() over(partition by category order by count(customer_id) desc) item_rank
from customer_1
group by category,item_purchased
)
select item_rank, category,item_purchased,total_order
from cte_1
where item_rank <=3;

-- are customers who repeat buyer(more thwn 5 previous puchase) and likenly to sub

select subscription_status, count(customer_id) repeat_buyer
from customer_1
where previous_purchases >5
group by subscription_status;

-- revenue by age group 

select age_group, sum(purchase_amount) total_revenue
from customer_1
group by age_group
order by 2 desc;














