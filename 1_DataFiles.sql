USE tempdb;
GO

-- Database should have multiple data files in proportion to the number of processors.
-- Each file should be identical in initial size and growth increments.
SELECT	*
FROM	sys.database_files;