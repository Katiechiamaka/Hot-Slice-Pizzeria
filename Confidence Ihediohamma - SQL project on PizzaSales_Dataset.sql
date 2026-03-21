
SELECT *
FROM order_details;

SELECT*
FROM orders;

select *
from pizzas;

select *
from pizza_types

--Joining the tables together
select
	od.order_details_id,
	od.order_id,
	od.quantity,
	o.date,
	o.time,
	p.pizza_id,
	p.price,
	p.size,
	pt.category,
	pt.ingredients,
	pt.name,
	pt.pizza_type_id

FROM order_details od
JOIN orders o ON o.order_id = od.order_id
JOIN pizzas p ON p.pizza_id = od.pizza_id
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id


--Q1. What is the total revenue generated?
SELECT 
	SUM(p.price * od.quantity) AS Total_Revenue
FROM 
	order_details od
JOIN pizzas p ON p.pizza_id = od.pizza_id


--Q2. What is the total order placed?
SELECT 
	COUNT(DISTINCT order_id) AS Total_OrderPlaced
FROM
	order_details;


--Q3. What is the average price of pizza sold?
SELECT 
	AVG (p.Price * o.quantity) AS AvgTotal_revenue

FROM 
	order_details o
JOIN pizzas p ON o.pizza_id = p.pizza_id;


--Q4. What is the Total number of pizza sold
SELECT
	SUM(quantity) AS Total_Pizza_Sold
FROM order_details;


--Q5. What time of the day do pizza sale the most?
SELECT TOP 1
    DATEPART (HOUR, CAST(o.Date AS DATETIME) + CAST (o.Time AS DATETIME)) AS Order_Hour,
    SUM(od.Quantity) AS Total_Pizzas_Sold
FROM 
    Order_details od
JOIN 
    Orders o ON od.Order_id = o.Order_id
GROUP BY 
      DATEPART (HOUR, CAST(o.Date AS DATETIME) + CAST (o.Time AS DATETIME))
ORDER BY 
    Total_Pizzas_Sold DESC;


--Q6ai.What is the daily trend of Orders placed for the year
SELECT
	DATENAME(DW, o.date) AS Order_day, COUNT(distinct od.order_id) AS TotalOrders
FROM 
	order_details od
JOIN orders o ON od.order_id = o.order_id
GROUP BY  DATENAME(DW, o.date)
ORDER BY TotalOrders DESC;


--Q6aii. What is the monthly trend of orders placed for the year
SELECT
	DATENAME(MONTH, o.date) AS Months, COUNT(distinct od.order_id) AS TotalOrders
FROM 
	order_details od
JOIN orders o ON od.order_id = o.order_id
GROUP BY  DATENAME(MONTH, o.date)
ORDER BY TotalOrders desc;


--Q7. What is the total sales generated for each month of the year?
SELECT
	DATENAME(MONTH, o.date) AS Month,
	SUM(p.price * od.quantity) AS TotalSales_Revenue
FROM
	orders o
JOIN order_details od ON od.order_id =o.order_id
JOIN pizzas p ON p.pizza_id = od.pizza_id
GROUP BY DATENAME(MONTH, o.date)
ORDER BY TotalSales_Revenue DESC;


--Q8. What is the percentage of pizza sales?
SELECT
	pt.category,
	SUM( p.price) AS TotalSales,
	SUM( p.price) * 100 / (SELECT SUM(p2.price)
							FROM order_details od2
							JOIN pizzas p2 ON od2.pizza_id = p2.pizza_id ) AS Sales_Percentage
FROM 
	order_details od 
JOIN pizzas p ON p.pizza_id = od.pizza_id 
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.category
ORDER BY Sales_Percentage DESC;


--Q9. What is the percentage of pizza sales in the month of May(The WHERE clause can be used to filter % of sales of the month)
SELECT 
	pt.category, 
	SUM( od.quantity * p.price) AS TotalSales,
	(SUM(od.quantity * p.price) / (SELECT SUM(od2.quantity * p2.price)
										FROM order_details od2
										JOIN pizzas p2 ON od2.pizza_id = p2.pizza_id 
										JOIN orders o ON od2.order_id = o.order_id
										WHERE MONTH (o.date) = 5)
										) * 100 AS Sales_Percentage
FROM 
	order_details od 
JOIN pizzas p ON p.pizza_id = od.pizza_id 
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
JOIN orders o ON od.order_id = o.order_id
WHERE MONTH (o.date) = 5
GROUP BY pt.category
ORDER BY Sales_Percentage DESC;


--Q10. How much revenue is generated from each Pizza category ?
SELECT 
	pt.category,
	SUM(p.price * od.quantity) AS Total_Rev
FROM
	order_details od
JOIN pizzas p ON p.pizza_id = od.pizza_id
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.category
ORDER BY Total_Rev DESC;


--Q11. Which Pizza category performed the best in terms of quantity sold? 
SELECT
	pt.Category,
	SUM(od.quantity) AS Quantity_Sold
FROM
	order_details od
JOIN pizzas p ON p.pizza_id = od.pizza_id
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.category 
ORDER BY Quantity_Sold DESC;


--Q12. What is the top 5 most ordered pizza??
SELECT TOP 5
	pt.name AS Pizza_Name,
	SUM(od.quantity) AS Quantity_Ordered
FROM 
	order_details od
JOIN pizzas p ON p.pizza_id = od.pizza_id
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.name
ORDER BY Quantity_Ordered DESC;


--Q13. What is the bottom 5 least ordered pizza?
SELECT TOP 5
	pt.name AS Pizza_Name,
	SUM(od.quantity) AS Quantity_Ordered
FROM 
	order_details od
JOIN pizzas p ON p.pizza_id = od.pizza_id
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.name
ORDER BY Quantity_Ordered ASC;


--Q14. What is the percentage of sales by pizza Size?
SELECT
	p.size,
	SUM( od.quantity) AS TotalQuantity,
	SUM( p.price) * 100 / (SELECT SUM(p2.price)
							FROM order_details od2
							JOIN pizzas p2 ON od2.pizza_id = p2.pizza_id ) AS Sales_Percentage
FROM 
	order_details od 
JOIN pizzas p ON p.pizza_id = od.pizza_id 
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY p.size
ORDER BY Sales_Percentage DESC;


--Q15. What is the Top 5 pizza by revenue generated?
SELECT TOP 5
	pt.name,
	SUM (p.price * od.quantity) AS Total_Revenue
FROM
	order_details od
JOIN pizzas p ON p.pizza_id = od.pizza_id
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.name
ORDER BY Total_Revenue DESC;


--Q16. What is the Bottom 5 pizza by revenue generated?
SELECT TOP 5
	pt.name,
	SUM (p.price * od.quantity) AS Total_Revenue
FROM
	order_details od
JOIN pizzas p ON p.pizza_id = od.pizza_id
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.name
ORDER BY Total_Revenue ASC;


--Q17. What is the top 5 most used pizza Ingredient?
SELECT TOP 5
	pt.ingredients,
	SUM (od.quantity) AS TotalQuantity
FROM 
	order_details od
JOIN pizzas p ON p.pizza_id = od.pizza_id
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.ingredients
ORDER BY TotalQuantity DESC;



--Q18. What is the 5 least used pizza Ingredient?
SELECT TOP 5
	pt.ingredients,
	SUM (od.quantity) AS TotalQuantity
FROM 
	order_details od
JOIN pizzas p ON p.pizza_id = od.pizza_id
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.ingredients
ORDER BY TotalQuantity ASC;


-- Q20. What is the percentage of repeated customers?
WITH repeated_orders AS (
    SELECT Order_id
    FROM order_details
    GROUP BY Order_id
    HAVING COUNT(Order_id) > 1
)
SELECT 
    (COUNT(DISTINCT repeated_orders.Order_id) * 100 / COUNT(DISTINCT O.Order_id)) AS retention_rate
FROM 
    order_details o
LEFT JOIN 
    repeated_orders 
ON 
    O.Order_id = repeated_orders.Order_id;


-- Q21. What is the top 10 pizza size and type
select top 10
	pt.name AS PizzaType,
	p.size,
	sum(od.quantity) AS total_Quantity_Ordered
from
	order_details od
join pizzas p on od.pizza_id = p.pizza_id
join pizza_types pt on pt.pizza_type_id = p.pizza_type_id
group by pt.name, p.size
order by total_Quantity_Ordered desc; 


--Q22. What is the most common prefered pizza size, type and ingredigent?
WITH most_common_size AS (
    SELECT TOP 1
        p.Size, 
        SUM(od.Quantity) AS total_quantity
    FROM 
        Order_details od
    JOIN 
        Pizzas p ON od.Pizza_id = p.Pizza_id
    GROUP BY 
        p.Size
    ORDER BY 
        total_quantity DESC
),
most_common_ingredients AS (
    SELECT TOP 1
        pt.Ingredients, 
        COUNT(od.order_id) AS total_orders
    FROM 
        Order_details od
    JOIN 
        Pizzas p ON od.Pizza_id = p.Pizza_id
    JOIN 
        Pizza_types pt ON p.Pizza_type_id = pt.Pizza_type_id
    GROUP BY 
        pt.Ingredients
    ORDER BY 
        total_orders DESC
),
most_common_pizza_type AS (
    SELECT TOP 1
        pt.Name AS pizza_type, 
        COUNT(od.order_id) AS total_orders
    FROM 
        Order_details od
    JOIN 
        Pizzas p ON od.Pizza_id = p.Pizza_id
    JOIN 
        Pizza_types pt ON p.Pizza_type_id = pt.Pizza_type_id
    GROUP BY 
        pt.Name
    ORDER BY 
        total_orders DESC
)
SELECT 
    Size AS most_common_size,
    Ingredients AS most_common_ingredients,
    pizza_type AS most_common_pizza_type
FROM 
    most_common_size size
CROSS JOIN 
    most_common_ingredients ingredients
CROSS JOIN 
    most_common_pizza_type pizza_type;


--Q23. What is the least common prefered pizza size, type and ingredigent?
WITH least_common_size AS (
    SELECT TOP 1
        p.Size, 
        SUM(od.Quantity) AS total_quantity
    FROM 
        Order_details od
    JOIN 
        Pizzas p ON od.Pizza_id = p.Pizza_id
    GROUP BY 
        p.Size
    ORDER BY 
        total_quantity ASC
),
least_common_ingredients AS (
    SELECT TOP 1
        pt.Ingredients, 
        COUNT(od.order_id) AS total_orders
    FROM 
        Order_details od
    JOIN 
        Pizzas p ON od.Pizza_id = p.Pizza_id
    JOIN 
        Pizza_types pt ON p.Pizza_type_id = pt.Pizza_type_id
    GROUP BY 
        pt.Ingredients
    ORDER BY 
        total_orders ASC
),
least_common_pizza_type AS (
    SELECT TOP 1
        pt.Name AS pizza_type, 
        COUNT(od.order_id) AS total_orders
    FROM 
        Order_details od
    JOIN 
        Pizzas p ON od.Pizza_id = p.Pizza_id
    JOIN 
        Pizza_types pt ON p.Pizza_type_id = pt.Pizza_type_id
    GROUP BY 
        pt.Name
    ORDER BY 
        total_orders ASC
)
SELECT 
    Size AS least_common_size,
    Ingredients AS least_common_ingredients,
    pizza_type AS least_common_pizza_type
FROM 
    least_common_size size
CROSS JOIN 
    least_common_ingredients ingredients
CROSS JOIN 
    least_common_pizza_type pizza_type;



--Flag the quantity as either high or low quantity sold
SELECT 
	order_id,
	CAse WHEN Quantity > 3 THEN 'High'
	ELSE 'Low'
	END AS Quantity_Category
FROM
	order_details;