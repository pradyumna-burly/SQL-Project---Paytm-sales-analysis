--Q1: What does the "Category_Grouped" column represent, and how many unique 
categories are there?

select count(distinct category_grouped)
from paytm_salesdata

--Q2: List the top 5 shipping cities in terms of the number of orders.

select shipping_city,count(*) as order_count
from paytm_salesdata
group by shipping_city
order by order_count desc
limit 5;

--Q3: Show me a table with all the data for products that belong to the "Electronics" category.

select * from paytm_salesdata
where category = 'WATCHES'

--Q4: Filter the data to show only rows with a "Sale_Flag" of 'Yes'.

select * from paytm_salesdata
where sale_flag = 'On Sale'

--Q5: Sort the data by "Item_Price" in descending order. What is the most expensive item?

select * from paytm_salesdata
order by item_price desc
--Most Expensive item?
select item_nm,item_price
from paytm_salesdata
order by item_price desc
limit 1;

--Q6: Calculate the average "Quantity" sold for products in the "Clothing" category, grouped by "Product_Gender."

select product_gender, avg(quantity) as Average_Quantity
from paytm_salesdata
where category_grouped = 'Apparels' and sale_flag = 'On Sale'
group by product_gender

--Q7: Find the top 5 products with the highest "Value_CM1" and "Value_CM2" ratios.

select distinct item_nm,value_cm1,Value_CM2
from paytm_salesdata
order by value_cm1 desc,value_cm2 desc
limit 5;

--Q8: Identify the top 3 "Class" categories with the highest total sales. 

select class,sum(quantity) as Total_sales
from paytm_salesdata
where class <> 'NULL'
group by class
order by sum(quantity) desc
limit 3;

--Q9: Find the total sales for each "Brand" and display the top 3 brands in terms of sales.

select brand,sum(quantity) as Total_sales
from paytm_salesdata
group by brand
order by sum(quantity) desc
limit 3;

--Q10: Calculate the total revenue generated from "Electronics" category products with a "Sale_Flag" of 'Yes'.

select distinct category as Electronics_category,sum(paid_pr) as Total_revenue
from paytm_salesdata
where category = 'WATCHES' and sale_flag = 'On Sale'
group by category

--Q11: Identify the top 5 shipping cities based on the average order value (total sales amount divided by the number of orders) and display their average order values.

select shipping_city,sum(paid_pr)/count(*) as Average_Order_Value
from paytm_salesdata
group by shipping_city
order by sum(paid_pr)/count(*) desc
limit 5;

--Q12: Determine the total number of orders and the total sales amount for each "Product_Gender" within the "Clothing" category.

select product_gender,count(*) as Total_no_of_orders,sum(paid_pr) as Total_sales
from paytm_salesdata
where category_grouped = 'Apparels'
group by product_gender

--Q13: Calculate the percentage contribution of each "Category" to the overall total sales.

with total_sales_overall as
(
    select sum(paid_pr) as total from paytm_salesdata
)
select category,concat(round((sum(paid_pr)/total_sales_overall.total) * 100,2),' %') as Percentage_Contribution
from paytm_salesdata,total_sales_overall
group by category,total_sales_overall.total
order by round((sum(paid_pr)/total_sales_overall.total)*100,2) desc

--Q14: Identify the "Category" with the highest average "Item_Price" and its corresponding average price.

select category,round(avg(item_price),0) as Average_item_price
from paytm_salesdata
group by category
order by avg(item_price) desc
limit 1;

--Q15: Find the month with the highest total sales revenue.
--As there is no date column in the dataset, here I have created new column named sale_date with random dates.  
alter table paytm_salesdata add column sale_date date;

select * from paytm_salesdata
order by s_no

update paytm_salesdata
set sale_date = ('2023-01-01'::date + (random() * 365) * interval '1 day');

select TO_CHAR(sale_date,'Month') as Month,sum(paid_pr) as Total_sales
from paytm_salesdata
group by TO_CHAR(sale_date,'Month')
order by Total_Sales desc
limit 1;

--Q16: Calculate the total sales for each "Segment" and the average quantity sold per order for each segment.
select segment,round(sum(paid_pr),0) as Total_sales,round(avg(quantity),1) as Average_Quantity_Sold
from paytm_salesdata
group by segment
order by  Total_sales desc