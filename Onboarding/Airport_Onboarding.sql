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