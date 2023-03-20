
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
---
-- CREATE A SEQUENCE FROM ADMIN?
CREATE SEQUENCE order_id_seq
  MINVALUE 1
  MAXVALUE 100
  START WITH 1
  INCREMENT BY 1
  CACHE 100;
-- CHECK  
SELECT order_id_seq.NEXTVAL FROM DUAL;
 select * from dba_tab_privs where table_name = 'order_id_seq';
-- ASSIGNING SEQUENCE TO USER
grant select on order_id_seq to abhi;
--RESET
alter sequence order_id_seq restart start with 1;
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



