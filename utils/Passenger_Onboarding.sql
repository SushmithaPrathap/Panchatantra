/*
This Package is used for inserting Passenger data
After a passenger signs up an Order gets generated in the order table
When a passenger deetes a ticket the number of passengers on a flight reduces
*/
--ALTER TABLE ticket
--  PARALLEL(DEGREE 1);
CREATE OR REPLACE PACKAGE passenger_updating_pkg AS  
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
END passenger_updating_pkg;
/

CREATE OR REPLACE PACKAGE BODY passenger_updating_pkg AS
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
      RETURN;
    -- validate input parameters
    IF p_age IS NULL OR p_address IS NULL OR p_sex IS NULL OR p_govt_id_nos IS NULL OR p_first_name IS NULL OR p_last_name IS NULL OR p_dob IS NULL OR p_contact_number IS NULL OR p_email IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('All input parameters must be specified');
      RETURN;
    END IF;  
    IF p_sex NOT IN ('Male', 'Female', 'Other') THEN
      DBMS_OUTPUT.PUT_LINE('Sex must be specified as male, female, or other');
      RETURN;      
    END IF;
    IF LENGTH(p_govt_id_nos) != 10 THEN
      DBMS_OUTPUT.PUT_LINE('Govt ID Number must be a 10-digit value');
      RETURN;            
    END IF;
    IF LENGTH(p_contact_number) != 10 THEN
      DBMS_OUTPUT.PUT_LINE('Contact Number must be a 10-digit value');
      RETURN;          
    END IF;
    IF REGEXP_LIKE(p_email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') = FALSE THEN
      --RAISE_APPLICATION_ERROR(-20006, 'Invalid email format');
      DBMS_OUTPUT.PUT_LINE('Invalid email format');
      RETURN;       
    END IF;

    ELSE
      v_passenger_id := p_passenger_id;
    END IF;

    BEGIN
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
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No passenger found with the given ID');
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred while updating the passenger');
    END;
    
  END update_passenger;
END passenger_updating_pkg;
/

SHOW ERRORS;
