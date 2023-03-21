--  Initial Cleanup Script - This is done on devDB handled by Sushmitha Prathap
WHENEVER SQLERROR EXIT SQL.SQLCODE
show user;
--CLEANUP SCRIPT
set serveroutput on
/*
The Below block of code checks if the tables FLIGHT and PASSENGER
are present in the database. If present the tables are dropped and 
a message indicating the success is the output. In the case of any errors
a custom error message is displayed.
*/
declare
    v_table_exists varchar(1) := 'Y';
    v_sql varchar(2000);
begin
   dbms_output.put_line('Start schema cleanup');
   for i in (select 'FLIGHT' table_name from dual UNION ALL
             select 'PASSENGER' table_name from dual
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
      dbms_output.put_line('Error with the table:'||sqlerrm);
end;
/
/*
The Below block of code creates the FLIGHTS table. As an additional layer of
validation, the script is executed only if the table does not exist.
*/
DECLARE
  table_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO table_exists FROM user_tables WHERE table_name = 'FLIGHT';
  IF table_exists = 0 THEN
    EXECUTE IMMEDIATE 'CREATE TABLE flight (
      flight_id NUMBER PRIMARY KEY,
      duration NUMBER,
      flight_type VARCHAR2(100),
      departure_time TIMESTAMP,
      arrival_time TIMESTAMP,
      destination VARCHAR2(100),
      source VARCHAR2(100),
      status VARCHAR2(10),
      no_pax NUMBER,
      airline_id NUMBER
    )';
    dbms_output.put_line('Table flight has been created');
  ELSE
    dbms_output.put_line('Table flight already exists');
  END IF;
END;
/

--BEGIN
--    INSERT INTO flight (flight_id, duration, flight_type, departure_time, arrival_time, destination, source, status, no_pax)
--    SELECT 1, 120, 'Boeing 737', TO_TIMESTAMP('2023-03-21 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-03-21 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'New York', 'London', 'On Time', 200 from dual union all
--    SELECT 2, 180, 'Airbus A320', TO_TIMESTAMP('2023-03-22 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-03-22 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paris', 'Berlin', 'Delayed', 150 from dual union all
--    SELECT 3, 240, 'Boeing 747', TO_TIMESTAMP('2023-03-23 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-03-23 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Sydney', 'Singapore', 'On Time', 400 from dual union all
--    SELECT 4, 90, 'Embraer E175', TO_TIMESTAMP('2023-03-24 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-03-24 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Los Angeles', 'San Francisco', 'On Time', 80 from dual union all
--    SELECT 5, 150, 'Boeing 737', TO_TIMESTAMP('2023-03-25 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-03-25 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Toronto', 'Montreal', 'On Time', 180 from dual union all
--    SELECT 6, 120, 'Airbus A320', TO_TIMESTAMP('2023-03-26 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-03-26 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Berlin', 'Amsterdam', 'Delayed', 150 from dual union all
--    SELECT 7, 180, 'Boeing 787', TO_TIMESTAMP('2023-03-27 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-03-27 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Dubai', 'London', 'On Time', 300 from dual union all
--    SELECT 8, 90, 'Embraer E175', TO_TIMESTAMP('2023-03-28 17:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-03-28 19:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Miami', 'Orlando', 'On Time', 80 from dual union all
--    SELECT 9, 120, 'Airbus A320', TO_TIMESTAMP('2023-03-29 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-03-29 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Barcelona', 'Madrid','Cancelled',100 from dual union all
--    SELECT 10, 187, 'Airbus A380', TO_TIMESTAMP('2023-03-30 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-03-29 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Boston', 'Madrid','On Time',300 from dual;
--    --/
--    commit;
--EXCEPTION
--  WHEN OTHERS THEN
--    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
--END;
/

/*
The Below block of code is a stored procedure for inserting
data into the Flights table , it is called  insert_flight
and the execution line is present after the block. Once 
the data is inserted it is commited to the database. In
the event of any errors a rollback is performed.
*/
CREATE OR REPLACE PROCEDURE insert_flight IS
BEGIN
    INSERT INTO flight (flight_id, duration, flight_type, departure_time, arrival_time, destination, source, status, no_pax, airline_id)
    SELECT 1, 120, 'Boeing 737', TO_TIMESTAMP('2023-03-21 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-03-21 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'New York', 'London', 'On Time', 200, 256 from dual union all
    SELECT 2, 180, 'Airbus A320', TO_TIMESTAMP('2023-03-22 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-03-22 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paris', 'Berlin', 'Delayed', 150, 257 from dual union all
    SELECT 3, 240, 'Boeing 747', TO_TIMESTAMP('2023-03-23 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-03-23 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Sydney', 'Singapore', 'On Time', 400, 258 from dual union all
    SELECT 4, 90, 'Embraer E175', TO_TIMESTAMP('2023-03-24 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-03-24 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Los Angeles', 'San Francisco', 'On Time', 80, 259 from dual union all
    SELECT 5, 150, 'Boeing 737', TO_TIMESTAMP('2023-03-25 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-03-25 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Toronto', 'Montreal', 'On Time', 180, 260 from dual union all
    SELECT 6, 120, 'Airbus A320', TO_TIMESTAMP('2023-03-26 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-03-26 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Berlin', 'Amsterdam', 'Delayed', 150, 261 from dual union all
    SELECT 7, 180, 'Boeing 787', TO_TIMESTAMP('2023-03-27 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-03-27 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Dubai', 'London', 'On Time', 300,262 from dual union all
    SELECT 8, 90, 'Embraer E175', TO_TIMESTAMP('2023-03-28 17:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-03-28 19:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Miami', 'Orlando', 'On Time', 80, 263 from dual union all
    SELECT 9, 120, 'Airbus A320', TO_TIMESTAMP('2023-03-29 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-03-29 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Barcelona', 'Madrid','Cancelled',100, 264 from dual union all
    SELECT 10, 187, 'Airbus A380', TO_TIMESTAMP('2023-03-30 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-03-29 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Boston', 'Madrid','On Time',300, 265 from dual;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Data Inserted into flights table');
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error inserting flight: ' || SQLERRM);
END insert_flight;
/
EXECUTE insert_flight;

-- Lets see a sample of the data
--Select * from flight;
-- CREATING VIEW
/*
The Below block of code creates views from the FLIGHT table
-- View 1: Retrieve flight information with the departure and arrival locations swapped
*/
BEGIN
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW  swapped_flight_info AS
    SELECT flight_id, duration, flight_type, arrival_time AS departure_time, departure_time AS arrival_time, source AS destination, destination AS source, status, no_pax
    FROM flight';
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
/*
The Below block of code creates views from the FLIGHT table
-- View 2: Retrieve only delayed flights
*/

BEGIN
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW  delayed_flights AS
    SELECT *
    FROM flight
    WHERE status = ''Delayed''';
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/


/*
Stored Procedure for updating flight Status
*/

CREATE OR REPLACE PROCEDURE update_flight_status(
  p_flight_id IN NUMBER,
  p_status IN VARCHAR2
)
IS
BEGIN
  UPDATE flight
  SET status = p_status
  WHERE flight_id = p_flight_id;
  
  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('Flight ' || p_flight_id || ' status updated to ' || p_status);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Flight ' || p_flight_id || ' not found.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
--Execution 
--Select * from flight;
EXECUTE update_flight_status(1, 'Delayed');

/*
The Below block of code creates the Passenger table. As an additional layer of
validation, the script is executed only if the table does not exist.
*/
DECLARE
  table_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO table_exists FROM user_tables WHERE table_name = 'PASSENGER';
  IF table_exists = 0 THEN
    EXECUTE IMMEDIATE 'CREATE TABLE passenger (
          passenger_id NUMBER PRIMARY KEY,
          age NUMBER,
          address VARCHAR2(100),
          sex VARCHAR2(10),
          govt_id_nos VARCHAR2(10),
          first_name VARCHAR2(20),
          last_name VARCHAR2(20),
          dob DATE,
          contact_number NUMBER,
          email VARCHAR2(100)
        )';
    dbms_output.put_line('Table Passenger has been created');
  ELSE
    dbms_output.put_line('Table Passenger already exists');
  END IF;
END;
/
--INSERT INTO passengers (passenger_id, age, pnr, p_id, address, gender, passport_number, first_name, last_name, dob, contact_number, email)
--SELECT 1, 25, 'ABC123', 1001, '123 Main St, Anytown, USA', 'Male', 'ABC123XYZ', 'John', 'Doe', TO_DATE('1997-01-15', 'YYYY-MM-DD'), '123-456-7890', 'johndoe@email.com' FROM DUAL
--UNION ALL
--SELECT 2, 35, 'DEF456', 1002, '456 Elm St, Anytown, USA', 'Female', 'DEF456XYZ', 'Jane', 'Smith', TO_DATE('1987-06-22', 'YYYY-MM-DD'), '987-654-3210', 'janesmith@email.com' FROM DUAL
--UNION ALL
--SELECT 3, 45, 'GHI789', 1003, '789 Oak St, Anytown, USA', 'Male', 'GHI789XYZ', 'Bob', 'Johnson', TO_DATE('1977-03-10', 'YYYY-MM-DD'), '555-555-5555', 'bobjohnson@email.com' FROM DUAL
--UNION ALL
--SELECT 4, 28, 'JKL012', 1004, '321 Pine St, Anytown, USA', 'Female', 'JKL012XYZ', 'Sara', 'Lee', TO_DATE('1994-12-01', 'YYYY-MM-DD'), '111-222-3333', 'saralee@email.com' FROM DUAL
--UNION ALL
--SELECT 5, 19, 'MNO345', 1005, '654 Maple St, Anytown, USA', 'Male', 'MNO345XYZ', 'David', 'Nguyen', TO_DATE('2003-08-11', 'YYYY-MM-DD'), '444-444-4444', 'davidnguyen@email.com' FROM DUAL;
--
--commit;
/*
The Below block of code is a stored procedure for inserting
data into the Passengers table , it is called  insert_passenger
and the execution line is present after the block. Once 
the data is inserted it is commited to the database. In
the event of any errors a rollback is performed.
*/
CREATE OR REPLACE PROCEDURE insert_passengers IS
BEGIN
    INSERT INTO passenger (passenger_id, age, address, sex, govt_id_nos, first_name, last_name, dob, contact_number, email)
    SELECT 1, 25, '123 Main St, Anytown, USA', 'Male', 'ABC123', 'John', 'Doe', TO_DATE('1997-05-22', 'YYYY-MM-DD'), 1234567890, 'johndoe@example.com' FROM DUAL
    UNION ALL
    SELECT 2, 35, '456 Oak St, Anytown, USA', 'Female', 'DEF456', 'Jane', 'Smith', TO_DATE('1987-08-15', 'YYYY-MM-DD'), 2345678901, 'janesmith@example.com' FROM DUAL
    UNION ALL
    SELECT 3, 42, '789 Maple Ave, Anytown, USA', 'Male', 'GHI789', 'Bob', 'Johnson', TO_DATE('1980-02-10', 'YYYY-MM-DD'), 3456789012, 'bobjohnson@example.com' FROM DUAL
    UNION ALL
    SELECT 4, 30, '321 Elm St, Anytown, USA', 'Female', 'JKL012', 'Maria', 'Garcia', TO_DATE('1992-11-01', 'YYYY-MM-DD'), 4567890123, 'mariagarcia@example.com' FROM DUAL
    UNION ALL
    SELECT 5, 50, '789 Oak St, Anytown, USA', 'Male', 'MNO345', 'David', 'Lee', TO_DATE('1973-06-12', 'YYYY-MM-DD'), 5678901234, 'davidlee@example.com' FROM DUAL
    UNION ALL
    SELECT 6, 27, '456 Maple Ave, Anytown, USA', 'Female', 'PQR678', 'Emily', 'Wang', TO_DATE('1996-02-29', 'YYYY-MM-DD'), 6789012345, 'emilywang@example.com' FROM DUAL
    UNION ALL
    SELECT 7, 40, '123 Cherry St, Anytown, USA', 'Male', 'STU901', 'Michael', 'Smith', TO_DATE('1981-09-17', 'YYYY-MM-DD'), 7890123456, 'michaelsmith@example.com' FROM DUAL
    UNION ALL
    SELECT 8, 22, '789 Pine St, Anytown, USA', 'Female', 'VWX234', 'Ava', 'Brown', TO_DATE('2000-03-25', 'YYYY-MM-DD'), 8901234567, 'avabrown@example.com' FROM DUAL;    
    commit;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error inserting Passenger: ' || SQLERRM);
END insert_passengers;
/
EXECUTE insert_passengers;


-- CREATING VIEW

/*
The Below block of code creates views from the FLIGHT table
-- View 1: View Showing All the male passengers travelling through the airport.
*/

BEGIN
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW male_passengers AS
    SELECT *
    FROM passenger
    WHERE sex = ''Male''';
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
/*
The Below block of code creates views from the FLIGHT table
-- View 2: details of children travelling in the airport
*/
BEGIN
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW underage_passengers AS
    SELECT age, email FROM passenger
    WHERE age < 18';
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

-- CREATE OR REPLACE PROCEDURE get_passenger_details (
--   p_passenger_id IN NUMBER,
--   p_result OUT SYS_REFCURSOR
-- ) AS
-- BEGIN
--   OPEN p_result FOR
--     SELECT *
--     FROM passenger
--     WHERE passenger_id = p_passenger_id;
-- END;
-- /
-- DECLARE
--   v_passenger_id NUMBER := 1;
--   v_result SYS_REFCURSOR;
--   v_age NUMBER;
--   v_address VARCHAR2(100);
--   v_sex VARCHAR2(10);
--   v_govt_id_nos VARCHAR2(10);
--   v_first_name VARCHAR2(20);
--   v_last_name VARCHAR2(20);
--   v_dob DATE;
--   v_contact_number NUMBER;
--   v_email VARCHAR2(100);
-- BEGIN
--   get_passenger_details(p_passenger_id => v_passenger_id, p_result => v_result);
  
--   FETCH v_result INTO v_passenger_id, v_age, v_address, v_sex, v_govt_id_nos, v_first_name, v_last_name, v_dob, v_contact_number, v_email;
  
--   DBMS_OUTPUT.PUT_LINE('Age: ' || v_age);
--   DBMS_OUTPUT.PUT_LINE('Address: ' || v_address);
--   DBMS_OUTPUT.PUT_LINE('Sex: ' || v_sex);
--   DBMS_OUTPUT.PUT_LINE('Govt ID Nos: ' || v_govt_id_nos);
--   DBMS_OUTPUT.PUT_LINE('First Name: ' || v_first_name);
--   DBMS_OUTPUT.PUT_LINE('Last Name: ' || v_last_name);
--   DBMS_OUTPUT.PUT_LINE('DOB: ' || v_dob);
--   DBMS_OUTPUT.PUT_LINE('Contact Number: ' || v_contact_number);
--   DBMS_OUTPUT.PUT_LINE('Email: ' || v_email);
  
--   CLOSE v_result;
-- END;
-- /

--Select * from flight;
--Select * from passenger;
--Select * from male_passengers;