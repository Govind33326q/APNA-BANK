-- Run this only if your BMS database already exists and was created before STAFF role support.
ALTER TABLE users DROP CONSTRAINT IF EXISTS users_role_check;
ALTER TABLE users ADD CONSTRAINT users_role_check CHECK (role IN ('ADMIN', 'STAFF', 'CUSTOMER'));

-- Optional demo staff login:
-- Email: staff@bank.com
-- Password: staff123
INSERT INTO users(full_name, email, password, role, phone, address)
SELECT 'Demo Staff', 'staff@bank.com', '10176e7b7b24d317acfcf8d2064cfd2f24e154f7b5a96603077d5ef813d6a6b6', 'STAFF', '6666666666', 'Branch Office'
WHERE NOT EXISTS (SELECT 1 FROM users WHERE email = 'staff@bank.com');
