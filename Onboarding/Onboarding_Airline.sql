CREATE OR REPLACE PACKAGE airline_pkg AS

  PROCEDURE insert_airline (
    v_airline_code IN VARCHAR2,
    v_airline_name IN VARCHAR2
  );

END airline_pkg;
/
SELECT admin.airline_seq.NEXTVAL FROM dual;

CREATE OR REPLACE PACKAGE BODY airline_pkg AS

  PROCEDURE insert_airline (
    v_airline_code IN VARCHAR2,
    v_airline_name IN VARCHAR2
  )
  IS
  v_count INTEGER;
  BEGIN
    IF v_airline_code IS NULL OR v_airline_name IS NULL THEN
      --RAISE_APPLICATION_ERROR(-20001, 'All input parameters must be specified');
      DBMS_OUTPUT.PUT_LINE('All input parameters must be specified');
    END IF;
    IF REGEXP_LIKE(v_airline_code, '^[a-zA-Z0-9]{2}$') = FALSE THEN
      DBMS_OUTPUT.PUT_LINE('Invalid airline code format');
      --RAISE_APPLICATION_ERROR(-20006, 'Invalid airline code format');
    END IF;
    SELECT COUNT(*) INTO v_count FROM airlines WHERE airline_code = v_airline_code;
    IF v_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Airline code already exists');
    RETURN;
    END IF;
    INSERT INTO airlines (airline_id, route_number, airline_code, airline_name)
    VALUES (admin.airline_seq.nextval, admin.airline_route_sequence.nextval, v_airline_code, v_airline_name);
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error occured while inserting airline');
    rollback;
  END;

END airline_pkg;
/