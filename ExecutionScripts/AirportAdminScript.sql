-- connect AirportAdmin/AirportMainGuy2024;
-- ENSURE THIS SCRIPT IS EXECUTED BY AIRPORT ADMIN
WHENEVER SQLERROR EXIT SQL.SQLCODE;
show user;
--CLEANUP SCRIPT
set serveroutput on;
--Alter the sequences used in the script

-- Reset Sequences
-- alter sequence ADMIN.my_sequence restart start with 1;
alter sequence ADMIN.airline_seq restart start with 1;
alter sequence ADMIN.airline_route_sequence restart start with 10;
alter sequence ADMIN.orders_seq restart start with 50000;
alter sequence ADMIN.flight_seq restart start with 4000;
alter sequence ADMIN.passenger_seq restart start with 10000;
alter sequence ADMIN.baggage_id_seq restart start with 1;
alter sequence ADMIN.schedule_seq restart start with 5000;
alter sequence ADMIN.terminal_seq restart start with 6000;
alter sequence ADMIN.ticket_seq restart start with 7000;

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
   for i in (
             select 'PASSENGER' table_name from dual UNION ALL
             select 'BAGGAGE' table_name from dual UNION ALL
             select 'TICKET' table_name from dual UNION ALL
             select 'ORDERS' table_name from dual UNION ALL
             select 'SCHEDULE' table_name from dual union all             
             select 'FLIGHT' table_name from dual UNION ALL
             select 'AIRPORT' table_name from dual union all
             select 'AIRLINE_STAFF' table_name from dual union all
             select 'TERMINAL' table_name from dual union all 
             select 'AIRLINES' table_name from dual                          
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

DECLARE
  table_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO table_exists FROM user_tables WHERE table_name = 'PASSENGER';
  IF table_exists = 0 THEN
    EXECUTE IMMEDIATE 'CREATE TABLE passenger (
              passenger_id NUMBER PRIMARY KEY,
              age NUMBER CONSTRAINT age_format CHECK(age > 0),
              address VARCHAR2(100),
              sex VARCHAR2(10),
              govt_id_nos VARCHAR2(10),
              first_name VARCHAR2(30) CONSTRAINT first_name_format CHECK(first_name = INITCAP(first_name)),
              last_name VARCHAR2(30) CONSTRAINT last_name_format CHECK(last_name = INITCAP(last_name)),
              dob DATE,
              contact_number NUMBER,
              email VARCHAR2(100) UNIQUE       
            )';
    dbms_output.put_line('Table Passenger has been created');
  ELSE
    dbms_output.put_line('Table Passenger already exists');
  END IF;
END;
/

--creating orders table and checking if the table already exists, if it does exist
-- display that the table already exists
DECLARE
  table_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO table_exists FROM user_tables WHERE table_name = 'ORDERS';
  IF table_exists = 0 THEN
    EXECUTE IMMEDIATE 'CREATE TABLE orders ( 
      order_id NUMBER PRIMARY KEY, 
      passenger_id NUMBER, 
      amount FLOAT, 
      status VARCHAR2(20) 
    )';
    dbms_output.put_line('Table order has been created');
  ELSE
    dbms_output.put_line('Table order already exists');
  END IF;
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
          airport_id NUMBER UNIQUE,
          airport_name VARCHAR2(3) CONSTRAINT airport_name_pk PRIMARY KEY,
          city VARCHAR(20),
          state VARCHAR2(20),
          country VARCHAR2(50)
        )';
    dbms_output.put_line('Table Airport has been created');
  ELSE
    dbms_output.put_line('Table Airport already exists');
  END IF;
END;
/
--creating airlines table, if it doesn't already exist, if it does exist
-- display that the table already exists
DECLARE
  table_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO table_exists FROM user_tables WHERE table_name = 'AIRLINES';
  IF table_exists = 0 THEN
    EXECUTE IMMEDIATE 'CREATE TABLE airlines ( 
  airline_id NUMBER PRIMARY KEY, 
  route_number NUMBER, 
  airline_code VARCHAR2(10), 
  airline_name VARCHAR2(20) 
)';
    dbms_output.put_line('Table airline has been created');
  ELSE
    dbms_output.put_line('Table airline already exists');
  END IF;
END;
/
--creating airline_staff table, if it doesn't already exist, if it does exist
-- display that the table already exists
DECLARE
  table_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO table_exists FROM user_tables WHERE table_name = 'AIRLINE_STAFF';
  IF table_exists = 0 THEN
    EXECUTE IMMEDIATE 'CREATE TABLE airline_staff (
    staff_id       NUMBER PRIMARY KEY,
    airline_id     NUMBER REFERENCES airlines(airline_id) ON DELETE CASCADE,
    first_name     VARCHAR2(20),
    last_name      VARCHAR2(20),
    address        VARCHAR2(100),
    ssn            VARCHAR2(12),
    email_id       VARCHAR2(20),
    contact_number NUMBER,
    job_group      VARCHAR2(10),
    gender         VARCHAR2(10)
)';
    dbms_output.put_line('Table Airline_staff has been created');
  ELSE
    dbms_output.put_line('Table Airline_staff already exists');
  END IF;
END;
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
      -- departure_time TIMESTAMP,
      -- arrival_time TIMESTAMP,
      destination VARCHAR2(3) REFERENCES AIRPORT(airport_name) ON DELETE CASCADE,
      source VARCHAR2(3) REFERENCES AIRPORT(airport_name) ON DELETE CASCADE,
      status VARCHAR2(10) ,
      no_pax NUMBER,
      airline_id NUMBER REFERENCES airlines(airline_id) ON DELETE CASCADE,
      seats_filled NUMBER
    )';
    dbms_output.put_line('Table flight has been created');
  ELSE
    dbms_output.put_line('Table flight already exists');
  END IF;
END;
/
/*
The Below block of code creates the Ticket table. As an additional layer of
validation, the script is executed only if the table does not exist.
*/
DECLARE
  table_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO table_exists FROM user_tables WHERE table_name = 'TICKET';
  IF table_exists = 0 THEN
    EXECUTE IMMEDIATE 'CREATE TABLE ticket (
      ticket_id NUMBER PRIMARY KEY,
      order_id NUMBER REFERENCES orders(order_id) ON DELETE CASCADE,
      flight_id NUMBER REFERENCES flight(flight_id) ON DELETE CASCADE,
      seat_no VARCHAR2(10),
      meal_preferences VARCHAR2(20),
      source VARCHAR2(3) REFERENCES airport(airport_name) ON DELETE CASCADE,
      destination VARCHAR2(3)  REFERENCES airport(airport_name) ON DELETE CASCADE,
      date_of_travel DATE,
      class VARCHAR2(20),
      payment_type VARCHAR2(20),
      member_id NUMBER,
      transaction_amount FLOAT
      )';
    dbms_output.put_line('Table ticket has been created');
  ELSE
    dbms_output.put_line('Table ticket already exists');
  END IF;
END;
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
--CREATE OR REPLACE PROCEDURE insert_passengers IS
--BEGIN
--    execute passenger_onboarding_pkg.insert_passenger(25, '123 Main St, Anytown, USA', 'Male', '1234567890', 'John', 'Doe', TO_DATE('1997-05-22', 'YYYY-MM-DD'), 1234567890, 'johndoe@example.com');
--    execute passenger_onboarding_pkg.insert_passenger(35, '456 Oak St, Anytown, USA', 'Female', '1234567890', 'Jane', 'Smith', TO_DATE('1987-08-15', 'YYYY-MM-DD'), 2345678901, 'janesmith@example.com');
--    execute passenger_onboarding_pkg.insert_passenger(42, '789 Maple Ave, Anytown, USA', 'Male', '1234567890', 'Bob', 'Johnson', TO_DATE('1980-02-10', 'YYYY-MM-DD'), 3456789012, 'bobjohnson@example.com');
--    execute passenger_onboarding_pkg.insert_passenger(30, '321 Elm St, Anytown, USA', 'Female', '1234567890', 'Maria', 'Garcia', TO_DATE('1992-11-01', 'YYYY-MM-DD'), 4567890123, 'mariagarcia@example.com');
--    execute passenger_onboarding_pkg.insert_passenger(50, '789 Oak St, Anytown, USA', 'Male', '1234567890', 'David', 'Lee', TO_DATE('1973-06-12', 'YYYY-MM-DD'), 5678901234, 'davidlee@example.com');
--    execute passenger_onboarding_pkg.insert_passenger(27, '456 Maple Ave, Anytown, USA', 'Female', '1234567890', 'Emily', 'Wang', TO_DATE('1996-02-29', 'YYYY-MM-DD'), 6789012345, 'emilywang@example.com');
--    execute passenger_onboarding_pkg.insert_passenger(40, '123 Cherry St, Anytown, USA', 'Male', '1234567890', 'Michael', 'Smith', TO_DATE('1981-09-17', 'YYYY-MM-DD'), 7890123456, 'michaelsmith@example.com');
--    execute passenger_onboarding_pkg.insert_passenger(22, '789 Pine St, Anytown, USA', 'Female', '1234567890', 'Ava', 'Brown', TO_DATE('2000-03-25', 'YYYY-MM-DD'), 8901234567, 'avabrown@example.com');
--    commit;
--EXCEPTION
--  WHEN OTHERS THEN
--    ROLLBACK;
--    DBMS_OUTPUT.PUT_LINE('Error inserting Passenger: ' || SQLERRM);
--END insert_passengers;
--/
--EXECUTE insert_passengers;


execute passenger_onboarding_pkg.insert_passenger(25, '123 Main St, Anytown, USA', 'Male', '1234567890', 'John', 'Doe', TO_DATE('1997-05-22', 'YYYY-MM-DD'), 1234567890, 'johndoe@example.com');
execute passenger_onboarding_pkg.insert_passenger(35, '456 Oak St, Anytown, USA', 'Female', '1234567890', 'Jane', 'Smith', TO_DATE('1987-08-15', 'YYYY-MM-DD'), 2345678901, 'janesmith@example.com');
execute passenger_onboarding_pkg.insert_passenger(42, '789 Maple Ave, Anytown, USA', 'Male', '1234567890', 'Bob', 'Johnson', TO_DATE('1980-02-10', 'YYYY-MM-DD'), 3456789012, 'bobjohnson@example.com');
execute passenger_onboarding_pkg.insert_passenger(30, '321 Elm St, Anytown, USA', 'Female', '1234567890', 'Maria', 'Garcia', TO_DATE('1992-11-01', 'YYYY-MM-DD'), 4567890123, 'mariagarcia@example.com');
execute passenger_onboarding_pkg.insert_passenger(50, '789 Oak St, Anytown, USA', 'Male', '1234567890', 'David', 'Lee', TO_DATE('1973-06-12', 'YYYY-MM-DD'), 5678901234, 'davidlee@example.com');
execute passenger_onboarding_pkg.insert_passenger(27, '456 Maple Ave, Anytown, USA', 'Female', '1234567890', 'Emily', 'Wang', TO_DATE('1996-02-29', 'YYYY-MM-DD'), 6789012345, 'emilywang@example.com');
execute passenger_onboarding_pkg.insert_passenger(40, '123 Cherry St, Anytown, USA', 'Male', '1234567890', 'Michael', 'Smith', TO_DATE('1981-09-17', 'YYYY-MM-DD'), 7890123456, 'michaelsmith@example.com');
execute passenger_onboarding_pkg.insert_passenger(22, '789 Pine St, Anytown, USA', 'Female', '1234567890', 'Ava', 'Brown', TO_DATE('2000-03-25', 'YYYY-MM-DD'), 8901234567, 'avabrown@example.com');
execute passenger_onboarding_pkg.insert_passenger(11, '456 Elm St, Anytown, USA', 'Male', '0987654321', 'John', 'Smith', TO_DATE('1995-08-12', 'YYYY-MM-DD'), 7654321098, 'john.smith@example.com');
execute passenger_onboarding_pkg.insert_passenger(45, '567 Maple St, Anytown, USA', 'Male', '9876543210', 'James', 'Johnson', TO_DATE('1990-05-03', 'YYYY-MM-DD'), 2345678901, 'jamesjohnson@example.com');
execute passenger_onboarding_pkg.insert_passenger(33, '123 Oak St, Anytown, USA', 'Female', '3456789012', 'Emma', 'Garcia', TO_DATE('2002-01-15', 'YYYY-MM-DD'), 8765432109, 'emmagarcia@example.com');
execute passenger_onboarding_pkg.insert_passenger(87, '789 Cedar St, Anytown, USA', 'Male', '8901234567', 'Michael', 'Davis', TO_DATE('1985-11-22', 'YYYY-MM-DD'), 3456789012, 'michaeldavis@example.com');
execute passenger_onboarding_pkg.insert_passenger(99, '321 Pine St, Anytown, USA', 'Female', '2345678901', 'Sophia', 'Lopez', TO_DATE('1998-07-08', 'YYYY-MM-DD'), 9012345678, 'sophialopez@example.com');
execute passenger_onboarding_pkg.insert_passenger(12, '789 Main St, Anytown, USA', 'Female', '0123456789', 'Olivia', 'Wilson', TO_DATE('1999-12-05', 'YYYY-MM-DD'), 4567890123, 'oliviawilson@example.com');
execute passenger_onboarding_pkg.insert_passenger(67, '345 Oak St, Anytown, USA', 'Male', '9012345678', 'William', 'Martin', TO_DATE('1989-09-30', 'YYYY-MM-DD'), 7890123456, 'williammartin@example.com');
execute passenger_onboarding_pkg.insert_passenger(55, '567 Cedar St, Anytown, USA', 'Female', '4567890123', 'Mia', 'Thompson', TO_DATE('1997-02-18', 'YYYY-MM-DD'), 0123456789, 'miathompson@example.com');
execute passenger_onboarding_pkg.insert_passenger(23, '123 Maple St, Anytown, USA', 'Male', '7890123456', 'Ethan', 'Gonzalez', TO_DATE('2001-06-10', 'YYYY-MM-DD'), 2345678901, 'ethangonzalez@example.com');
execute passenger_onboarding_pkg.insert_passenger(44, '890 Elm St, Anytown, USA', 'Female', '2345678901', 'Isabella', 'Nelson', TO_DATE('1992-11-27', 'YYYY-MM-DD'), 6789012345, 'isabellanelson@example.com');
execute passenger_onboarding_pkg.insert_passenger(76, '234 Pine St, Anytown, USA', 'Male', '8901234567', 'David', 'Carter', TO_DATE('1988-04-22', 'YYYY-MM-DD'), 1234567890, 'davidcarter@example.com');
execute passenger_onboarding_pkg.insert_passenger(88, '456 Cedar St, Anytown, USA', 'Female', '9012345678', 'Chloe', 'Perez', TO_DATE('1993-09-16', 'YYYY-MM-DD'), 3456789012, 'chloeperez@example.com');
execute passenger_onboarding_pkg.insert_passenger(91, '678 Oak St, Anytown, USA', 'Male', '2345678901', 'Daniel', 'Roberts', TO_DATE('1996-03-01', 'YYYY-MM-DD'), 7890123456, 'danielroberts@example.com');
execute passenger_onboarding_pkg.insert_passenger(25, '890 Maple St, Anytown, USA', 'Female', '3456789012', 'Madison', 'Turner', TO_DATE('2004-10-20', 'YYYY-MM-DD'), 0123456789, 'madisonturner@example.com');
execute passenger_onboarding_pkg.insert_passenger(19, '321 Elm St, Anytown, USA', 'Male', '6789012345', 'Noah', 'Phillips', TO_DATE('2003-07-13', 'YYYY-MM-DD'), 4567890123, 'noahphillips@example.com');

select * from passenger;

--EXECUTE insert_airlines;

EXECUTE airline_pkg.insert_airline('6E', 'Indigo');
EXECUTE airline_pkg.insert_airline('AA', 'American Airlines');
EXECUTE airline_pkg.insert_airline('DL', 'Delta Air Lines');
EXECUTE airline_pkg.insert_airline('EK', 'Emirates');
EXECUTE airline_pkg.insert_airline('BA', 'British Airways');
EXECUTE airline_pkg.insert_airline('NH', 'All Nippon Airways');
EXECUTE airline_pkg.insert_airline('UA', 'United Airlines');
EXECUTE airline_pkg.insert_airline('TK', 'Turkish Airlines');
EXECUTE airline_pkg.insert_airline('CX', 'Cathay Pacific');
EXECUTE airline_pkg.insert_airline('SQ', 'Singapore Airlines');

select * from airlines;