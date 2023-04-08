/*
This Package is used for inserting Terminal data
change below
Once airport is added, different terminals are added to the airport
*/
CREATE OR REPLACE PACKAGE terminal_pkg AS  
  PROCEDURE insert_terminal(
    in_terminal_id           IN NUMBER,
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
    --validate terminal name is null
    IF in_terminal_name IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('All input parameters must be specified');
    END IF;
    --validate terminal name is not a special character
    IF REGEXP_LIKE(in_terminal_name, '/^[a-zA-Z0-9]+$/') = FALSE THEN
        DBMS_OUTPUT.PUT_LINE('Invalid terminal name');
    END IF;
    INSERT INTO TERMINAL (
      terminal_id,
      terminal_name
    ) VALUES (
      ADMIN.terminal_seq.NEXTVAL,
      in_terminal_name
    );
    commit;
  END insert_terminal;

END terminal_pkg;
/

SHOW ERRORS;
