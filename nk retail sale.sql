#########################################
-- Project -1 : Retail Sales Analysis -- 
##########################################

-- First we checked excel file to understand the data and column name , so that we can create table according to it.

## creating database
create database if not exists retail_sales_analysis ; 
use retail_sales_analysis ; 

show tables ; 

-- Creating tables
drop table if exists retail_sales ; 
create table retail_sales (
			transactions_id	int	primary key ,
			sale_date	date	,
			sale_time	time	,
			customer_id	int	,
			gender	varchar(15)	,
			age	int	,
			category varchar(50)	,
			quantity	int	,
			price_per_unit float	,
			cogs float	,
			total_sale	float	) ; 
            
            
## in excel file empty cells to replace with Null because while loading excel file directly it will remove the rows which has empty cells 

select * from retail_sales ;
            
-- show tables or describe
show tables ; 

-- checking columns schema of table
describe retail_sales ;
show columns from retail_sales ;            

## inserting data using direct csv file

-- checking data loaded or not
select * from retail_sales ; 
select * from retail_sales limit 10 ; 


## Data pre-processing
-- count total number of rows
select count(*) from retail_sales ; 

-- count unique transaction id 
SELECT COUNT(DISTINCT transactions_id) FROM retail_sales;

-- fetching where transaction id is null
SELECT * FROM retail_sales where
transactions_id is null ; 

-- fetching where sale_date is null
SELECT * FROM retail_sales where
sale_date is null ; 

-- fetching where sale_time is null
SELECT * FROM retail_sales where
sale_time is null ; 

-- fetching where  customer_id is null
SELECT * FROM retail_sales where
customer_id is null ;

 -- fetching where  gender is null
SELECT * FROM retail_sales where
gender is null ;

-- fetching where  age is null
SELECT * FROM retail_sales where
age is null ;

-- fetching where  category is null
SELECT * FROM retail_sales where
category  is null ;

## one query to check whether any ull value in any columns
-- it will show all the column + rows which have null values
select * from retail_sales 
where 
transactions_id is null
or
sale_date is null
or
sale_time is null
or 
customer_id is null 
or 
gender is null 
or
age is null
or 
category is null
or 
quantity is null
or 
price_per_unit is null 
or 
cogs is null
or
total_sale is null ; 

## deleting the rows which has null values.
delete from retail_sales 
where 
transactions_id is null
or
sale_date is null
or
sale_time is null
or 
customer_id is null 
or 
gender is null 
or
age is null
or 
category is null
or 
quantity is null
or 
price_per_unit is null 
or 
cogs is null
or
total_sale is null ; 

-- Now checking after removing null values rows , whether now our data has null cells
select * from retail_sales
where 
transactions_id is null
or
sale_date is null
or
sale_time is null
or 
customer_id is null 
or 
gender is null 
or
age is null
or 
category is null
or 
quantity is null
or 
price_per_unit is null 
or 
cogs is null
or
total_sale is null ; 


-- data exploration
 -- How many sales we have 
 select count(total_sale) from retail_sales ; 
 
 -- How many total unique customers we have
 select count(distinct customer_id) from retail_sales ; 

-- count of categoryies we have
select count(distinct category) from retail_sales ;
 
-- name of distinct categrories
select distinct category from retail_sales ; 

### Data Analysis & Business key problems
select * from retail_sales order by sale_date;

-- Q1 Write a SQL query to retrieve all columns for sales made on '2022-11-05:
select * from retail_sales where sale_date = "2022-11-05" ; 

-- 2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 2 in the month of Nov-2022:
select * from retail_sales
WHERE category = "clothing"
  AND quantity > 2
  AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';
  
-- way-2 --
 select * from retail_sales
WHERE category = "clothing"
  AND quantity > 2
  AND year(sale_date) = 2022 and month(sale_date) = 11 ;
  
-- 3.Write a SQL query to calculate the total sales (total_sale) for each category.:
select category ,sum(total_sale) as Total_Sales from retail_sales group by category ; 

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select category , avg(age) as Average_age from retail_sales where category = "beauty" group by category ; 

-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:
select * from retail_sales where total_sale > 1000 ; 

-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
select gender, category , count(transactions_id) from retail_sales group by category , gender order by category  ;  
select * from retail_sales ;

## imoirtant ##
-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
select year(sale_date) as sale_year , month(sale_date) as sale_month , avg(total_sale) as avg_sale from retail_sales group by 1,2  order by 1 asc, 3 desc ;

-- now we will give rank to highest sale in each year of month
select 
year(sale_date) as sale_year ,            -- we can use "EXTRACT( YEAR FROM sale_data) to extract Year part 
month(sale_date) as sale_month ,          -- we can use "EXTRACT( MONTH FROM sale_data) to extract Month part
avg(total_sale) as avg_sale,
rank() over(partition by year(sale_date) order by avg(total_sale) desc) as ranks   -- in over partition by we can not uses alias of columns , it will give error
from retail_sales 
group by 1,2 ;

-- so till now we provide rank to avg_sales based on year and its month, now our target is to get rank 1 rows from each year
-- so now out task is to filte rank = 1 , but we cannot use WHERE condition on Rank column because it is a window function and it must be filtered using a SUBQUERY OR CTE	
-- applying CTE

select * from
(select 
year(sale_date) as sale_year ,            -- we can use "EXTRACT( YEAR FROM sale_data) to extract Year part 
month(sale_date) as sale_month ,          -- we can use "EXTRACT( MONTH FROM sale_data) to extract Month part
avg(total_sale) as avg_sale,
rank() over(partition by year(sale_date) order by avg(total_sale) desc) as ranks   -- in over partition by we can not uses alias of columns , it will give error
from retail_sales 
group by 1,2 ) as T1
where ranks = 1 ; 

-- 8. Write a SQL query to find the top 5 customers based on the highest total sales
select * from retail_sales ; 
select customer_id , sum(total_sale) as total_sales from retail_sales group by customer_id  order by Total_sales desc limit 5  ; 
select customer_id , sum(total_sale) as total_sales from retail_sales group by 1  order by 2 desc limit 5  ; -- Here we do not used column names 

-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.:
select category , count(distinct customer_id) from retail_sales group by 1 ; 

## imoirtant ##
--  10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
-- To categorize orders into shifts based on the sale time, you can use a CASE statement in SQL.
select 
CASE
when hour(sale_time)  < 12 then "Morning"             -- we can use EXTRACT here to extract hour from sale_time ex "EXTRACT(HOUR from sale_time)" 
when Hour(sale_time) between 12 and 17 then "Afternoon"
else "evening"
end as shift , 
count(quantity) as number_of_orders
from retail_sales
group by shift 
order by number_of_orders desc;

-- ---------
-- ## DONE ## 
-- ---------
