/*
This Package is used for inserting airline_staff data
After a airline_staff signs up an Order gets generated in the order table
When a airline_staff deetes a ticket the number of airline_staffs on a flight reduces
*/
CREATE OR REPLACE PACKAGE airline_staff_pkg AS  
  PROCEDURE insert_airline_staff(
    in_staff_id              IN NUMBER,
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
PROCEDURE insert_airline_staff(
    in_staff_id              IN NUMBER,
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
  BEGIN
    IF in_staff_id IS NULL OR in_airline_id IS NULL OR in_gender IS NULL OR in_first_name IS NULL OR in_last_name  IS NULL OR in_address IS NULL OR in_ssn IS NULL OR in_email_id IS NULL OR in_contact_number IS NULL OR in_job_group IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001, 'All input parameters must be specified');
    END IF;  
    IF in_gender NOT IN ('Male', 'Female', 'Other') THEN
      RAISE_APPLICATION_ERROR(-20002, 'Gender must be specified as male, female, or other');
    END IF;
    IF in_job_group NOT IN (1,2,3,4,5) THEN
      RAISE_APPLICATION_ERROR(-20002, 'Incorrect job group');
    END IF;
    -- Validate SSN input
    IF REGEXP_LIKE(in_ssn, '^((?!219-09-9999|078-05-1120)(?!666|000|9\d{2})\d{3}-(?!00)\d{2}-(?!0{4})\d{4})|((?!219 09 9999|078 05 1120)(?!666|000|9\d{2})\d{3} (?!00)\d{2} (?!0{4})\d{4})|((?!219099999|078051120)(?!666|000|9\d{2})\d{3}(?!00)\d{2}(?!0{4})\d{4})$') = FALSE THEN
      RAISE_APPLICATION_ERROR(-20006, 'Invalid SSN format');
    END IF;
    IF REGEXP_LIKE(in_first_name, '/^[a-zA-Z]+$/') = FALSE THEN
      RAISE_APPLICATION_ERROR(-20006, 'Invalid first name');
    END IF;
    IF REGEXP_LIKE(in_last_name, '/^[a-zA-Z]+$/') = FALSE THEN
      RAISE_APPLICATION_ERROR(-20006, 'Invalid last name');
    END IF;
    -- Validate contact_number input
    IF LENGTH(in_contact_number) != 10 THEN
      RAISE_APPLICATION_ERROR(-20004, 'Contact Number must be a 10-digit value');
    END IF;
    IF REGEXP_LIKE(in_address, '^[0-9]{1,5} [a-zA-Z0-9\s]{1,50}, [a-zA-Z\s]{2,50}, [A-Z]{2} [0-9]{5}$') = FALSE THEN
      RAISE_APPLICATION_ERROR(-20004, 'Contact Number must be a 10-digit value');
    END IF;
    
    -- Validate email input
    IF REGEXP_LIKE(in_email_id _email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') = FALSE THEN
      RAISE_APPLICATION_ERROR(-20006, 'Invalid email format');
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
     in_staff_id,
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
    
  END insert_airline_staff;

END airline_staff_pkg;
/

SHOW ERRORS;