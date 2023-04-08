CREATE OR REPLACE PACKAGE airline_updating_pkg AS
  PROCEDURE update_airline(
    p_airline_id      IN NUMBER DEFAULT NULL,
    p_route_number    IN NUMBER,
    p_airline_code    IN VARCHAR2,
    p_airline_name    IN VARCHAR2
  );
END airline_updating_pkg;
/
CREATE OR REPLACE PACKAGE BODY airline_updating_pkg
AS
   PROCEDURE update_airline(
      p_airline_id      IN NUMBER,
      p_route_number    IN NUMBER,
      p_airline_code    IN VARCHAR2,
      p_airline_name    IN VARCHAR2
   )
   IS
   BEGIN
      IF p_airline_id IS NULL THEN
         dbms_output.put('Please enter the AIRLINE ID: ');
         Return;
      ELSEIF p_airline_id IS NULL OR p_route_number OR p_airline_code IS NULL OR p_airline_name IS NULL
         dbms_output.put('All input parameters must be specified');
         Return;
      UPDATE airlines
      SET airline_code = p_airline_code,
          airline_name = p_airline_name,
          route_number = p_route_number
      WHERE airline_id = p_airline_id;
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Airline information updated successfully.');
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('No record found for airline_id ' || p_airline_id || ' and route_number ' || p_route_number);
      WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('An error occurred while updating airline information.');
   END update_airline;
   
   BEGIN
      SELECT *
      INTO l_airline
      FROM airlines
      WHERE airline_id = p_airline_id
        AND route_number = p_route_number;
      RETURN l_airline;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('No record found for airline_id ' || p_airline_id || ' and route_number ' || p_route_number);
         RETURN NULL;
      WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('An error occurred while retrieving airline information.');
         RETURN NULL;
   END get_airline;
END airlines_pkg;
/
SHOW ERRORS;