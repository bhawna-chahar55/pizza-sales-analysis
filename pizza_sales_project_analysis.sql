-- total revenue genertaed
SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS total_sales
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id ;

-- 4 highest priced pizzas --

SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 4;

-- 5 most sold pizzas and their quantity --

SELECT 
    pizza_types.name, SUM(order_details.quantity) AS cunta
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY cunta DESC
LIMIT 5;


-- jointhe necessory tables to find the total quantity of each pizzas orderd--

SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS Tot_quant
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY Tot_quant DESC;

--  determine the distribution of orders by hour of the day --

SELECT HOUR(order_time), COUNT(order_id) AS count 
FROM orders
GROUP BY HOUR(order_time) ORDER BY count DESC;


--  join relevent tables to find the category wise distribution of pizzas --

SELECT category, COUNT(name) AS distri
FROM pizza_types
GROUP BY category ORDER BY distri DESC;

-- group the orders by date and calculate the average No. of pizzas order per day--

SELECT 
    AVG(quantity)
FROM
    (SELECT 
        orders.order_date, SUM(order_details.quantity) AS quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date) AS order_quantity;
    

-- determine the top 3 pizza types according to revenue --

SELECT 
    pizza_types.name,
    SUM(order_details.quantity * pizzas.price) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC;

-- calculate percentage contribution of each pizza type to total revenue --
SELECT 
    pizza_types.category,
    SUM((order_details.quantity * pizzas.price / (SELECT 
            ROUND(SUM(order_details.quantity * pizzas.price),
                        2) AS total_sales
        FROM
            order_details
                JOIN
            pizzas ON pizzas.pizza_id = order_details.pizza_id) * 100)) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC;

-- top 3 most ordered pizza types based on revenuue for each pizza category --

select category, name, revenue, rn from 
(select category, name, revenue,
rank() over(partition by category order by revenue desc) as rn
from
(select pizza_types.category , pizza_types.name,
sum(order_details.quantity*pizzas.price) as revenue 
from pizza_types  join pizzas
on pizza_types.pizza_type_id  = pizzas.pizza_type_id 
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category, pizza_types.name) as sa) as b where rn<4 ;



  