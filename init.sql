-- Создание таблицы для хранения данных о продажах товаров.
CREATE TABLE IF NOT EXISTS sales 
(
    date Date,
    category String,
    product String,
    sales_amount Float32,
    customer_id UInt32
) 
ENGINE = MergeTree(date,category, product, purchase_date)
ORDER BY date;
