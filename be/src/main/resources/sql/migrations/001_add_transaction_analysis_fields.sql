-- Migration script to add transaction analysis fields
-- This script adds the new columns required for storing AI analysis results

-- Add new columns for transaction analysis results
ALTER TABLE transaction_histories 
ADD COLUMN IF NOT EXISTS transaction_category VARCHAR(255) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS extracted_card_number VARCHAR(255) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS revised_transaction_date DATE DEFAULT NULL;

-- Add index for efficient querying of unprocessed transactions
CREATE INDEX IF NOT EXISTS transaction_histories_is_processed_idx ON transaction_histories (is_processed, user_id);

-- Add index for transaction category queries
CREATE INDEX IF NOT EXISTS transaction_histories_category_idx ON transaction_histories (transaction_category);

-- Update any existing records to ensure is_processed is properly set
UPDATE transaction_histories SET is_processed = false WHERE is_processed IS NULL;