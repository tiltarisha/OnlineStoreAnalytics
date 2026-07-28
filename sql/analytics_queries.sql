-- ПРОЕКТ: Аналитическая система интернет-магазина


USE OnlineStore;
GO


-- 1. Список всех покупателей (по дате регистрации)
SELECT
    customer_id,
    full_name,
    email,
    phone,
    registration_date
FROM Customers
ORDER BY registration_date DESC;


-- 2. Количество зарегистрированных покупателей по месяцам
SELECT
    YEAR(registration_date) AS year,
    MONTH(registration_date) AS month,
    COUNT(*) AS new_customers_count
FROM Customers
GROUP BY
    YEAR(registration_date),
    MONTH(registration_date)
ORDER BY
    year DESC,
    month DESC;


-- 3. Покупатели без единого заказа
SELECT
    c.customer_id,
    c.full_name,
    c.email,
    c.registration_date
FROM Customers c
LEFT JOIN Orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL
ORDER BY c.registration_date;


-- 4. ТОП-5 покупателей по сумме покупок
SELECT TOP 5
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS orders_count,
    SUM(o.total_amount) AS total_spent
FROM Customers c
INNER JOIN Orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.full_name
ORDER BY total_spent DESC;


-- 5. Количество заказов по месяцам
SELECT
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    COUNT(*) AS orders_count,
    SUM(total_amount) AS revenue
FROM Orders
GROUP BY
    YEAR(order_date),
    MONTH(order_date)
ORDER BY
    year DESC,
    month DESC;


    -- 6. Распределение заказов по статусам
SELECT
    status,
    COUNT(*) AS orders_count
FROM Orders
GROUP BY status
ORDER BY orders_count DESC;


-- 7. Самые продаваемые товары (по количеству проданных единиц)
SELECT TOP 5
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM Products p
INNER JOIN OrderItems oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_quantity_sold DESC;


-- 8. Самые прибыльные товары
SELECT TOP 5
    p.product_id,
    p.product_name,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM Products p
INNER JOIN OrderItems oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_revenue DESC;


-- 9. Самые популярные категории товаров
SELECT
    c.category_name,
    SUM(oi.quantity) AS total_sold
FROM Categories c
INNER JOIN Products p
    ON c.category_id = p.category_id
INNER JOIN OrderItems oi
    ON p.product_id = oi.product_id
GROUP BY
    c.category_name
ORDER BY total_sold DESC;


-- 10. Общая статистика магазина
SELECT
    COUNT(*) AS total_orders,
    SUM(total_amount) AS total_revenue,
    AVG(total_amount) AS average_order_amount,
    MIN(total_amount) AS minimum_order_amount,
    MAX(total_amount) AS maximum_order_amount
FROM Orders;


-- 11. Средний чек по месяцам
SELECT
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    COUNT(*) AS orders_count,
    AVG(total_amount) AS average_check
FROM Orders
GROUP BY
    YEAR(order_date),
    MONTH(order_date)
ORDER BY
    year DESC,
    month DESC;


-- 12. Количество оплат по способам оплаты
SELECT
    payment_method,
    COUNT(*) AS payments_count
FROM Payments
WHERE status = N'Оплачен'
GROUP BY payment_method
ORDER BY payments_count DESC;


-- 13. Выручка по способам оплаты
SELECT
    payment_method,
    COUNT(*) AS payments_count,
    SUM(amount) AS total_revenue
FROM Payments
WHERE status = N'Оплачен'
GROUP BY payment_method
ORDER BY total_revenue DESC;


-- 14. Заказы, ожидающие доставки
SELECT
    o.order_id,
    c.full_name,
    o.order_date,
    o.total_amount,
    d.delivery_status
FROM Orders o
INNER JOIN Customers c
    ON o.customer_id = c.customer_id
INNER JOIN Deliveries d
    ON o.order_id = d.order_id
WHERE d.delivery_status <> N'Доставлен'
ORDER BY o.order_date;


-- 15. Покупатели, оформившие более одного заказа
SELECT
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS orders_count,
    SUM(o.total_amount) AS total_spent
FROM Customers c
INNER JOIN Orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.full_name
HAVING COUNT(o.order_id) > 1
ORDER BY total_spent DESC;


-- 16. Рейтинг покупателей по сумме покупок (DENSE_RANK)
WITH CustomerSpending AS
(
    SELECT
        c.customer_id,
        c.full_name,
        SUM(o.total_amount) AS total_spent
    FROM Customers c
    INNER JOIN Orders o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_id,
        c.full_name
)
SELECT
    customer_id,
    full_name,
    total_spent,
    DENSE_RANK() OVER (ORDER BY total_spent DESC) AS rank_position
FROM CustomerSpending
ORDER BY rank_position, full_name;


-- 17. Рейтинг товаров по выручке (ROW_NUMBER)
WITH ProductRevenue AS
(
    SELECT
        p.product_id,
        p.product_name,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM Products p
    INNER JOIN OrderItems oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_id,
        p.product_name
)
SELECT
    ROW_NUMBER() OVER (ORDER BY revenue DESC) AS product_rank,
    product_name,
    revenue
FROM ProductRevenue
ORDER BY product_rank;


-- 18. Накопительная выручка по месяцам
WITH MonthlyRevenue AS
(
    SELECT
        YEAR(order_date) AS year,
        MONTH(order_date) AS month,
        SUM(total_amount) AS revenue
    FROM Orders
    GROUP BY
        YEAR(order_date),
        MONTH(order_date)
)
SELECT
    year,
    month,
    revenue,
    SUM(revenue) OVER (
        ORDER BY year, month
    ) AS cumulative_revenue
FROM MonthlyRevenue
ORDER BY
    year,
    month;


-- 19. Распределение заказов по ценовым категориям
SELECT
    CASE
        WHEN total_amount < 30000 THEN N'До 30 000 ₽'
        WHEN total_amount < 70000 THEN N'30 000–69 999 ₽'
        WHEN total_amount < 100000 THEN N'70 000–99 999 ₽'
        ELSE N'100 000 ₽ и выше'
    END AS price_category,
    COUNT(*) AS orders_count,
    SUM(total_amount) AS total_revenue
FROM Orders
GROUP BY
    CASE
        WHEN total_amount < 30000 THEN N'До 30 000 ₽'
        WHEN total_amount < 70000 THEN N'30 000–69 999 ₽'
        WHEN total_amount < 100000 THEN N'70 000–99 999 ₽'
        ELSE N'100 000 ₽ и выше'
    END
ORDER BY total_revenue DESC;


-- 20. Рейтинг категорий товаров по выручке
WITH CategoryRevenue AS
(
    SELECT
        c.category_name,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM Categories c
    INNER JOIN Products p
        ON c.category_id = p.category_id
    INNER JOIN OrderItems oi
        ON p.product_id = oi.product_id
    GROUP BY
        c.category_name
)
SELECT
    category_name,
    revenue,
    DENSE_RANK() OVER (ORDER BY revenue DESC) AS rank_position
FROM CategoryRevenue
ORDER BY rank_position;