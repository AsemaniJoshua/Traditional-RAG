/*
================================================================================
METADATA:
  Document_Title: E-Commerce Multi-Tenant Transactions & Customer Analytics
  Database_Dialect: PostgreSQL 16 / ANSI-SQL:2023
  Schema_Version: 3.4.0
  Author: Joshua Asemani
  Maintainer: Data Engineering Platform
  Data_Classification: Internal / PII Masked
  Created_At: 2026-10-02
  Tags: [ecommerce, transactions, payments, orders, schema, rag-search]
  Description: >
    Production-grade normalized transactional schema containing customers, product
    catalogues, order line items, payment gateway transaction tokens, and fulfillment
    logs. Fully annotated with table comments and column descriptions for LLM context.
================================================================================
*/

-- -------------------------------------------------------------
-- Schema Definition: Customers
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS customers (
    customer_id VARCHAR(36) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(120) UNIQUE NOT NULL,
    loyalty_tier VARCHAR(20) DEFAULT 'Bronze', -- [Bronze, Silver, Gold, Platinum]
    lifetime_value_usd NUMERIC(10, 2) DEFAULT 0.00,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

COMMENT ON TABLE customers IS 'Master registry of customer profiles, loyalty tiers, and aggregate spending metrics.';
COMMENT ON COLUMN customers.loyalty_tier IS 'Tier categorizing rewards eligibility: Bronze, Silver, Gold, or Platinum.';

-- -------------------------------------------------------------
-- Schema Definition: Orders & Line Items
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS orders (
    order_id VARCHAR(36) PRIMARY KEY,
    customer_id VARCHAR(36) REFERENCES customers(customer_id),
    order_status VARCHAR(25) NOT NULL, -- [Pending, Processing, Shipped, Delivered, Cancelled]
    total_amount_usd NUMERIC(10, 2) NOT NULL,
    discount_applied_usd NUMERIC(8, 2) DEFAULT 0.00,
    shipping_country VARCHAR(3) NOT NULL,
    payment_method VARCHAR(30) NOT NULL, -- [CreditCard, WireTransfer, Crypto, ApplePay]
    order_timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE orders IS 'Primary transactions table tracking lifecycle states and billing details.';

-- -------------------------------------------------------------
-- Seed Sample Data for Knowledge Retrieval
-- -------------------------------------------------------------
INSERT INTO customers (customer_id, first_name, last_name, email, loyalty_tier, lifetime_value_usd, created_at, is_active)
VALUES
    ('CUST-001', 'Alexander', 'Wright', 'alex.wright@example.com', 'Platinum', 14250.00, '2024-03-15 10:14:00Z', TRUE),
    ('CUST-002', 'Sophia', 'Chen', 'sophia.chen@example.com', 'Gold', 8720.50, '2024-07-22 14:32:00Z', TRUE),
    ('CUST-003', 'Liam', 'O''Connor', 'liam.oc@example.com', 'Silver', 2340.00, '2025-01-10 09:12:00Z', TRUE),
    ('CUST-004', 'Zainab', 'Al-Mansoor', 'zainab.m@example.com', 'Platinum', 21890.00, '2023-11-05 16:45:00Z', TRUE)
ON CONFLICT (customer_id) DO NOTHING;

INSERT INTO orders (order_id, customer_id, order_status, total_amount_usd, discount_applied_usd, shipping_country, payment_method, order_timestamp)
VALUES
    ('ORD-8801', 'CUST-001', 'Delivered', 1450.00, 100.00, 'USA', 'CreditCard', '2026-09-12 11:22:00Z'),
    ('ORD-8802', 'CUST-002', 'Shipped', 420.00, 0.00, 'CAN', 'ApplePay', '2026-09-28 15:40:00Z'),
    ('ORD-8803', 'CUST-004', 'Processing', 5800.00, 500.00, 'UAE', 'WireTransfer', '2026-10-01 08:05:00Z')
ON CONFLICT (order_id) DO NOTHING;
