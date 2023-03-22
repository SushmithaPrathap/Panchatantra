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
-- CREATING VIEW
/*
The Below block of code creates views from the TERMINAL table
-- View 1: Retrieve all terminal details
*/
BEGIN
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW  terminal_info AS
    SELECT terminal_id, terminal_name
    FROM terminal';
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
/*
The Below block of code creates views from the TERMINAL table
-- View 2: Retrieve the terminal details with longest name
*/

BEGIN
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW  longest_terminal_name_details AS
    SELECT *
    FROM terminal
    ORDER BY LENGTH(terminal_name) DESC
    FETCH FIRST 1 ROW ONLY';
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

/*
The Below block of code creates the Airport table. As an additional layer of
validation, the script is executed only if the table does not exist.
*/
DECLARE
  table_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO table_exists FROM user_tables WHERE table_name = 'AIRPORT';
  IF table_exists = 0 THEN
    EXECUTE IMMEDIATE 'CREATE TABLE airport (
          airport_id NUMBER PRIMARY KEY,
          airport_name VARCHAR2(100),
          city VARCHAR(20),
          state VARCHAR2(20),
          country VARCHAR2(20)
        )';
    dbms_output.put_line('Table Airport has been created');
  ELSE
    dbms_output.put_line('Table Airport already exists');
  END IF;
END;
/
/*
The Below block of code is a stored procedure for inserting
data into the Aiport table , it is called  insert_airport
and the execution line is present after the block. Once
the data is inserted it is commited to the database. In
the event of any errors a rollback is performed.
*/
CREATE OR REPLACE PROCEDURE insert_airport IS
BEGIN
--    INSERT INTO airport (airport_id, airport_name, city, state, country)
--    SELECT 1, 'Denver International Airport', 'Denver', 'CO', 'USA' from dual union all
--    SELECT 2, 'O Hare International Airport', 'Chicago', 'IL', 'USA'  from dual union all
--    SELECT 3, 'Los Angeles International Airport', 'Los Angeles', 'CA', 'USA' from dual union all
--    SELECT 4, 'Orlando International Airport', 'Orlando', 'FL', 'USA' from dual union all
--    SELECT 5, 'Harry Reid International Airport', 'Las Vegas', 'NV', 'USA' from dual;
--    COMMIT;
    INSERT INTO airport (airport_id, airport_name, city, state, country)
    SELECT 1, 'Heathrow Airport', 'London', NULL, 'UK' from dual union all
    SELECT 2, 'Narita International Airport', 'Tokyo', NULL, 'Japan' from dual union all
    SELECT 3, 'Sydney Airport', 'Sydney', 'NSW', 'Australia' from dual union all
    SELECT 4, 'Dubai International Airport', 'Dubai', NULL, 'UAE' from dual union all
    SELECT 5, 'Charles de Gaulle Airport', 'Paris', NULL, 'France' from dual;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Data Inserted into airport table');
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error inserting airport: ' || SQLERRM);
END insert_airport;
/
EXECUTE insert_airport;

-- CREATING VIEW
/*
The Below block of code creates views from the AIRPORT table
-- View 1: Retrieve all airport details
*/
BEGIN
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW  airport_info AS
    SELECT airport_id, airport_name
    FROM airport';
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
/*
The Below block of code creates views from the AIRPORT table
-- View 2: Retrieve count of the airports in each state
*/

BEGIN
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW  count_of_airport_in_each_state AS
    SELECT COUNT(*) as airport_count
    FROM airport
    GROUP BY state';
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
/*
Stored Procedure for updating airport names
*/

CREATE OR REPLACE PROCEDURE update_airport_name (
  p_airport_id IN NUMBER,
  p_airport_name IN VARCHAR2
)
IS
BEGIN
  UPDATE airport
  SET airport_name = p_airport_name
  WHERE airport_id = p_airport_id;
  COMMIT;
 
  DBMS_OUTPUT.PUT_LINE('Airport ' || p_airport_id || ' name updated to ' || p_airport_name);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Airport ' || p_airport_id || ' not found.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
--Execution
--Select * from airport;
EXECUTE update_airport_name(2, 'Logan International Airport');