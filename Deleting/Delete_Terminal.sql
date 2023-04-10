/*
This Package is used for deleting terminal data
*/


CREATE OR REPLACE PACKAGE terminal_delete_pkg AS
  FUNCTION fn_delete_order_and_baggage(order_id_in NUMBER, ticket_id_in NUMBER) RETURN BOOLEAN;
  PROCEDURE delete_ticket(p_order_id IN VARCHAR2);  
END terminal_delete_pkg;
/


CREATE OR REPLACE PACKAGE BODY terminal_delete_pkg AS
    FUNCTION fn_delete_order_and_baggage(order_id_in NUMBER, ticket_id_in NUMBER) RETURN BOOLEAN IS
      BEGIN
        -- Delete data from ORDER table
        DELETE FROM ORDERS WHERE order_id = order_id_in;
    
        -- Delete data from BAGGAGE table
        DELETE FROM BAGGAGE WHERE ticket_id = ticket_id_in;
    
        COMMIT;
    
        DBMS_OUTPUT.PUT_LINE('Data successfully deleted from ORDER and BAGGAGE tables.');
    
        RETURN TRUE;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          DBMS_OUTPUT.PUT_LINE('No data found with the given order_id');
          RETURN FALSE;
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('An error occurred while deleting data: ' || SQLERRM);
          RETURN FALSE;
      END fn_delete_order_and_baggage;
    PROCEDURE delete_ticket(p_order_id IN VARCHAR2) IS
    l_result BOOLEAN;
    l_ticket_id Number;
    BEGIN
      UPDATE FLIGHT f
      SET f.SEATS_FILLED = f.SEATS_FILLED - 1
      WHERE f.flight_id = (
        SELECT t.flight_id FROM TICKET t WHERE t.order_id = p_order_id
      );
      COMMIT;

      Select ticket_id INTO l_ticket_id from TICKET where order_id = p_order_id;
    
      DELETE FROM TICKET
      WHERE order_id = p_order_id;
      
      l_result := fn_delete_order_and_baggage(p_order_id, l_ticket_id);
      COMMIT;
        
      DBMS_OUTPUT.PUT_LINE('Your Ticket was cancelled successfully');  
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Ticket with order_id ' || p_order_id || ' not found.'|| ': ' || SQLERRM);
            ROLLBACK;
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Error deleting ticket with order_id ' || p_order_id || ': ' || SQLERRM);
            
    END delete_ticket;
END terminal_delete_pkg;
/

SHOW ERRORS;
