-- Migration script to transition from Scoring to Potential Status
-- Run this in your SQL Server environment

-- 1. Add the new column
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Leads') AND name = 'potential_status')
BEGIN
    ALTER TABLE Leads ADD potential_status VARCHAR(10) DEFAULT 'Cool';
END
GO

-- 2. Migrate existing data
-- Leads with score >= 15 are Hot (per previous threshold)
UPDATE Leads SET potential_status = 'Hot' WHERE current_score >= 15;
UPDATE Leads SET potential_status = 'Cool' WHERE current_score < 15 OR current_score IS NULL;
GO

-- 3. Drop Default Constraints on current_score before dropping the column
DECLARE @ConstraintName nvarchar(200)
SELECT @ConstraintName = Name 
FROM sys.default_constraints 
WHERE parent_object_id = object_id('Leads') 
  AND parent_column_id = (SELECT column_id FROM sys.columns WHERE name = 'current_score' AND object_id = object_id('Leads'))

IF @ConstraintName IS NOT NULL
BEGIN
    EXEC('ALTER TABLE Leads DROP CONSTRAINT ' + @ConstraintName)
END
GO

-- 4. Drop the old column
ALTER TABLE Leads DROP COLUMN current_score;
GO

