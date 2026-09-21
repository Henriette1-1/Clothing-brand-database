# Clothing-brand-database
PosteSQL database for a clothing brand
-- ============================================
-- Clothing Brand Database
-- PostgreSQL DDL
-- ============================================


-- ============================================
-- 1. CATEGORY
-- ============================================

CREATE TABLE Category (
    category_id INTEGER GENERATED ALWAYS AS IDENTITY,
    category_name VARCHAR(100) NOT NULL,

    CONSTRAINT pk_category
        PRIMARY KEY (category_id),

    CONSTRAINT uq_category_name
        UNIQUE (category_name)
);


-- ============================================
-- 2. PRODUCT
-- ============================================

CREATE TABLE Product (
    product_id INTEGER GENERATED ALWAYS AS IDENTITY,
    product_name VARCHAR(150) NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    category_id INTEGER NOT NULL,

    CONSTRAINT pk_product
        PRIMARY KEY (product_id),

    CONSTRAINT fk_product_category
        FOREIGN KEY (category_id)
        REFERENCES Category(category_id),

    CONSTRAINT chk_product_price
        CHECK (price >= 0)
);


-- ============================================
-- 3. CUSTOMER
-- ============================================

CREATE TABLE Customer (
    customer_id INTEGER GENERATED ALWAYS AS IDENTITY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(150) NOT NULL,

    CONSTRAINT pk_customer
        PRIMARY KEY (customer_id),

    CONSTRAINT uq_customer_email
        UNIQUE (email)
);


-- ============================================
-- 4. CUSTOMER ORDER
-- ============================================

CREATE TABLE CustomerOrder (
    order_id INTEGER GENERATED ALWAYS AS IDENTITY,
    customer_id INTEGER NOT NULL,
    order_date DATE NOT NULL,

    CONSTRAINT pk_customer_order
        PRIMARY KEY (order_id),

    CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id)
);


-- ============================================
-- 5. ORDER ITEM
-- ============================================

CREATE TABLE OrderItem (
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,

    CONSTRAINT pk_order_item
        PRIMARY KEY (order_id, product_id),

    CONSTRAINT fk_order_item_order
        FOREIGN KEY (order_id)
        REFERENCES CustomerOrder(order_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_order_item_product
        FOREIGN KEY (product_id)
        REFERENCES Product(product_id),

    CONSTRAINT chk_order_item_quantity
        CHECK (quantity > 0)
);
