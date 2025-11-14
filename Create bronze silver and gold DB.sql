-- =============================================================
-- Create Bronze, Silver, and Gold Databases
-- =============================================================
-- Script Purpose:
--   This script creates three databases representing the
--   layered architecture of a data warehouse:
--     1. bronze  - raw/staging layer
--     2. silver  - cleaned/transformed layer
--     3. gold    - curated/analytics-ready layer
--
-- WARNING:
--   Running this script will DROP and RECREATE these databases if they exist.
--   All existing data will be permanently deleted.
--   Proceed with caution and ensure you have backups.
-- =============================================================

-- Drop existing databases if they exist
DROP DATABASE IF EXISTS bronze;
DROP DATABASE IF EXISTS silver;
DROP DATABASE IF EXISTS gold;

-- Create fresh databases
CREATE DATABASE bronze;
CREATE DATABASE silver;
CREATE DATABASE gold;

-- (Optional) Verify creation
SHOW DATABASES;