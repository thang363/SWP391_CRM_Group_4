-- SWP391 CRM System 
-- SQL Migration Script for Landing Page Status Simplification

-- 1. Drop the existing CHECK constraint that blocks 'Public' status
IF EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'CHK_LandingPages_Status')
BEGIN
    ALTER TABLE LandingPages DROP CONSTRAINT CHK_LandingPages_Status;
END

-- 2. Update all 'Approved' landing pages to 'Public'
UPDATE LandingPages 
SET status = 'Public' 
WHERE status = 'Approved';

-- 3. Update all 'Pending' or 'Rejected' landing pages to 'Draft'
UPDATE LandingPages 
SET status = 'Draft' 
WHERE status IN ('Pending', 'Rejected');

-- 4. Re-add the CHECK constraint with 'Public' allowed
ALTER TABLE LandingPages WITH CHECK ADD CONSTRAINT CHK_LandingPages_Status 
CHECK (([status]='Public' OR [status]='Draft' OR [status]='Active' OR [status]='Archived' OR [status]='Paused'));

ALTER TABLE LandingPages CHECK CONSTRAINT CHK_LandingPages_Status;

-- NOTE: Execute this script securely on the production/development database.
