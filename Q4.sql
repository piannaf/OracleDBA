/********************************************************/
/* Determine SQL Statement causing most reads/execution */
/********************************************************/
set serveroutput on
DECLARE
	max_rpe 	NUMBER;
	username	VARCHAR2(30);
	sql_text	VARCHAR2(1000);
	
BEGIN
	/***************************/
	/* Get max reads/execution */
	/***************************/
	SELECT MAX(disk_reads / executions) into max_rpe
	FROM V$SQLAREA
	WHERE executions > 0;
	
	/******************************************************/
	/* Get user and statement causing max reads/execution */
	/******************************************************/
	SELECT username, sql_text into username, sql_text
	FROM DBA_USERS A, V$SQLAREA B
	WHERE A.user_id = B.parsing_user_id 
		AND (B.disk_reads / B.executions) = max_rpe AND B.executions > 0;
	
	dbms_output.enable;
	dbms_output.put_line('Part A');
	dbms_output.put_line(max_rpe);
	dbms_output.put_line(username);
	dbms_output.put_line(sql_text);
END;
/

DECLARE
	max_mpe		NUMBER;
	username	VARCHAR2(30);
	sql_text	VARCHAR2(1000);
	
BEGIN
	/***************************/
	/* Get max memory/execution */
	/***************************/
	SELECT MAX(buffer_gets / executions) into max_mpe
	FROM V$SQLAREA
	WHERE executions > 0;
	
	/*****************************************************/
	/* Get user and statement using max memory/execution */
	/*****************************************************/
	SELECT username, sql_text into username, sql_text
	FROM DBA_USERS A, V$SQLAREA B
	WHERE A.user_id = B.parsing_user_id 
		AND (B.buffer_gets / B.executions) = max_mpe AND B.executions > 0;
	
	dbms_output.enable;
	dbms_output.put_line('Part B');
	dbms_output.put_line(max_mpe);
	dbms_output.put_line(username);
	dbms_output.put_line(sql_text);
END;
/
	
set serveroutput off