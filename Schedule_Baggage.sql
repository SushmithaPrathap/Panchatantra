WHENEVER SQLERROR EXIT SQL.SQLCODE
show user;

set serveroutput on
declare
    v_table_exists varchar(1) := 'Y';
    v_sql varchar(2000);
begin
   dbms_output.put_line('Start schema cleanup');
   for i in (select 'SCHEDULE' table_name from dual union all
             select 'BAGGAGE' table_name from dual
   )
   loop
   dbms_output.put_line('....Drop table '||i.table_name);
   begin
       select 'Y' into v_table_exists
       from USER_TABLES
       where TABLE_NAME=i.table_name;

       v_sql := 'drop table '|| i.table_name;
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

WHENEVER SQLERROR EXIT SQL.SQLCODE
show user;

DECLARE
  table_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO table_exists FROM user_tables WHERE table_name = 'SCHEDULE';
  IF table_exists = 0 THEN
   EXECUTE IMMEDIATE 'CREATE TABLE schedule (
  schedule_id NUMBER PRIMARY KEY,
  flight_id NUMBER,
  terminal_id NUMBER,
  arrival_time DATE,
  departure_time DATE
)';
    dbms_output.put_line('Table schedule has been created');
  ELSE
    dbms_output.put_line('Table schedule already exists');
  END IF;
END;
/
DECLARE
  i NUMBER := 1;
BEGIN
  INSERT INTO schedule (schedule_id, flight_id, terminal_id, Arrival_time, Departure_time) 
  VALUES (1, 1001, 1, TO_DATE('2023-03-22 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-03-22 11:45:00', 'YYYY-MM-DD HH24:MI:SS'));

  INSERT INTO schedule (schedule_id, flight_id, terminal_id, arrival_time, departure_time)  
  VALUES (2, 1002,  1, TO_DATE('2023-03-22 12:15:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-03-22 13:30:00', 'YYYY-MM-DD HH24:MI:SS')); 
 
  INSERT INTO schedule (schedule_id, flight_id, terminal_id, arrival_time, departure_time)  
  VALUES (3, 1003,  2, TO_DATE('2023-03-22 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-03-22 15:15:00', 'YYYY-MM-DD HH24:MI:SS')); 
 
  INSERT INTO schedule (schedule_id, flight_id, terminal_id, arrival_time, departure_time)  
  VALUES (4, 1004,  3, TO_DATE('2023-03-23 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-03-23 11:45:00', 'YYYY-MM-DD HH24:MI:SS')); 
 
  INSERT INTO schedule (schedule_id, flight_id, terminal_id, arrival_time, departure_time)  
  VALUES (5, 1005,  2, TO_DATE('2023-03-23 12:15:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-03-23 13:30:00', 'YYYY-MM-DD HH24:MI:SS')); 
 
  INSERT INTO schedule (schedule_id, flight_id, terminal_id, arrival_time, departure_time)  
  VALUES (6, 1006,  3, TO_DATE('2023-04-01 08:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-04-01 09:45:00', 'YYYY-MM-DD HH24:MI:SS')); 
 
  INSERT INTO schedule (schedule_id, flight_id, terminal_id, arrival_time, departure_time)  
  VALUES (7, 1007,  2, TO_DATE('2023-04-02 12:15:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-04-02 13:20:00', 'YYYY-MM-DD HH24:MI:SS')); 
 
  INSERT INTO schedule (schedule_id, flight_id, terminal_id, arrival_time, departure_time)  
  VALUES (8, 1008,  1, TO_DATE('2023-04-03 16:45:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-04-03 18:10:00', 'YYYY-MM-DD HH24:MI:SS')); 
 
  INSERT INTO schedule (schedule_id, flight_id, terminal_id, arrival_time, departure_time)  
  VALUES (9, 1009,  4,TO_DATE('2023-04-04 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-04-04 11:45:00', 'YYYY-MM-DD HH24:MI:SS')); 
 
  INSERT INTO schedule (schedule_id, flight_id, terminal_id, arrival_time, departure_time)  
  VALUES (10, 1010,  2, TO_DATE('2023-04-05 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-04-05 15:05:00', 'YYYY-MM-DD HH24:MI:SS'));
  
  COMMIT;
END;
/

-- CREATING VIEW
/*
The Below block of code creates views from the SCHEDULE table
-- View 1: Retrieve all schedule details of flights taking off from a terminal
*/
BEGIN
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW  flight_per_terminal AS
    SELECT schedule_id, flight_id, terminal_id, arrival_time, departure_time
    FROM Schedule WHERE terminal_id = 2 GROUP BY flight_id';
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

-- CREATING VIEW
/*
The Below block of code creates views from the SCHEDULE table
-- View 1: Retrieve all schedule details of flights taking off from a terminal
*/
BEGIN
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW  flight_at_aTime AS
    SELECT schedule_id, flight_id, terminal_id, arrival_time, departure_time
    FROM Schedule WHERE arrival_time < TO_DATE(''2023-04-02 12:15:00'', ''YYYY-MM-DD HH24:MI:SS'') ';
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

DECLARE
  table_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO table_exists FROM user_tables WHERE table_name = 'BAGGAGE';
  IF table_exists = 0 THEN
    EXECUTE IMMEDIATE 'CREATE TABLE baggage (
    baggage_id       NUMBER PRIMARY KEY,
    ticket_id     NUMBER,
    weight        FLOAT
)';
    dbms_output.put_line('Table Baggage has been created');
  ELSE
    dbms_output.put_line('Table Baggage already exists');
  END IF;
END;
/

/*
Stored Procedure for updating baggage weight based on the class
*/
 CREATE OR REPLACE PROCEDURE insert_baggage (
    p_baggage_id IN NUMBER,
    p_ticket_id IN NUMBER
)
IS
    v_weight FLOAT;
    v_ticket_class VARCHAR2(20);
BEGIN
    SELECT class INTO v_ticket_class FROM ticket WHERE ticket_id = p_ticket_id;
    
    IF v_ticket_class = 'business' THEN
        v_weight := 200.00;
    ELSE
        v_weight := 100.00;
    END IF;
    
    INSERT INTO baggage (
        baggage_id,
        ticket_id,
        weight
    ) VALUES (
        p_baggage_id,
        p_ticket_id,
        v_weight
    );

  -- UPDATE baggage
  -- SET status = v_weight
  -- WHERE ticket_id = p_ticket_id;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Baggage ' || p_baggage_id || ' weight updated to ' || v_weight);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No ticket found with ID ' || p_ticket_id);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inserting baggage record: ' || SQLERRM);
        ROLLBACK;
END insert_baggage;
/
CREATE SEQUENCE ticket_id_seq 
START WITH 100 
INCREMENT BY 1; 

CREATE SEQUENCE baggage_id_seq 
START WITH 1 
INCREMENT BY 1; 
 
-- Generating 10 insert statements 
DECLARE 
  bag_id NUMBER := 1; 
BEGIN 
  FOR i IN 1..10 LOOP 
  --  INSERT INTO baggage (baggage_id, ticket_id, weight) 
  --  VALUES (baggage_id_seq.NEXTVAL, ticket_id_seq.NEXTVAL, 100.00);
    insert_baggage(baggage_id_seq.NEXTVAL, ticket_id_seq.NEXTVAL);
  END LOOP; 
END; 

-- CREATING VIEW
/*
The Below block of code creates views from the BAGGAGE table
-- View 1: Retrieve all baggage details
*/
BEGIN
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW  baggage_transaction AS
    SELECT baggage_id, weight, ticket_id
    FROM baggage';
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/


 
-- INSERT INTO schedule (schedule_id, flight_id, terminal_id, Arrival_time, Departure_time) 
-- VALUES (schedule_id_sequence.NEXTVAL, flight_id_sequence.NEXTVAL, 'T1', TO_DATE('2023-03-22 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-03-22 11:45:00', 'YYYY-MM-DD HH24:MI:SS'));

-- INSERT INTO schedule (schedule_id, flight_id, terminal_id, arrival_time, departure_time)  
-- VALUES (schedule_id_sequence.NEXTVAL, flight_id_sequence.NEXTVAL,  'T1', TO_DATE('2023-03-22 12:15:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-03-22 13:30:00', 'YYYY-MM-DD HH24:MI:SS')); 
 
-- INSERT INTO schedule (schedule_id, flight_id, terminal_id, arrival_time, departure_time)  
-- VALUES (schedule_id_sequence.NEXTVAL, flight_id_sequence.NEXTVAL,  'T2', TO_DATE('2023-03-22 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-03-22 15:15:00', 'YYYY-MM-DD HH24:MI:SS')); 
 
-- INSERT INTO schedule (schedule_id, flight_id, terminal_id, arrival_time, departure_time)  
-- VALUES (schedule_id_sequence.NEXTVAL, flight_id_sequence.NEXTVAL,  'T3', TO_DATE('2023-03-23 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-03-23 11:45:00', 'YYYY-MM-DD HH24:MI:SS')); 
 
-- INSERT INTO schedule (schedule_id, flight_id, terminal_id, arrival_time, departure_time)  
-- VALUES (schedule_id_sequence.NEXTVAL, flight_id_sequence.NEXTVAL,  'T2', TO_DATE('2023-03-23 12:15:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-03-23 13:30:00', 'YYYY-MM-DD HH24:MI:SS')); 
 
-- INSERT INTO schedule (schedule_id, flight_id, terminal_id, arrival_time, departure_time)  
-- VALUES (schedule_id_sequence.NEXTVAL, flight_id_sequence.NEXTVAL,  'T3', TO_DATE('2023-04-01 08:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-04-01 09:45:00', 'YYYY-MM-DD HH24:MI:SS')); 
 
-- INSERT INTO schedule (schedule_id, flight_id, terminal_id, arrival_time, departure_time)  
-- VALUES (schedule_id_sequence.NEXTVAL, flight_id_sequence.NEXTVAL,  'T2', TO_DATE('2023-04-02 12:15:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-04-02 13:20:00', 'YYYY-MM-DD HH24:MI:SS')); 
 
-- INSERT INTO schedule (schedule_id, flight_id, terminal_id, arrival_time, departure_time)  
-- VALUES (schedule_id_sequence.NEXTVAL, flight_id_sequence.NEXTVAL,  'T1', TO_DATE('2023-04-03 16:45:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-04-03 18:10:00', 'YYYY-MM-DD HH24:MI:SS')); 
 
-- INSERT INTO schedule (schedule_id, flight_id, terminal_id, arrival_time, departure_time)  
-- VALUES (schedule_id_sequence.NEXTVAL, flight_id_sequence.NEXTVAL,  'T4',TO_DATE('2023-04-04 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-04-04 11:45:00', 'YYYY-MM-DD HH24:MI:SS')); 
 
-- INSERT INTO schedule (schedule_id, flight_id, terminal_id, arrival_time, departure_time)  
-- VALUES (schedule_id_sequence.NEXTVAL, flight_id_sequence.NEXTVAL,  'T2', TO_DATE('2023-04-05 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-04-05 15:05:00', 'YYYY-MM-DD HH24:MI:SS')); 



-- CREATE OR REPLACE PROCEDURE insert_baggage (
--     p_baggage_id IN NUMBER,
--     p_ticket_id IN NUMBER
-- )
-- IS
--     v_weight FLOAT;
--     v_ticket_class VARCHAR2(20);
-- BEGIN
--     SELECT class INTO v_ticket_class FROM ticket WHERE ticket_id = p_ticket_id;
    
--     IF v_ticket_class = 'business' THEN
--         v_weight := 200;
--     ELSE
--         v_weight := 100;
--     END IF;
    
--     INSERT INTO baggage (
--         baggage_id,
--         ticket_id,
--         weight
--     ) VALUES (
--         p_baggage_id,
--         p_ticket_id,
--         v_weight
--     );
    
--     COMMIT;
    
--     DBMS_OUTPUT.PUT_LINE('Baggage record inserted successfully.');
-- EXCEPTION
--     WHEN NO_DATA_FOUND THEN
--         DBMS_OUTPUT.PUT_LINE('No ticket found with ID ' || p_ticket_id);
--     WHEN OTHERS THEN
--         DBMS_OUTPUT.PUT_LINE('Error inserting baggage record: ' || SQLERRM);
--         ROLLBACK;
-- END insert_baggage;