
---Admin Scripts
show user;
-- create a new user - Airport_Admin
CREATE USER AirportAdmin IDENTIFIED BY AirportMainGuy2024;

-- grant necessary system privileges
GRANT CREATE SESSION TO AirportAdmin;
GRANT UNLIMITED TABLESPACE TO AirportAdmin;
GRANT CREATE TABLE TO AirportAdmin;
GRANT CREATE PROCEDURE TO AirportAdmin;
GRANT CREATE SEQUENCE TO AirportAdmin;
GRANT CREATE TRIGGER TO AirportAdmin;
GRANT CREATE ANY VIEW TO AirportAdmin;
---
-- CREATE A SEQUENCE FOR FLIGHT
CREATE SEQUENCE flight_seq
  MINVALUE 1
  MAXVALUE 10000
  START WITH 1
  INCREMENT BY 1
  CACHE 1000;
  
-- ASSIGNING SEQUENCE TO USER
grant select on flight_seq to AirportAdmin;  
-- CHECK  
SELECT flight_seq.NEXTVAL FROM DUAL;
SELECT flight_seq.CURRVAL from DUAL;
select * from dba_tab_privs where table_name = 'flight_seq';
--RESET
alter sequence flight_seq restart start with 1;

-- CREATE A SEQUENCE FOR PASSENGER
CREATE SEQUENCE passenger_seq
  MINVALUE 1
  MAXVALUE 10000
  START WITH 1
  INCREMENT BY 1
  CACHE 1000;
-- ASSIGNING SEQUENCE TO USER
grant select on passenger_seq to AirportAdmin;  
-- CHECK  
SELECT passenger_seq.NEXTVAL FROM DUAL;
select * from dba_tab_privs where table_name = 'passenger_seq';
--RESET
alter sequence passenger_seq restart start with 1;

-- grant privileges on specific objects
--GRANT ALL PRIVILEGES ON <table_name> TO AirportAdmin;
--GRANT ALL PRIVILEGES ON <sequence_name> TO AirportAdmin;
--GRANT ALL PRIVILEGES ON <procedure_name> TO AirportAdmin;
--GRANT ALL PRIVILEGES ON <trigger_name> TO AirportAdmin;

---- grant roles
--GRANT DBA TO AirportAdmin;

---Admin Scripts
show user;
-- create a new user - Airport_Admin
CREATE role Passenger;
GRANT SELECT ON table_name TO view_access;



