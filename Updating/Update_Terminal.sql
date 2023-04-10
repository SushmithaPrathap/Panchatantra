/*
This Package is used for updating terminal data
*/
CREATE OR REPLACE PACKAGE terminal_updating_pkg AS
  PROCEDURE update_terminal(
    in_terminal_id     IN NUMBER,
    in_terminal_name  IN VARCHAR2
  );
END terminal_updating_pkg;
/

CREATE OR REPLACE PACKAGE BODY terminal_updating_pkg AS
PROCEDURE update_terminal(
    in_terminal_id     IN NUMBER,
    in_terminal_name  IN VARCHAR2
  ) IS
  BEGIN
    IF in_terminal_id IS NULL OR in_terminal_name is NULL THEN
      dbms_output.put('All input parameters must be specified');
      Return;
    END IF;
        IF REGEXP_LIKE(in_terminal_name, '/^[a-zA-Z0-9]+$/') = FALSE THEN
        DBMS_OUTPUT.PUT_LINE('Invalid terminal name');
        RETURN;
    END IF;
    BEGIN
      UPDATE terminal
      SET
        terminal_name = in_terminal_name
      WHERE
        terminal_id = in_terminal_id;
      commit;
      DBMS_OUTPUT.PUT_LINE('Data updated successfully');
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No terminal found with the given ID');
        RETURN;
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred while updating the terminal: ' || SQLERRM); 
        rollback;     
        RETURN;
    END;

  END update_terminal;
END terminal_updating_pkg;
/

SHOW ERRORS;
