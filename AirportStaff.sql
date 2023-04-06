CREATE OR REPLACE PACKAGE airline_pkg AS
  
  -- Insert a new record
  PROCEDURE insert_airline(
    airline_id IN airlines.airline_id%TYPE,
    route_number IN airlines.route_number%TYPE,
    airline_code IN airlines.airline_code%TYPE,
    airline_name IN airlines.airline_name%TYPE
  );
  
  -- Update an existing record
  PROCEDURE update_airline(
    airline_id IN airlines.airline_id%TYPE,
    airline_name IN airlines.airline_name%TYPE
  );
  
  -- Delete an existing record
  PROCEDURE delete_airline(
    airline_id IN airlines.airline_id%TYPE
  );
  
  -- Select all records
  FUNCTION get_airlines RETURN SYS_REFCURSOR;
  
END airline_pkg;
/
CREATE OR REPLACE PACKAGE BODY airline_pkg AS
  
  -- Insert a new record
  PROCEDURE insert_airline(
    airline_id IN airlines.airline_id%TYPE,
    route_number IN airlines.route_number%TYPE,
    airline_code IN airlines.airline_code%TYPE,
    airline_name IN airlines.airline_name%TYPE
  ) AS
  BEGIN
    INSERT INTO airlines (airline_id, route_number, airline_code, airline_name)
    VALUES (airline_id, route_number, airline_code, airline_name);
  END insert_airline;
  
  -- Update an existing record
  PROCEDURE update_airline(
    airline_id IN airlines.airline_id%TYPE,
    airline_name IN airlines.airline_name%TYPE
  ) AS
  BEGIN
    UPDATE airlines
    SET airline_name = airline_name
    WHERE airline_id = airline_id;
  END update_airline;
  
  -- Delete an existing record
  PROCEDURE delete_airline(
    airline_id IN airlines.airline_id%TYPE
  ) AS
  BEGIN
    DELETE FROM airlines
    WHERE airline_id = airline_id;
  END delete_airline;
  
  -- Select all records
  FUNCTION get_airlines RETURN SYS_REFCURSOR AS
    airline_cur SYS_REFCURSOR;
  BEGIN
    OPEN airline_cur FOR SELECT * FROM airlines;
    RETURN airline_cur;
  END get_airlines;
  
END airline_pkg;
/
