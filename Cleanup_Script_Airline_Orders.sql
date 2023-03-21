/*
The Below block of code creates the FLIGHTS table. As an additional layer of
validation, the script is executed only if the table does not exist.
*/
show user;
declare
    v_table_exists varchar(1) := 'Y';
    v_sql varchar(2000);
begin
   dbms_output.put_line('Start schema cleanup');
   for i in (select 'FLIGHT' table_name from dual UNION ALL
             select 'PASSENGER' table_name from dual UNION ALL
             select 'ORDER' table_name from dual UNION ALL
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


INSERT INTO airlines (airline_id, route_number, airline_code, airline_name)  
VALUES (ADMIN.my_sequence.NEXTVAL, ADMIN.airline_route_sequence.NEXTVAL, 'AA', 'American Airlines');
INSERT INTO airlines (airline_id, route_number, airline_code, airline_name)  
VALUES (ADMIN.my_sequence.NEXTVAL,ADMIN.airline_route_sequence.NEXTVAL, 'DL', 'Delta Air Lines');
INSERT INTO airlines (airline_id, route_number, airline_code, airline_name)  
VALUES (ADMIN.my_sequence.NEXTVAL, ADMIN.airline_route_sequence.NEXTVAL, 'UA', 'United Airlines') ;
INSERT INTO airlines (airline_id, route_number, airline_code, airline_name)  
VALUES (ADMIN.my_sequence.NEXTVAL, ADMIN.airline_route_sequence.NEXTVAL, 'WN', 'Southwest Airlines') ;
INSERT INTO airlines (airline_id, route_number, airline_code, airline_name)  
VALUES (ADMIN.my_sequence.NEXTVAL, ADMIN.airline_route_sequence.NEXTVAL, 'AS', 'Alaska Airlines') ;
INSERT INTO airlines (airline_id, route_number, airline_code, airline_name)  
VALUES (ADMIN.my_sequence.NEXTVAL, ADMIN.airline_route_sequence.NEXTVAL, 'B6', 'JetBlue Airways');
INSERT INTO airlines (airline_id, route_number, airline_code, airline_name)  
VALUES (ADMIN.my_sequence.NEXTVAL, ADMIN.airline_route_sequence.NEXTVAL, 'NK', 'Spirit Airlines');
INSERT INTO airlines (airline_id, route_number, airline_code, airline_name)  
VALUES (ADMIN.my_sequence.NEXTVAL, ADMIN.airline_route_sequence.NEXTVAL, 'F9', 'Frontier Airlines');
INSERT INTO airlines (airline_id, route_number, airline_code, airline_name)  
VALUES (ADMIN.my_sequence.NEXTVAL, ADMIN.airline_route_sequence.NEXTVAL, 'G4', 'Allegiant Air');
INSERT INTO airlines (airline_id, route_number, airline_code, airline_name)  
VALUES (ADMIN.my_sequence.NEXTVAL, ADMIN.airline_route_sequence.NEXTVAL, 'SY', 'IndiGo Airlines');


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
--CREATE TABLE "order" ( 
--      order_id NUMBER PRIMARY KEY, 
--      passenger_id NUMBER, 
--      amount FLOAT, 
--      status VARCHAR2(20) 
--    )
-- Generating 10 insert statements 
DECLARE 
  passenger_id NUMBER := 1; 
BEGIN 
  FOR i IN 1..10 LOOP 
    INSERT INTO orders (order_id, passenger_id, amount, status) 
    VALUES (ADMIN.orders_seq.NEXTVAL, passenger_id, 100.00, 'Pending'); 
    passenger_id := passenger_id + 1; 
  END LOOP; 
END; 
/
Select * from orders;
