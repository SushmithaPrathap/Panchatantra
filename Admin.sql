
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

-- grant privileges on specific objects
--GRANT ALL PRIVILEGES ON <table_name> TO AirportAdmin;
--GRANT ALL PRIVILEGES ON <sequence_name> TO AirportAdmin;
--GRANT ALL PRIVILEGES ON <procedure_name> TO AirportAdmin;
--GRANT ALL PRIVILEGES ON <trigger_name> TO AirportAdmin;

---- grant roles
--GRANT DBA TO AirportAdmin;

