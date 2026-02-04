-- Update Manager names to be more distinct
UPDATE Users 
SET full_name = N'Nguyễn Văn A (Manager)' 
WHERE username = 'manager' OR (role = 'Manager' AND full_name = N'Quản lý');

UPDATE Users 
SET full_name = N'Trần Thị B (Manager)' 
WHERE username = 'manager2';

-- If manager2 doesn't exist, let's ensure we have at least two distinct managers for testing
IF NOT EXISTS (SELECT * FROM Users WHERE username = 'manager2')
BEGIN
    INSERT INTO Users (username, password_hash, email, full_name, phone, role, status, created_at)
    VALUES ('manager2', '123(hashed)', 'manager2@example.com', N'Trần Thị B (Manager)', '0987654321', 'Manager', 'Active', GETDATE());
END
