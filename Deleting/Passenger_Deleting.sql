/*
This Package is used for inserting and Updating passenger data
After a passenger signs up an Order gets generated in the order table
When a passenger deetes a ticket the number of passengers on a flight reduces
*/
--ALTER TABLE ticket
--  PARALLEL(DEGREE 1);

CREATE OR REPLACE TRIGGER trg_delete_order_and_baggage
AFTER DELETE ON TICKET
FOR EACH ROW
BEGIN
  -- Delete data from ORDER table
  DELETE FROM ORDERS WHERE order_id = :OLD.order_id;
  
  -- Delete data from BAGGAGE table
  DELETE FROM BAGGAGE WHERE order_id = :OLD.order_id;
  
  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('Data successfully deleted from ORDER and BAGGAGE tables.');
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No data found with the given order_id');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred while deleting data: ' || SQLERRM);
END;
/
CREATE OR REPLACE PACKAGE passenger_pkg AS
  PROCEDURE delete_ticket(p_order_id IN VARCHAR2);
END passenger_pkg;
/

CREATE OR REPLACE PACKAGE BODY passenger_pkg AS

    PROCEDURE delete_ticket(p_order_id IN VARCHAR2) AS
    BEGIN
      UPDATE FLIGHT f
      SET f.SEATS_FILLED = f.SEATS_FILLED - 1
      WHERE f.flight_id = (
        SELECT t.flight_id FROM TICKET t WHERE t.order_id = p_order_id
      );
      COMMIT;
    
      DELETE FROM TICKET
      WHERE order_id = p_order_id;
      COMMIT;
    
      DBMS_OUTPUT.PUT_LINE('Your Ticket was cancelled successfully');  
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Ticket with order_id ' || p_order_id || ' not found.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error deleting ticket with order_id ' || p_order_id || ': ' || SQLERRM);
            
    END delete_ticket;
END passenger_pkg;
/

SHOW ERRORS;
