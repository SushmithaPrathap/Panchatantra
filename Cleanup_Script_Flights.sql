--  Initial Cleanup Script

--CLEANUP SCRIPT
set serveroutput on
declare
    v_table_exists varchar(1) := 'Y';
    v_sql varchar(2000);
begin
   dbms_output.put_line('Start schema cleanup');
   for i in (select 'FLIGHT' table_name from dual
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
---- create table for flights
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
      no_pax NUMBER
    )';
    dbms_output.put_line('Table flight has been created');
  ELSE
    dbms_output.put_line('Table flight already exists');
  END IF;
END;
/


INSERT INTO flight (flight_id, duration, flight_type, departure_time, arrival_time, destination, source, status, no_pax)
SELECT 1, 120, 'Boeing 737', TO_TIMESTAMP('2023-03-21 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-03-21 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'New York', 'London', 'On Time', 200 from dual union all
SELECT 2, 180, 'Airbus A320', TO_TIMESTAMP('2023-03-22 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-03-22 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paris', 'Berlin', 'Delayed', 150 from dual union all
SELECT 3, 240, 'Boeing 747', TO_TIMESTAMP('2023-03-23 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-03-23 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Sydney', 'Singapore', 'On Time', 400 from dual union all
SELECT 4, 90, 'Embraer E175', TO_TIMESTAMP('2023-03-24 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-03-24 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Los Angeles', 'San Francisco', 'On Time', 80 from dual union all
SELECT 5, 150, 'Boeing 737', TO_TIMESTAMP('2023-03-25 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-03-25 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Toronto', 'Montreal', 'On Time', 180 from dual union all
SELECT 6, 120, 'Airbus A320', TO_TIMESTAMP('2023-03-26 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-03-26 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Berlin', 'Amsterdam', 'Delayed', 150 from dual union all
SELECT 7, 180, 'Boeing 787', TO_TIMESTAMP('2023-03-27 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-03-27 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Dubai', 'London', 'On Time', 300 from dual union all
SELECT 8, 90, 'Embraer E175', TO_TIMESTAMP('2023-03-28 17:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-03-28 19:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Miami', 'Orlando', 'On Time', 80 from dual union all
SELECT 9, 120, 'Airbus A320', TO_TIMESTAMP('2023-03-29 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-03-29 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Barcelona', 'Madrid','Cancelled',100 from dual union all
SELECT 10, 187, 'Airbus A380', TO_TIMESTAMP('2023-03-30 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-03-29 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Boston', 'Madrid','On Time',300 from dual;
--/
commit;

-- CREATING VIEW

-- View 1: Retrieve flight information with the departure and arrival locations swapped
CREATE VIEW swapped_flight_info AS
SELECT flight_id, duration, flight_type, arrival_time AS departure_time, departure_time AS arrival_time, source AS destination, destination AS source, status, no_pax
FROM flight;

-- View 2: Retrieve only delayed flights
CREATE VIEW delayed_flights AS
SELECT *
FROM flight
WHERE status = 'Delayed';
