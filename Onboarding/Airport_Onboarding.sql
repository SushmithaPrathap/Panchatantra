/*
This Package is used for inserting Airport data
*/
CREATE OR REPLACE PACKAGE airport_pkg AS  
  PROCEDURE insert_airport(
    a_airport_name     IN VARCHAR2,
    a_city             IN VARCHAR2,
    a_state            IN VARCHAR2,
    a_country          IN VARCHAR2
  );
END airport_pkg;
/

CREATE OR REPLACE PACKAGE BODY airport_pkg AS
PROCEDURE insert_airport(
    a_airport_name     IN VARCHAR2,
    a_city             IN VARCHAR2,
    a_state            IN VARCHAR2,
    a_country          IN VARCHAR2
  ) IS
  BEGIN
    IF a_airport_name IS NULL OR a_city IS NULL OR a_state IS NULL OR a_country IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001, 'All input parameters must be specified');
    END IF;  
    
    -- Regex validations
    
    -- Validate airport name input
    IF REGEXP_LIKE(a_airport_name, '/^[a-zA-Z ]*$/') = FALSE THEN
      RAISE_APPLICATION_ERROR(-20002, 'Only alphabets and spaces are allowed');
    END IF;
    
    -- Validate city input
    IF REGEXP_LIKE(a_city, '/^[a-zA-Z ]*$/') = FALSE THEN
      RAISE_APPLICATION_ERROR(-20003, 'Only alphabets and spaces are allowed');
    END IF;
    
    -- Validate state input
    IF REGEXP_LIKE(a_state, '/^[a-zA-Z ]*$/') = FALSE THEN
      RAISE_APPLICATION_ERROR(-20004, 'Only alphabets and spaces are allowed');
    END IF;
    
    -- Validate country input
    IF REGEXP_LIKE(a_country, '/^[a-zA-Z ]*$/') = FALSE THEN
      RAISE_APPLICATION_ERROR(-20005, 'Only alphabets and spaces are allowed');
    END IF;

    INSERT INTO PASSENGER (
      airport_id,
      airport_name,
      city,
      state,
      country
    ) VALUES (
      admin.airport_seq.nextval,
      a_airport_name,
      a_city,
      a_state,
      a_country
    );
    
  END insert_airport;

END airport_pkg;
/

SHOW ERRORS;