/*
This Package is used for onboarding airline_staff data
Airline staff is onboarded once airport and airline is added. Each staff has a unique ID.
*/

CREATE OR REPLACE PACKAGE airline_staff_pkg AS  
  FUNCTION check_airline_id_exists(in_airline_id in NUMBER) RETURN NUMBER;
  PROCEDURE insert_airline_staff(
    in_airline_id         IN NUMBER,
    in_first_name             IN VARCHAR2,
    in_last_name     IN VARCHAR2,
    in_address      IN VARCHAR2,
    in_ssn      IN VARCHAR2,
    in_email_id             IN VARCHAR2,
    in_contact_number   IN NUMBER,
    in_job_group          IN VARCHAR2,
    in_gender in VARCHAR2
  );
END airline_staff_pkg;
/

CREATE OR REPLACE PACKAGE BODY airline_staff_pkg AS
FUNCTION check_airline_id_exists(in_airline_id NUMBER)
RETURN NUMBER
AS
  v_airline_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_airline_count
  FROM AIRLINES
  WHERE AIRLINE_ID = in_airline_id;

  IF v_airline_count > 0 THEN
    RETURN in_airline_id;
  ELSE
    RETURN NULL;
  END IF;
END check_airline_id_exists;

PROCEDURE insert_airline_staff(
    in_airline_id         IN NUMBER,
    in_first_name             IN VARCHAR2,
    in_last_name     IN VARCHAR2,
    in_address      IN VARCHAR2,
    in_ssn      IN VARCHAR2,
    in_email_id             IN VARCHAR2,
    in_contact_number   IN NUMBER,
    in_job_group          IN VARCHAR2,
    in_gender in VARCHAR2
  ) IS
  INVALID_INPUTS EXCEPTION;
  airline_id_exists NUMBER;
  BEGIN
    IF in_airline_id IS NULL OR in_gender IS NULL OR in_first_name IS NULL OR in_last_name  IS NULL OR in_address IS NULL OR in_ssn IS NULL OR in_email_id IS NULL OR in_contact_number IS NULL OR in_job_group IS NULL THEN
      RAISE INVALID_INPUTS;
    END IF;
    --validate if airline ID exists before pushing into airline staff table
      airline_id_exists := check_airline_id_exists(in_airline_id);
      IF airline_id_exists IS NULL then
        DBMS_OUTPUT.PUT_LINE('Airline ID does not exist');
        RETURN;
      END IF;
     -- Validate gender
    IF in_gender NOT IN ('Male', 'Female', 'Other') THEN
      DBMS_OUTPUT.PUT_LINE('Sex must be specified as male, female, or other');
      RETURN;
    END IF;
     -- Validate job group
    IF in_job_group NOT IN (1,2,3,4,5) THEN
      DBMS_OUTPUT.PUT_LINE('Incorrect job group');
      RETURN;
    END IF;
    -- Validate SSN input
   IF REGEXP_LIKE(in_ssn, '^((?!219-09-9999|078-05-1120)(?!666|000|9\d{2})\d{3}-(?!00)\d{2}-(?!0{4})\d{4})|((?!219 09 9999|078 05 1120)(?!666|000|9\d{2})\d{3} (?!00)\d{2} (?!0{4})\d{4})|((?!219099999|078051120)(?!666|000|9\d{2})\d{3}(?!00)\d{2}(?!0{4})\d{4})$') = FALSE THEN
      DBMS_OUTPUT.PUT_LINE('Invalid SSN format');
      RETURN;
   END IF;
     -- Validate first name input
    IF REGEXP_LIKE(in_first_name, '/^[a-zA-Z]+$ /') = FALSE THEN
        DBMS_OUTPUT.PUT_LINE('Invalid first name');
        RETURN;
    END IF;
      -- Validate last name input
    IF REGEXP_LIKE(in_last_name, '/^[a-zA-Z]+$ /') = FALSE THEN
        DBMS_OUTPUT.PUT_LINE('Invalid last name');
        RETURN;
    END IF;

    -- Validate contact_number input
    IF LENGTH(in_contact_number) != 10 THEN
      DBMS_OUTPUT.PUT_LINE('Contact Number must be a 10-digit value');
      RETURN;
    END IF;
    -- Validate address input
    IF REGEXP_LIKE(in_address, '^[0-9]{1,5} [a-zA-Z0-9\s]{1,50}, [a-zA-Z\s]{2,50}, [A-Z]{2} [0-9]{5}$') = FALSE THEN
      DBMS_OUTPUT.PUT_LINE('Address must be in the format ex., 23 XYZ, Boston, MA 02115');
      RETURN;
    END IF;
    -- Validate email input
    IF REGEXP_LIKE(in_email_id, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') = FALSE THEN
      DBMS_OUTPUT.PUT_LINE('Invalid email format');
      RETURN;
    END IF;
    INSERT INTO airline_staff (
     staff_id,
    airline_id,
    first_name,
    last_name,
    address,
    ssn,
    email_id,
    contact_number,
    job_group,
    gender
    ) VALUES (
    ADMIN.airline_staff_seq.NEXTVAL,
    in_airline_id,
    in_first_name,
    in_last_name,
    in_address,
    in_ssn,
    in_email_id,
    in_contact_number,
    in_job_group,
    in_gender
    );
   COMMIT;
   EXCEPTION
      DBMS_OUTPUT.PUT_LINE('An error occurred while inserting data');
      rollback;
      RETURN;
      
  END insert_airline_staff;

END airline_staff_pkg;
/

SHOW ERRORS;
