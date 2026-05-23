-- Run once on existing BMS database if you are upgrading from an older version.
-- Allows admin to promote customers to staff and soft-remove customers from customer section.
ALTER TABLE users DROP CONSTRAINT IF EXISTS users_role_check;
ALTER TABLE users ADD CONSTRAINT users_role_check CHECK (role IN ('ADMIN', 'STAFF', 'CUSTOMER', 'REMOVED'));
