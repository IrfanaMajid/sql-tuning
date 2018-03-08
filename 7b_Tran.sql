USE ScratchDB;
GO

SET TRANSACTION ISOLATION LEVEL SNAPSHOT;

BEGIN TRAN [UPD_TEST2];

DECLARE	@NVAL AS INT;

SELECT	@NVAL = [NVAL]
FROM	[dbo].[Test01]
WHERE	SVAL = N'1';

SELECT	@NVAL;

UPDATE [dbo].[Test01]
	SET NVAL = @NVAL
WHERE	SVAL = N'3';

COMMIT TRAN [UPD_TEST2];

SELECT	@@TRANCOUNT, XACT_STATE();

SELECT	'dm_exec_sessions', *
FROM	sys.dm_exec_sessions
WHERE	database_id = DB_ID(N'ScratchDB')
		AND session_id IN (53, 52);

SELECT	'dm_tran_active_transactions', *
FROM	sys.dm_tran_active_transactions
WHERE	name LIKE N'UPD_TEST%';

SELECT	'dm_tran_database_transactions', *
FROM	sys.dm_tran_database_transactions
WHERE	database_id = DB_ID(N'ScratchDB');

SELECT	'dm_tran_locks', *
FROM	sys.dm_tran_locks
WHERE	resource_database_id = DB_ID(N'ScratchDB')
		AND request_session_id IN (53, 52)
ORDER BY request_session_id
; --= @@SPID

-- Shows blocker session
SELECT	'dm_exec_requests', *
FROM	sys.dm_exec_requests
WHERE	session_id IN (53, 52);

