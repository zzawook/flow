CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY, 
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    identification_number VARCHAR(255) NOT NULL,
    phone_number VARCHAR(255) NOT NULL,
    date_of_birth DATE NOT NULL,
    address VARCHAR(255) NOT NULL,
    setting_json JSONB DEFAULT '{}'
);

CREATE TABLE IF NOT EXISTS banks (
    id SERIAL PRIMARY KEY, 
    bank_name VARCHAR(255) NOT NULL,
    bank_code VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS accounts (
    id BIGSERIAL PRIMARY KEY, 
    account_number VARCHAR(255) NOT NULL,
    bank_id INT REFERENCES banks(id) NOT NULL,
    user_id INT REFERENCES users(id) NOT NULL,
    balance DECIMAL(10,2) NOT NULL DEFAULT 0,
    account_name VARCHAR(255) NOT NULL,
    account_type VARCHAR(255) NOT NULL,
    interest_rate_per_annum DECIMAL(10,5) NOT NULL DEFAULT 0,
    last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS cards (
    id SERIAL PRIMARY KEY, 
    owner_id INT REFERENCES users(id) NOT NULL,
    linked_account_id BIGINT REFERENCES accounts(id) NOT NULL, 
    issuing_bank_id INT REFERENCES banks(id) NOT NULL,
    card_number VARCHAR(255) NOT NULL, 
    card_type VARCHAR(255) NOT NULL,
    expiry_date DATE NOT NULL,
    cvv VARCHAR(255) NOT NULL,
    pin VARCHAR(255) NOT NULL,
    card_status VARCHAR(255) NOT NULL,
    daily_limit DECIMAL(10,2) NOT NULL,
    monthly_limit DECIMAL(10,2) NOT NULL,
    card_holder_name VARCHAR(255) NOT NULL,
    address_line_1 VARCHAR(255) NOT NULL,
    address_line_2 VARCHAR(255) DEFAULT '',
    city VARCHAR(255) NOT NULL,
    state VARCHAR(255) NOT NULL,
    zip_code VARCHAR(255) NOT NULL,
    country VARCHAR(255) NOT NULL,
    phone VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS transaction_histories (
    id BIGSERIAL PRIMARY KEY, 
    transaction_reference VARCHAR(255) NOT NULL,
    account_id BIGINT REFERENCES accounts(id) DEFAULT NULL,
    card_id INT REFERENCES cards(id) DEFAULT NULL,
    transaction_date DATE NOT NULL,
    transaction_time TIME DEFAULT NULL,
    amount DECIMAL(10,2) NOT NULL,
    transaction_type VARCHAR(255) NOT NULL,
    description VARCHAR(255) DEFAULT '',
    transaction_status VARCHAR(255) NOT NULL,
    friendly_description VARCHAR(255) DEFAULT ''
);