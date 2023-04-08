/*
This Package is used for deleting airport data
*/

CREATE OR REPLACE PACKAGE passenger_deleting_pkg AS
  PROCEDURE delete_airport(
    a_airport_id       IN NUMBER DEFAULT NULL,
    a_airport_name     IN VARCHAR2,
    a_city             IN VARCHAR2,
    a_state            IN VARCHAR2,
    a_country          IN VARCHAR2
  );
END passenger_deleting_pkg;
/