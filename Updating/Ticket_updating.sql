CREATE OR REPLACE PACKAGE ticket_updating_pkg AS

  FUNCTION check_class(in_class IN VARCHAR2, in_ticket_id NUMBER) RETURN VARCHAR2;

  PROCEDURE update_baggage(
    p_baggage_id IN VARCHAR2,
    p_ticket_id IN NUMBER,
    p_weight IN FLOAT
  );

  PROCEDURE update_ticket(
    p_ticket_id IN NUMBER,
    p_order_id IN NUMBER,
    p_flight_id IN NUMBER,
    p_seat_no IN VARCHAR2,
    p_meal_preferences IN VARCHAR2,
    p_source IN VARCHAR2,
    p_destination IN VARCHAR2,
    p_date_of_travel IN DATE,
    p_class IN VARCHAR2,
    p_payment_type IN VARCHAR2,
    p_member_id IN NUMBER,
    p_transaction_amount IN FLOAT
  );
END ticket_updating_pkg;
/

CREATE OR REPLACE PACKAGE BODY ticket_updating_pkg AS

FUNCTION check_class(in_class IN VARCHAR2, in_ticket_id IN NUMBER) RETURN VARCHAR2 IS
  v_result VARCHAR2(20);
BEGIN
  SELECT class INTO v_result
  FROM ticket
  WHERE ticket_id = in_ticket_id;
  
  RETURN v_result;
END check_class;

PROCEDURE update_baggage(
    p_baggage_id IN VARCHAR2,
    p_ticket_id IN NUMBER,
    p_weight IN FLOAT
  )AS 
    weight_array VARCHAR2(200) := '100.00, 200.00, 300.00, 400.00';
    invalid_ticket_id EXCEPTION;
    invalid_baggage_id EXCEPTION;
    invalid_weight EXCEPTION;

    BEGIN
     DBMS_OUTPUT.PUT_LINE('update baggage: ' || p_baggage_id || p_ticket_id || p_weight);
    IF p_baggage_id IS NULL OR p_baggage_id <= 0 THEN
      RAISE invalid_baggage_id;
    END IF;
    
    IF p_ticket_id IS NULL OR p_ticket_id <= 0 THEN
      RAISE invalid_ticket_id;
    END IF;

    IF p_weight <= 0 or p_weight IS NULL THEN
      RAISE invalid_weight;
    END IF;

    IF INSTR(weight_array, p_weight) = 0 THEN
    RAISE_APPLICATION_ERROR(-20004, 'Weight must be one of the following: ' || weight_array);
    END IF;


     -- Update baggage
    UPDATE baggage SET
    weight =  p_weight,
    ticket_id = p_ticket_id 
    WHERE baggage_id = p_baggage_id;

    COMMIT;

    EXCEPTION
    WHEN invalid_ticket_id THEN 
      dbms_output.put_line('Invalid Ticket id');
    WHEN invalid_baggage_id THEN 
      dbms_output.put_line('Invalid baggage id');
    WHEN invalid_weight THEN 
      dbms_output.put_line('Invalid weight');
     ROLLBACK;
   END update_baggage;


  PROCEDURE update_ticket(
    p_ticket_id IN NUMBER,
    p_order_id IN NUMBER,
    p_flight_id IN NUMBER,
    p_seat_no IN VARCHAR2,
    p_meal_preferences IN VARCHAR2,
    p_source IN VARCHAR2,
    p_destination IN VARCHAR2,
    p_date_of_travel IN DATE,
    p_class IN VARCHAR2,
    p_payment_type IN VARCHAR2,
    p_member_id IN NUMBER,
    p_transaction_amount IN FLOAT
  ) AS
    l_d_airport_count NUMBER;
    l_s_airport_count NUMBER;
    l_class NUMBER;
    l_bag NUMBER;
    v_weight NUMBER;
    -- Define custom exceptions for invalid inputs
    invalid_ticket_id EXCEPTION;
    invalid_order_id EXCEPTION;
    invalid_flight_id EXCEPTION;
    invalid_seat_no EXCEPTION;
    invalid_meal_preferences EXCEPTION;
    invalid_source EXCEPTION;
    invalid_destination EXCEPTION;
    invalid_date_of_travel EXCEPTION;
    invalid_class EXCEPTION;
    invalid_payment_type EXCEPTION;
    invalid_member_id EXCEPTION;
    invalid_transaction_amount EXCEPTION;
    
  BEGIN
    -- Validate inputs
    IF p_flight_id IS NULL OR p_flight_id <= 0 THEN
      RAISE invalid_flight_id;
    END IF;
    
    IF p_ticket_id IS NULL OR p_ticket_id <= 0 THEN
      RAISE invalid_ticket_id;
    END IF;

    IF p_order_id IS NULL OR p_order_id <= 0 THEN
      RAISE invalid_order_id;
    END IF;
    
    IF LENGTH(p_seat_no) <= 0 or p_seat_no IS NULL THEN
      RAISE invalid_seat_no;
    END IF;
    
    IF LENGTH(p_meal_preferences) <= 0 or p_meal_preferences IS NULL THEN
      RAISE invalid_meal_preferences;
    END IF;
    
    IF LENGTH(p_source) <= 0 or p_source IS NULL THEN
      RAISE invalid_source;
    END IF;

    IF LENGTH(p_destination) <= 0 or p_destination IS NULL THEN
      RAISE invalid_destination;
    END IF;

    IF LENGTH(p_class) <= 0 or p_class IS NULL THEN
      RAISE invalid_class;
    END IF;

    IF LENGTH(p_member_id) <= 0 or p_member_id IS NULL THEN
      RAISE invalid_member_id;
    END IF;
    
    IF p_transaction_amount <= 0 or p_transaction_amount IS NULL THEN
      RAISE invalid_transaction_amount;
    END IF;

    l_d_airport_count := ONBOARD_FLIGHT_PKG.check_airport(p_destination);
    DBMS_OUTPUT.PUT_LINE('Output value for destination: ' || l_d_airport_count);

    IF l_d_airport_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20001, 'Destination airport does not exist in airport table');
    END IF;

    l_s_airport_count := ONBOARD_FLIGHT_PKG.check_airport(p_source);
    DBMS_OUTPUT.PUT_LINE('Output value for source: ' || l_s_airport_count);

    IF l_s_airport_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20002, 'Source airport does not exist in airport table');
    END IF;

    l_class := ticket_updating_pkg.check_class(p_class, p_ticket_id);
    DBMS_OUTPUT.PUT_LINE('Output value for class: ' || l_class);

    IF l_class = p_class THEN
      DBMS_OUTPUT.PUT_LINE('No change in class ' || l_class);
    ELSE
    IF  p_class = 'Business' THEN
        v_weight := 200.00;
    ELSE
        v_weight := 100.00;
    END IF;
    select baggage_id into l_bag from baggage where ticket_id = p_ticket_id;
    BEGIN
    ticket_updating_pkg.update_baggage(l_bag, p_ticket_id, v_weight);
    END;
    END IF;
    
    -- Update ticket
    UPDATE ticket SET
    ticket_id = p_ticket_id ,
    order_id = p_order_id,
    flight_id = p_flight_id,
    seat_no = p_seat_no,
    meal_preferences = p_meal_preferences,
    source = p_source,
    destination = p_destination,
    date_of_travel = p_date_of_travel,
    class = p_class,
    payment_type = p_payment_type,
    member_id = p_member_id,
    transaction_amount = p_transaction_amount
    WHERE ticket_id = p_ticket_id;

    COMMIT;

  EXCEPTION
    WHEN invalid_ticket_id THEN 
      dbms_output.put_line('Invalid Ticket id');
    WHEN invalid_order_id THEN 
      dbms_output.put_line('Invalid order id');
    WHEN invalid_flight_id THEN 
      dbms_output.put_line('Invalid flight id');
    WHEN invalid_seat_no THEN 
      dbms_output.put_line('Invalid seat no');
    WHEN invalid_meal_preferences THEN 
      dbms_output.put_line('Invalid meal_preferences');
    WHEN invalid_source THEN 
      dbms_output.put_line('Invalid source');
    WHEN invalid_destination THEN 
      dbms_output.put_line('Invalid destination');
    WHEN invalid_date_of_travel THEN 
      dbms_output.put_line('Invalid date_of_travel');
    WHEN invalid_class THEN 
      dbms_output.put_line('Invalid class');
    WHEN invalid_payment_type THEN 
      dbms_output.put_line('Invalid payment_type');
    WHEN invalid_transaction_amount THEN 
      dbms_output.put_line('Invalid transaction_amount');
    WHEN invalid_member_id THEN 
      dbms_output.put_line('Invalid member id');
    ROLLBACK;
    END update_ticket;
  
END ticket_updating_pkg;