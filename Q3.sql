/***************************************/
/* Kill user doing most physical reads */
/***************************************/
set serveroutput on
DECLARE
	max_read 	NUMBER;
	sid			NUMBER;
	serialno	NUMBER;
	
BEGIN
	/**************************/
	/* Get max physical reads */
	/**************************/
	SELECT MAX(B.physical_reads) into max_read
	FROM V$SESSION A, V$SESS_IO B
	WHERE A.sid = B.sid AND A.username <> 'ANONYMOUS';
	
	/*************************************/
	/* Get user doing max physical reads */
	/*************************************/
	SELECT C.sid, C.serial# into sid, serialno
	FROM V$SESSION C, V$SESS_IO D
	WHERE C.sid = D.sid AND D.physical_reads = max_read
		AND rownum = 1;	/* Kill the first such session if duplicates exist */
	
	dbms_output.enable;
	dbms_output.put_line(max_read);
	dbms_output.put_line(sid);
	dbms_output.put_line(serialno);
	
	EXECUTE IMMEDIATE 'ALTER SYSTEM KILL SESSION '''||sid||','||serialno||'''';
END;
/
set serveroutput off