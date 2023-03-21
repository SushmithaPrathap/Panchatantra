--CLEANUP SCRIPT
WHENEVER SQLERROR EXIT SQL.SQLCODE
show user;
--CLEANUP SCRIPT
set serveroutput on
/*
The Below block of code checks if the tables TERMINAL and AIRPORT
are present in the database. If present the tables are dropped and 
a message indicating the success is the output. In the case of any errors
a custom error message is displayed.
*/
declare
    v_table_exists varchar(1) := 'Y';
    v_sql varchar(2000);
begin
   dbms_output.put_line('Start schema cleanup');
   for i in (select 'TERMINAL' table_name from dual union all
             select 'AIRPORT' table_name from dual
   )
   loop
   dbms_output.put_line('....Drop table '||i.table_name);
   begin
       select 'Y' into v_table_exists
       from USER_TABLES
       where TABLE_NAME=i.table_name;

       v_sql := 'drop table '||i.table_name;
       execute immediate v_sql;
       dbms_output.put_line('........Table '||i.table_name||' dropped successfully');
       
   exception
       when no_data_found then
           dbms_output.put_line('........Table already dropped');
   end;
   end loop;
   dbms_output.put_line('Schema cleanup successfully completed');
exception
   when others then
      dbms_output.put_line('Failed to execute code:'||sqlerrm);
end;
/
/*
The Below block of code creates the TERMINAL table. As an additional layer of
validation, the script is executed only if the table does not exist.
*/
DECLARE
  table_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO table_exists FROM user_tables WHERE table_name = 'TERMINAL';
  IF table_exists = 0 THEN
    EXECUTE IMMEDIATE 'CREATE TABLE terminal (
      terminal_id NUMBER PRIMARY KEY,
      terminal_name VARCHAR2(100)
    )';
    dbms_output.put_line('Table terminal has been created');
  ELSE
    dbms_output.put_line('Table terminal already exists');
  END IF;
END;
/
/*
The Below block of code is a stored procedure for inserting
data into the TERMINAL table , it is called  insert_terminal
and the execution line is present after the block. Once 
the data is inserted it is commited to the database. In
the event of any errors a rollback is performed.
*/
CREATE OR REPLACE PROCEDURE insert_terminal IS
BEGIN
    INSERT INTO terminal (terminal_id, terminal_name)
    SELECT 1, 'Terminal A' from dual union all
    SELECT 2, 'Terminal B' from dual union all
    SELECT 3, 'Terminal C' from dual union all
    SELECT 4, 'Terminal D' from dual union all
    SELECT 5, 'Terminal E' from dual;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Data Inserted into terminal table');
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error inserting terminal: ' || SQLERRM);
END insert_terminal;
/
EXECUTE insert_terminal;