DROP TABLE IF EXISTS spending_medians_by_age_group;
DROP TABLE IF EXISTS recurring_spending_monthly;
DROP TABLE IF EXISTS daily_user_assets;
DROP TABLE IF EXISTS transaction_histories;
DROP TABLE IF EXISTS cards;
DROP TABLE IF EXISTS login_identities;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS banks;
DROP TABLE IF EXISTS users;

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY, 
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    identification_number TEXT DEFAULT '',
    phone_number TEXT DEFAULT '',
    date_of_birth DATE DEFAULT NULL,
    address TEXT DEFAULT '',
    setting_json JSONB DEFAULT '{}',
    password_hash TEXT DEFAULT '',
    is_email_verified BOOLEAN DEFAULT false
);

CREATE INDEX IF NOT EXISTS user_by_id_index ON users (id);

CREATE TABLE IF NOT EXISTS banks (
    id SERIAL PRIMARY KEY, 
    bank_name TEXT NOT NULL,
    bank_code TEXT NOT NULL,
    finverse_id TEXT UNIQUE,
    countries TEXT DEFAULT 'SGP'
);

CREATE INDEX IF NOT EXISTS bank_index_by_id ON banks (id);

CREATE TABLE IF NOT EXISTS accounts (
    id BIGSERIAL PRIMARY KEY, 
    account_number TEXT NOT NULL,
    bank_id INT REFERENCES banks(id) NOT NULL,
    user_id INT REFERENCES users(id) NOT NULL,
    balance DECIMAL(10,2) NOT NULL DEFAULT 0,
    account_name TEXT NOT NULL,
    account_type TEXT NOT NULL,
    interest_rate_per_annum DECIMAL(10,5) NOT NULL DEFAULT 0,
    last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    finverse_id TEXT UNIQUE
);

CREATE UNIQUE INDEX IF NOT EXISTS finverse_id ON accounts (finverse_id);

CREATE INDEX IF NOT EXISTS accounts_index_on_user_id ON accounts (user_id, id);

CREATE TABLE IF NOT EXISTS cards (
    id SERIAL PRIMARY KEY, 
    owner_id INT REFERENCES users(id) NOT NULL,
    issuing_bank_id INT REFERENCES banks(id) NOT NULL,
    card_number TEXT NOT NULL, 
    card_type TEXT NOT NULL
);

CREATE INDEX IF NOT EXISTS card_index_by_user_id ON cards (owner_id);

CREATE TABLE IF NOT EXISTS transaction_histories (
    id BIGSERIAL PRIMARY KEY, 
    transaction_reference TEXT NOT NULL,
    account_id BIGINT REFERENCES accounts(id) DEFAULT NULL,
    user_id INT REFERENCES users(id) DEFAULT NULL,
    card_id INT REFERENCES cards(id) DEFAULT NULL,
    transaction_date DATE NOT NULL,
    transaction_time TIME DEFAULT NULL,
    amount DECIMAL(10,2) NOT NULL,
    transaction_type TEXT NOT NULL,
    description TEXT DEFAULT '',
    transaction_status TEXT NOT NULL,
    friendly_description TEXT DEFAULT '',
    transaction_category TEXT DEFAULT '',
    extracted_card_number TEXT DEFAULT '',
    brand_name TEXT DEFAULT '',
    brand_domain TEXT DEFAULT '',
    revised_transaction_date DATE DEFAULT NULL,
    is_processed BOOLEAN DEFAULT false,
    is_category_overridden_by_user BOOLEAN DEFAULT false,
    is_included_in_spending_or_income BOOLEAN DEFAULT true,
    finverse_id TEXT UNIQUE
);

CREATE INDEX IF NOT EXISTS transaction_histories_index_by ON transaction_histories (user_id, transaction_date);

-- Recurring spending monthly analysis results
DROP TABLE IF EXISTS recurring_spending_monthly;
CREATE TABLE IF NOT EXISTS recurring_spending_monthly (
    id BIGSERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) NOT NULL,
    merchant_key TEXT NOT NULL,
    sequence_key TEXT NOT NULL,
    display_name TEXT DEFAULT NULL,
    brand_name TEXT DEFAULT NULL,
    brand_domain TEXT DEFAULT NULL,
    category TEXT DEFAULT NULL,
    year INT NOT NULL,
    month INT NOT NULL,
    expected_amount DECIMAL(10,2) NOT NULL,
    amount_stddev DECIMAL(10,2) DEFAULT NULL,
    occurrence_count INT NOT NULL DEFAULT 0,
    last_transaction_date DATE DEFAULT NULL,
    interval_days INT DEFAULT NULL,
    period_label TEXT DEFAULT NULL,
    next_transaction_date DATE DEFAULT NULL,
    confidence DOUBLE PRECISION DEFAULT 0.0,
    transaction_ids BIGINT[] DEFAULT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_recurring_unique ON recurring_spending_monthly (user_id, merchant_key, sequence_key, year, month);
CREATE INDEX IF NOT EXISTS idx_recurring_user_month ON recurring_spending_monthly (user_id, year, month);

-- Spending medians by age group for monthly comparisons
DROP TABLE IF EXISTS spending_medians_by_age_group;
CREATE TABLE IF NOT EXISTS spending_medians_by_age_group (
    id BIGSERIAL PRIMARY KEY,
    age_group TEXT NOT NULL,
    year INT NOT NULL,
    month INT NOT NULL,
    median_spending DECIMAL(10,2) NOT NULL,
    user_count INT NOT NULL,
    transaction_count INT NOT NULL,
    calculated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(age_group, year, month)
);

CREATE INDEX IF NOT EXISTS idx_spending_medians_lookup ON spending_medians_by_age_group(age_group, year, month);

-- Daily user asset tracking for portfolio value over time
DROP TABLE IF EXISTS daily_user_assets;
CREATE TABLE IF NOT EXISTS daily_user_assets (
    id BIGSERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) NOT NULL,
    asset_date DATE NOT NULL,
    total_asset_value DECIMAL(15,2) NOT NULL,
    account_count INT NOT NULL,
    calculated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, asset_date)
);

CREATE INDEX IF NOT EXISTS idx_daily_assets_user_date ON daily_user_assets(user_id, asset_date DESC);
CREATE INDEX IF NOT EXISTS idx_daily_assets_date ON daily_user_assets(asset_date);