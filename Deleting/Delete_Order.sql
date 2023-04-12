CREATE OR REPLACE PACKAGE ORDER_DELETE_PKG AS

  PROCEDURE delete_baggage(in_ticket_id IN NUMBER);

  PROCEDURE delete_ticket(in_ticket_id IN NUMBER);

  PROCEDURE delete_order(
    p_order_id IN NUMBER
  );

END ORDER_DELETE_PKG;
/

CREATE OR REPLACE PACKAGE BODY ORDER_DELETE_PKG AS


 PROCEDURE delete_ticket(
    p_ticket_id IN NUMBER
  ) AS
    invalid_ticket_id EXCEPTION;
  BEGIN
    -- Validate inputs
    IF p_ticket_id IS NULL OR p_ticket_id <= 0 THEN
      RAISE invalid_ticket_id;
    END IF;
    
    -- delete ticket
    DELETE FROM ticket
      WHERE ticket_id = p_ticket_id;
    COMMIT; 
    
    IF p_ticket_id IS NOT NULL AND p_ticket_id > 0 THEN
      -- Get all the ticket_ids associated with the given ticket_id
      FOR baggage_rec IN (SELECT baggage_id FROM baggage WHERE ticket_id = p_ticket_id)
      LOOP
         -- Delete the baggage associated with the ticket_id
         delete_baggage(baggage_rec.baggage_id);
      END LOOP;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Data successfully deleted from ticket table');
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          DBMS_OUTPUT.PUT_LINE('No data found with the given ticket_id');
        WHEN invalid_ticket_id THEN 
          dbms_output.put_line('Invalid ticket id');
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('An error occurred while deleting data: ' || SQLERRM);
          ROLLBACK;
    END delete_ticket;

  PROCEDURE delete_order(
    p_order_id IN NUMBER
  ) AS
    invalid_order_id EXCEPTION;
    l_ticket_id NUMBER;
  BEGIN
    -- Validate inputs
    IF p_order_id IS NULL OR p_order_id <= 0 THEN
      RAISE invalid_order_id;
    END IF;

    -- delete order
    DELETE FROM ORDER
      WHERE order_id = p_order_id;

   IF p_order_id IS NOT NULL AND p_order_id > 0 THEN
      -- Get all the ticket_ids associated with the given order_id
      FOR ticket_rec IN (SELECT ticket_id FROM ticket WHERE order_id = p_order_id)
      LOOP
         -- Delete the ticket associated with the order_id
         delete_ticket(ticket_rec.ticket_id);
      END LOOP;
   END IF;


    COMMIT; 
    DBMS_OUTPUT.PUT_LINE('Data successfully deleted from order table');
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          DBMS_OUTPUT.PUT_LINE('No data found with the given order_id');
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('An error occurred while deleting data: ' || SQLERRM);
          ROLLBACK;
    END delete_order;


END ORDER_DELETE_PKG;