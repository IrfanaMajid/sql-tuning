USE ScratchDB;
GO
/*
DROP VIEW IF EXISTS dbo.DBlocks;
GO

-- Returns all locks in the current database
CREATE VIEW dbo.DBlocks 
AS
	SELECT	request_session_id as spid
			, db_name(resource_database_id) as dbname
			, CASE
				WHEN resource_type = 'OBJECT' THEN object_name(resource_associated_entity_id)
				WHEN resource_associated_entity_id = 0 THEN 'n/a'
				ELSE object_name(p.object_id)
			END as entity_name
			, index_id
			, resource_type
			, resource_description
			, request_mode
			, request_status
FROM	sys.dm_tran_locks t 
	LEFT JOIN sys.partitions p
		ON p.partition_id = t.resource_associated_entity_id
WHERE	resource_database_id = db_id();
GO
*/
UPDATE [dbo].[Test01]
	SET NVAL = CAST(SVAL AS INT);

SELECT	*
FROM	[dbo].[Test01]

SET TRANSACTION ISOLATION LEVEL SNAPSHOT;
--SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

BEGIN TRAN [UPD_TEST];

DECLARE	@NVAL AS INT;

SELECT	@NVAL = [NVAL]
FROM	[dbo].[Test01]
WHERE	SVAL = N'3';

UPDATE [dbo].[Test01]
	SET NVAL = @NVAL
WHERE	SVAL = N'1';

COMMIT TRAN [UPD_TEST];

SELECT	'dm_exec_sessions', *
FROM	sys.dm_exec_sessions
WHERE	database_id = DB_ID(N'ScratchDB')
		AND session_id IN (53, 57);

SELECT	'dm_tran_active_transactions', *
FROM	sys.dm_tran_active_transactions
WHERE	name LIKE N'UPD_TEST%';

SELECT	'dm_tran_database_transactions', *
FROM	sys.dm_tran_database_transactions
WHERE	database_id = DB_ID(N'ScratchDB');

-- Best way to view locks and lock metadata.
SELECT	'dm_tran_locks', *
FROM	sys.dm_tran_locks
WHERE	resource_database_id = DB_ID(N'ScratchDB')
		AND request_session_id IN (53, 57)
ORDER BY request_session_id
; --= @@SPID

-- Shows blocker session
SELECT	'dm_exec_requests', *
FROM	sys.dm_exec_requests
WHERE	session_id IN (53, 57);

SELECT	'DBlocks', *
FROM	dbo.DBlocks;
