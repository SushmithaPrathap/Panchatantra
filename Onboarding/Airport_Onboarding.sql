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

  END insert_airport;

END airport_pkg;
/

SHOW ERRORS;