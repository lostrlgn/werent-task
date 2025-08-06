-- категории
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

-- продукты
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    category_id INTEGER REFERENCES categories(id)
);

-- заказы
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(id),
    purchase_time TIMESTAMP DEFAULT now()
);

-- статистика
CREATE TABLE statistics (
    stat_date DATE,
    category_id INTEGER,
    product_count INTEGER,
    PRIMARY KEY (stat_date, category_id)
);

-- функция
CREATE OR REPLACE FUNCTION update_statistics()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO statistics(stat_date, category_id, product_count)
    VALUES (
        CURRENT_DATE,
        (SELECT category_id FROM products WHERE id = NEW.product_id),
        1
    )
    ON CONFLICT (stat_date, category_id)
    DO UPDATE SET product_count = statistics.product_count + 1;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-- триггер
CREATE TRIGGER trg_update_statistics
AFTER INSERT ON orders
FOR EACH ROW
EXECUTE FUNCTION update_statistics();
