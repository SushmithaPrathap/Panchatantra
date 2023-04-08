CREATE OR REPLACE PACKAGE airline_pkg AS

  PROCEDURE insert_airline (
    v_airline_code IN VARCHAR2,
    v_airline_name IN VARCHAR2
  );

END airline_pkg;
/

CREATE OR REPLACE PACKAGE BODY airline_pkg AS

  PROCEDURE insert_airline (
    v_airline_code IN VARCHAR2,
    v_airline_name IN VARCHAR2
  )
  IS
  BEGIN
    IF v_airline_code IS NULL OR v_airline_name IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001, 'All input parameters must be specified');
    END IF;
    IF REGEXP_LIKE(v_airline_code, '^[a-zA-Z0-9]{2}$') = FALSE THEN
      RAISE_APPLICATION_ERROR(-20006, 'Invalid airline code format');
    END IF;
    INSERT INTO airlines (airline_id, route_number, airline_code, airline_name)
    VALUES (admin.airline_seq.nextval, admin.airline_route_sequence.nextval, v_airline_code, v_airline_name);
    COMMIT;
  END;

END airline_pkg;
/