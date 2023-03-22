WHENEVER SQLERROR EXIT SQL.SQLCODE
show user;

set serveroutput on
declare
    v_table_exists varchar(1) := 'Y';
    v_sql varchar(2000);
begin
   dbms_output.put_line('Start schema cleanup');
   for i in (select 'TICKET' table_name from dual union all
             select 'AIRLINE_STAFF' table_name from dual
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
DECLARE
  table_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO table_exists FROM user_tables WHERE table_name = 'TICKET';
  IF table_exists = 0 THEN
    EXECUTE IMMEDIATE 'CREATE TABLE ticket (
   ticket_id NUMBER PRIMARY KEY,
  order_id VARCHAR2(50),
  flight_id NUMBER,
  seat_no VARCHAR2(10),
  meal_preferences VARCHAR2(20),
  source VARCHAR2(50),
  destination VARCHAR2(50),
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
/*CREATE OR REPLACE PROCEDURE insert_ticket IS
BEGIN
  FOR i IN 1..10 LOOP
    dbms_output.put_line('Table flight already exists '|| 'ORD-00'||i);
    INSERT INTO ticket (ticket_id, order_id, flight_id, seat_no, meal_preferences, source, destination, date_of_travel, class)
    VALUES (i, 'ORD-00'||i, i, 'A0'||i, 'Vegetarian', 'City'||TO_CHAR(i), 'City'||TO_CHAR(i+1), SYSDATE, 'Business');
    END LOOP;
END insert_ticket;
/
EXECUTE insert_ticket;*/
/*
DECLARE
  i NUMBER := 1;
BEGIN
  INSERT INTO ticket (ticket_id, order_id, flight_id, seat_no, meal_preferences, source, destination, date_of_travel, class)
  VALUES (1, 'ORD-001', 100, 'A01', 'Vegetarian', 'New York', 'Los Angeles', TO_DATE('2023-04-01', 'YYYY-MM-DD'), 'Business');
  
  INSERT INTO ticket (ticket_id, order_id, flight_id, seat_no, meal_preferences, source, destination, date_of_travel, class)
  VALUES (2, 'ORD-002', 200, 'A02', 'Non-vegetarian', 'Los Angeles', 'New York', TO_DATE('2023-04-02', 'YYYY-MM-DD'), 'First Class');
  
  INSERT INTO ticket (ticket_id, order_id, flight_id, seat_no, meal_preferences, source, destination, date_of_travel, class)
  VALUES (3, 'ORD-003', 300, 'B01', 'Vegetarian', 'Chicago', 'San Francisco', TO_DATE('2023-04-03', 'YYYY-MM-DD'), 'Economy');
  
  INSERT INTO ticket (ticket_id, order_id, flight_id, seat_no, meal_preferences, source, destination, date_of_travel, class)
  VALUES (4, 'ORD-004', 400, 'B02', 'Non-vegetarian', 'San Francisco', 'Chicago', TO_DATE('2023-04-04', 'YYYY-MM-DD'), 'Business');
  
  INSERT INTO ticket (ticket_id, order_id, flight_id, seat_no, meal_preferences, source, destination, date_of_travel, class)
  VALUES (5, 'ORD-005', 500, 'C01', 'Vegetarian', 'Miami', 'Denver', TO_DATE('2023-04-05', 'YYYY-MM-DD'), 'First Class');
  
  COMMIT;
END;
/
*/
select * from ticket;

BEGIN
  INSERT INTO ticket (ticket_id, order_id, flight_id, seat_no, meal_preferences, source, destination, date_of_travel, class, payment_type, member_id, transaction_amount)
  VALUES (1, 'ORD1234', 101, 'A1', 'Vegetarian', 'LAX', 'JFK', TO_DATE('2023-04-15', 'YYYY-MM-DD'), 'Economy', 'Credit Card', 5678, 350.00);
  
  INSERT INTO ticket (ticket_id, order_id, flight_id, seat_no, meal_preferences, source, destination, date_of_travel, class, payment_type, member_id, transaction_amount)
  VALUES (2, 'ORD5678', 202, 'B2', 'Kosher', 'JFK', 'LAX', TO_DATE('2023-04-30', 'YYYY-MM-DD'), 'Business', 'PayPal', 1234, 750.00);
  
  INSERT INTO ticket (ticket_id, order_id, flight_id, seat_no, meal_preferences, source, destination, date_of_travel, class, payment_type, member_id, transaction_amount)
  VALUES (3, 'ORD9012', 303, 'C3', 'No Preference', 'SFO', 'ATL', TO_DATE('2023-05-01', 'YYYY-MM-DD'), 'First', 'Debit Card', 9101, 1200.00);
  
  INSERT INTO ticket (ticket_id, order_id, flight_id, seat_no, meal_preferences, source, destination, date_of_travel, class, payment_type, member_id, transaction_amount)
  VALUES (4, 'ORD3456', 404, 'D4', 'Gluten Free', 'ATL', 'SFO', TO_DATE('2023-05-15', 'YYYY-MM-DD'), 'Economy', 'Cash', 2345, 250.00);
  
  INSERT INTO ticket (ticket_id, order_id, flight_id, seat_no, meal_preferences, source, destination, date_of_travel, class, payment_type, member_id, transaction_amount)
  VALUES (5, 'ORD7890', 505, 'E5', 'Vegetarian', 'LAX', 'JFK', TO_DATE('2023-05-30', 'YYYY-MM-DD'), 'Business', 'Credit Card', 6789, 850.00);
  
  COMMIT;
END;
/
CREATE OR REPLACE VIEW monthly_ticket_sales AS
SELECT 
  TO_CHAR(date_of_travel, 'YYYY-MM') AS month_of_travel,
  COUNT(*) AS num_tickets_sold,
  SUM(transaction_amount) AS total_sales_amount
FROM 
  ticket
GROUP BY 
  TO_CHAR(date_of_travel, 'YYYY-MM');
/*Airport_Staff*/

DECLARE
  table_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO table_exists FROM user_tables WHERE table_name = 'AIRLINE_STAFF';
  IF table_exists = 0 THEN
    EXECUTE IMMEDIATE 'CREATE TABLE airline_staff (
    staff_id       NUMBER PRIMARY KEY,
    airline_id     NUMBER,
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
BEGIN
  INSERT INTO airline_staff (staff_id, airline_id, first_name, last_name, address, ssn, email_id, contact_number, job_group, gender) VALUES
    (1, 101, 'John', 'Doe', '123 Main St', '123-45-6789', 'jdoe@email.com', 5551234, 'Group1', 'Male');
  INSERT INTO airline_staff (staff_id, airline_id, first_name, last_name, address, ssn, email_id, contact_number, job_group, gender) VALUES
    (2, 101, 'Jane', 'Smith', '456 Elm St', '234-56-7890', 'jsmith@email.com', 5552345, 'Group2', 'Female');
  INSERT INTO airline_staff (staff_id, airline_id, first_name, last_name, address, ssn, email_id, contact_number, job_group, gender) VALUES
    (3, 102, 'Bob', 'Johnson', '789 Oak St', '345-67-8901', 'bjohnson@email.com', 5553456, 'Group3', 'Male');
  INSERT INTO airline_staff (staff_id, airline_id, first_name, last_name, address, ssn, email_id, contact_number, job_group, gender) VALUES
    (4, 102, 'Mary', 'Lee', '12 Pine St', '456-78-9012', 'mlee@email.com', 5554567, 'Group4', 'Female');
  INSERT INTO airline_staff (staff_id, airline_id, first_name, last_name, address, ssn, email_id, contact_number, job_group, gender) VALUES
    (5, 103, 'Tom', 'Wilson', '345 Maple St', '567-89-0123', 'twilson@email.com', 5555678, 'Group5', 'Male');
END;
/