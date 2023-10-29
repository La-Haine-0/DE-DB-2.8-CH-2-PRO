-- Вычислите общую сумму продаж по каждой категории товаров за последний месяц.
SELECT category, sum(sales_amount) as total_sales_last_month
FROM sales
WHERE date >= last_month_start AND date <= last_month_end
GROUP BY category;

-- Определите средний чек покупателей за последний год.
SELECT AVG(total_amount) as avg_check_last_year
FROM (
    SELECT customer_id, sum(sales_amount) as total_amount
    FROM sales
    WHERE date >= last_year_start AND date <= last_year_end
    GROUP BY customer_id
) subquery;

-- Вычислите средние продажи для каждой категории товаров в течение квартала с использованием -State комбинатора и функции avgState.
SELECT category, avgState(sales_amount) AS avg_sales_state
FROM sales
WHERE date >= quarter_start AND date <= quarter_end
GROUP BY category;

-- Объедините промежуточные результаты с использованием -Merge комбинатора, чтобы вычислить общую среднюю продажу за квартал.
SELECT sumMerge(avg_sales_state) AS total_avg_sales_quarter
FROM (
    SELECT category, avgState(sales_amount) AS avg_sales_state
    FROM sales
    WHERE date >= quarter_start AND date <= quarter_end
    GROUP BY category
) subquery;

-- Определите топ-5 товаров с наибольшей выручкой за последние 7 дней.
SELECT product, sum(sales_amount) as total_revenue_last_week
FROM sales
WHERE date >= last_week_start AND date <= last_week_end
GROUP BY product
ORDER BY total_revenue_last_week DESC
LIMIT 5;

-- Найдите кумулятивную сумму продаж для каждой категории товаров за последние 3 месяца.
SELECT 
    category, 
    date, 
    sum(sales_amount) OVER (PARTITION BY category ORDER BY date) AS cumulative_sales_last_3_months
FROM sales
WHERE date >= last_3_months_start AND date <= last_3_months_end;

-- Создайте отчет о продажах за последний год и сохраните его в отдельной таблице с использованием оператора INSERT.
CREATE TABLE sales_report
ENGINE = MergeTree()
ORDER BY date
AS
SELECT *
FROM sales
WHERE date >= last_year_start AND date <= last_year_end;

-- Выполните запрос, который объединяет данные из этой таблицы с текущими данными о продажах и вычисляет общую сумму продаж за последний год.
SELECT sum(sales_amount) AS total_sales_last_year
FROM (
    SELECT sales_amount FROM sales_report
    UNION ALL
    SELECT sales_amount FROM sales
    WHERE date >= last_year_start AND date <= last_year_end
) combined_table;
