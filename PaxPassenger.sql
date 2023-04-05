/*
This Package is used for inserting and Updating passenger data
After a passenger signs up an Order gets generated in the order table
*/

CREATE OR REPLACE PACKAGE passenger_pkg AS
  PROCEDURE insert_passenger(
    p_age              IN NUMBER,
    p_address          IN VARCHAR2,
    p_sex              IN VARCHAR2,
    p_govt_id_nos      IN VARCHAR2,
    p_first_name       IN VARCHAR2,
    p_last_name        IN VARCHAR2,
    p_dob              IN DATE,
    p_contact_number   IN VARCHAR2,
    p_email            IN VARCHAR2
  );
  PROCEDURE update_passenger(
    p_passenger_id     IN NUMBER DEFAULT NULL,
    p_age              IN NUMBER,
    p_address          IN VARCHAR2,
    p_sex              IN VARCHAR2,
    p_govt_id_nos      IN VARCHAR2,
    p_first_name       IN VARCHAR2,
    p_last_name        IN VARCHAR2,
    p_dob              IN DATE,
    p_contact_number   IN VARCHAR2,
    p_email            IN VARCHAR2
  );
END passenger_pkg;
/

CREATE OR REPLACE PACKAGE BODY passenger_pkg AS
PROCEDURE insert_passenger(
    p_age              IN NUMBER,
    p_address          IN VARCHAR2,
    p_sex              IN VARCHAR2,
    p_govt_id_nos      IN VARCHAR2,
    p_first_name       IN VARCHAR2,
    p_last_name        IN VARCHAR2,
    p_dob              IN DATE,
    p_contact_number   IN VARCHAR2,
    p_email            IN VARCHAR2
  ) IS
  BEGIN
    IF p_age IS NULL OR p_address IS NULL OR p_sex IS NULL OR p_govt_id_nos IS NULL OR p_first_name IS NULL OR p_last_name IS NULL OR p_dob IS NULL OR p_contact_number IS NULL OR p_email IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001, 'All input parameters must be specified');
    END IF;  
    IF p_sex NOT IN ('Male', 'Female', 'Other') THEN
      RAISE_APPLICATION_ERROR(-20002, 'Sex must be specified as male, female, or other');
    END IF;
    
    -- Validate gov_id_nos input
    IF LENGTH(p_govt_id_nos) != 10 THEN
      RAISE_APPLICATION_ERROR(-20003, 'Govt ID Number must be a 10-digit value');
    END IF;
    
    -- Validate contact_number input
    IF LENGTH(p_contact_number) != 10 THEN
      RAISE_APPLICATION_ERROR(-20004, 'Contact Number must be a 10-digit value');
    END IF;
    
--    -- Validate dob input
--    BEGIN
--      SELECT TO_DATE(p_dob, 'YYYY-MM-DD') FROM dual;
--    EXCEPTION
--      WHEN OTHERS THEN
--        RAISE_APPLICATION_ERROR(-20005, 'DOB must be specified in the format YYYY-MM-DD');
--    END;
    
    -- Validate email input
    IF REGEXP_LIKE(p_email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') = FALSE THEN
      RAISE_APPLICATION_ERROR(-20006, 'Invalid email format');
    END IF;

    INSERT INTO PASSENGER (
      passenger_id,
      age,
      address,
      sex,
      govt_id_nos,
      first_name,
      last_name,
      dob,
      contact_number,
      email
    ) VALUES (
      admin.passenger_seq.nextval,
      p_age,
      p_address,
      p_sex,
      p_govt_id_nos,
      p_first_name,
      p_last_name,
      p_dob,
      p_contact_number,
      p_email
    );
    
    INSERT INTO orders (
      order_id,
      passenger_id,
      amount,
      status
    ) VALUES (
      admin.orders_seq.nextval,
      admin.passenger_seq.currval,
      0,
      'PENDING'
    );
    
  END insert_passenger;

  
PROCEDURE update_passenger(
    p_passenger_id     IN NUMBER ,
    p_age              IN NUMBER,
    p_address          IN VARCHAR2,
    p_sex              IN VARCHAR2,
    p_govt_id_nos      IN VARCHAR2,
    p_first_name       IN VARCHAR2,
    p_last_name        IN VARCHAR2,
    p_dob              IN DATE,
    p_contact_number   IN VARCHAR2,
    p_email            IN VARCHAR2
  ) IS
    v_passenger_id NUMBER;
  BEGIN
    IF p_passenger_id IS NULL THEN
      -- Prompt user to enter passenger ID
      dbms_output.put('Please enter the passenger ID: ');
    
    ELSIF p_passenger_id IS NULL or p_age IS NULL OR p_address IS NULL OR p_sex IS NULL OR p_govt_id_nos IS NULL OR p_first_name IS NULL OR p_last_name IS NULL OR p_dob IS NULL OR p_contact_number IS NULL OR p_email IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001, 'All input parameters must be specified');
      
    ELSIF p_sex NOT IN ('Male', 'Female', 'Other') THEN
      RAISE_APPLICATION_ERROR(-20002, 'Sex must be specified as male, female, or other');

    -- Validate gov_id_nos input
    ELSIF LENGTH(p_govt_id_nos) != 10 THEN
      RAISE_APPLICATION_ERROR(-20003, 'Govt ID Number must be a 10-digit value');
    -- Validate contact_number input
    ELSIF LENGTH(p_contact_number) != 10 THEN
      RAISE_APPLICATION_ERROR(-20004, 'Contact Number must be a 10-digit value');

    
--    -- Validate dob input
--    BEGIN
--      SELECT TO_DATE(p_dob, 'YYYY-MM-DD') FROM dual;
--    EXCEPTION
--      WHEN OTHERS THEN
--        RAISE_APPLICATION_ERROR(-20005, 'DOB must be specified in the format YYYY-MM-DD');
--    END;
    
    -- Validate email input
    ELSIF REGEXP_LIKE(p_email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') = FALSE THEN
      RAISE_APPLICATION_ERROR(-20006, 'Invalid email format');

    ELSE
      v_passenger_id := p_passenger_id;
    END IF;

    UPDATE PASSENGER
    SET
      age = p_age,
      address = p_address,
      sex = p_sex,
      govt_id_nos = p_govt_id_nos,
      first_name = p_first_name,
      last_name = p_last_name,
      dob = p_dob,
      contact_number = p_contact_number,
      email = p_email
    WHERE
      passenger_id = v_passenger_id;
  END update_passenger;

END passenger_pkg;
/

SHOW ERRORS;