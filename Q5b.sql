/****************************************/
/* Part B -- Update INDEX_SIZE_TRACKING */
/****************************************/
set serveroutput on
DECLARE
	allocated	NUMBER;
	used		NUMBER;
	idx_cnt		PLS_INTEGER;
	date_time	VARCHAR2(255);
	CURSOR idx_cur IS
		SELECT index_name FROM dba_ind_columns WHERE index_name LIKE 'Q2_%';
	
BEGIN
	/**************************************************/
	/* Loop over cursor to update INDEX_SIZE_TRACKING */
	/**************************************************/
	FOR c_row IN idx_cur LOOP
		dbms_output.enable;
		dbms_output.put_line(c_row.index_name);
		EXECUTE IMMEDIATE 'ANALYZE INDEX '||c_row.index_name||' VALIDATE STRUCTURE';
		
		SELECT btree_space, used_space INTO allocated, used	FROM index_stats;
		
		dbms_output.put_line(allocated);
		dbms_output.put_line(used);
		
		/****************************************/
		/* Update the INDEX_SIZE_TRACKING table */
		/****************************************/
		SELECT COUNT(*) INTO idx_cnt 
		FROM INDEX_SIZE_TRACKING 
		WHERE index_name = c_row.index_name;
		
		SELECT TO_CHAR(SYSDATE, 'MM/DD/YYYY HH:MI:SS') INTO date_time FROM dual;
		
		IF idx_cnt > 0 THEN
			UPDATE INDEX_SIZE_TRACKING SET allocated_space = allocated
			WHERE index_name = c_row.index_name;
			
			UPDATE INDEX_SIZE_TRACKING SET used_space = used
			WHERE index_name = c_row.index_name;
			
			UPDATE INDEX_SIZE_TRACKING SET last_update = date_time
			WHERE index_name = c_row.index_name;
		ELSE
			INSERT INTO INDEX_SIZE_TRACKING (allocated_space, used_space,
					last_update, index_name)
			VALUES (allocated, used, date_time, c_row.index_name);
		END IF;
	END LOOP;
END;
/
set serveroutput off
