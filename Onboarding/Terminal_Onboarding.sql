/*
This Package is used for inserting Terminal data
change below
After a passenger signs up an Order gets generated in the order table
When a passenger deetes a ticket the number of passengers on a flight reduces
*/
CREATE OR REPLACE PACKAGE terminal_pkg AS  
  PROCEDURE insert_terminal(
    in_terminal_id             IN NUMBER,
    in_terminal_name         IN VARCHAR2
  );
END terminal_pkg;
/

CREATE OR REPLACE PACKAGE BODY terminal_pkg AS
PROCEDURE insert_terminal(
    in_terminal_id             IN NUMBER,
    in_terminal_name         IN VARCHAR2
  ) IS
  BEGIN
    IF in_terminal_id IS NULL OR in_terminal_name IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001, 'All input parameters must be specified');
    END IF;
 -- add validation change

    INSERT INTO TERMINAL (
      terminal_id,
      terminal_name
    ) VALUES (
      in_terminal_id,
      in_terminal_name
    ); 
  END insert_terminal;

END terminal_pkg;
/

SHOW ERRORS;
