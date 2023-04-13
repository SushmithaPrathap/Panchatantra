CREATE OR REPLACE TRIGGER INSERT_TICKET_TRG
BEFORE INSERT ON TICKET
FOR EACH ROW
DECLARE
  l_now TIMESTAMP := SYSTIMESTAMP;
BEGIN
    -- Check if date_of_travel are in the future
    IF :NEW.date_of_travel <= l_now THEN
        RAISE_APPLICATION_ERROR(-20003, 'Date_of_travel should be in the future');
    END IF;
END;
/

/*
Stored Procedure for updating baggage weight based on the class
*/
 CREATE OR REPLACE PROCEDURE insert_baggage (
    p_baggage_id IN NUMBER,
    p_ticket_id IN NUMBER
)
IS
    v_weight FLOAT;
    v_ticket_class VARCHAR2(20);
    BEGIN

    SELECT class INTO v_ticket_class FROM ticket WHERE ticket_id = p_ticket_id;
    
 IF v_ticket_class = 'Business' THEN
    v_weight := 200.00;
END IF;
IF v_ticket_class = 'Business Pro' THEN
    v_weight := 300.00;
END IF;
IF v_ticket_class = 'First Class' THEN
    v_weight := 400.00;
END IF;
IF v_ticket_class = 'Economy' THEN
    v_weight := 100.00;
END IF;
    
    INSERT INTO baggage (
        baggage_id,
        ticket_id,
        weight
    ) VALUES (
        p_baggage_id,
        p_ticket_id,
        v_weight
    );
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Baggage ' || p_baggage_id || ' weight updated to ' || v_weight);
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No ticket found with ID ' || p_ticket_id);
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error inserting baggage record: ' || SQLERRM);
    ROLLBACK;
    END insert_baggage;
/

CREATE OR REPLACE PACKAGE ONBOARD_TICKET_PKG AS

  FUNCTION check_airport(in_airport_name IN VARCHAR2) RETURN NUMBER;

  FUNCTION check_flight(in_flight_id IN NUMBER) RETURN NUMBER;

  PROCEDURE INSERT_TICKET(
    in_order_id IN NUMBER,
    in_flight_id IN NUMBER,
    in_seat_no IN VARCHAR2,
    in_meal_preferences IN VARCHAR2,
    in_source IN VARCHAR2,
    in_destination IN VARCHAR2,
    in_date_of_travel IN DATE,
    in_class IN VARCHAR2,
    in_payment_type IN VARCHAR2,
    in_member_id IN NUMBER
);

END ONBOARD_TICKET_PKG;
/

CREATE OR REPLACE PACKAGE BODY ONBOARD_TICKET_PKG AS


  FUNCTION check_airport(in_airport_name IN VARCHAR2) RETURN NUMBER IS
    v_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_result
    FROM airport
    WHERE airport_name = in_airport_name;

    RETURN v_result;
  END check_airport;

  FUNCTION check_flight(in_flight_id IN NUMBER) RETURN NUMBER IS
    v_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_result
    FROM flight
    WHERE flight_id = in_flight_id;

    RETURN v_result;
  END check_flight;
  
  PROCEDURE INSERT_TICKET(
    in_order_id IN NUMBER,
    in_flight_id IN NUMBER,
    in_seat_no IN VARCHAR2,
    in_meal_preferences IN VARCHAR2,
    in_source IN VARCHAR2,
    in_destination IN VARCHAR2,
    in_date_of_travel IN DATE,
    in_class IN VARCHAR2,
    in_payment_type IN VARCHAR2,
    in_member_id IN NUMBER
  ) AS
    l_d_airport_count NUMBER;
    l_s_airport_count NUMBER;
    l_flight_count NUMBER;
    l_ticket_id NUMBER := ADMIN.ticket_seq.NEXTVAL; --seq
    INVALID_INPUTS EXCEPTION;
    
  BEGIN
    IF
    (
        in_order_id <= 0
        OR in_flight_id <= 0
        OR LENGTH(in_seat_no)<= 0
        OR LENGTH(in_meal_preferences)<= 0
        OR LENGTH(in_source) <= 0
        OR LENGTH(in_destination)<=0
        OR in_date_of_travel is NULL
        OR LENGTH(in_class)<=0
        OR LENGTH(in_payment_type)<=0
        OR in_member_id <= 0
    ) THEN 
        RAISE INVALID_INPUTS;
    END IF;

    l_flight_count := ONBOARD_TICKET_PKG.check_flight(in_flight_id);
    DBMS_OUTPUT.PUT_LINE('Output value for flight: ' || l_flight_count);

    IF l_flight_count = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Flight_id does not exist in flight table');
      RETURN;
    END IF;

      l_d_airport_count := ONBOARD_FLIGHT_PKG.check_airport(in_destination);
    DBMS_OUTPUT.PUT_LINE('Output value for destination: ' || l_d_airport_count);

    IF l_d_airport_count = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Destination airport does not exist in airport table');
      RETURN;
    END IF;

    l_s_airport_count := ONBOARD_FLIGHT_PKG.check_airport(in_source);
    DBMS_OUTPUT.PUT_LINE('Output value for source: ' || l_s_airport_count);

    IF l_s_airport_count = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Source airport does not exist in airport table');
      RETURN;
    END IF;
    
    -- Insert ticket record
    INSERT INTO ticket (
     ticket_id, order_id, flight_id, seat_no, meal_preferences, source, destination, date_of_travel, class, payment_type, member_id
    ) VALUES (
    l_ticket_id,
    in_order_id,
    in_flight_id,
    in_seat_no,
    in_meal_preferences,
    in_source,
    in_destination,
    in_date_of_travel,
    in_class,
    in_payment_type,
    in_member_id
    );

    --insert a schedule for the flight
    insert_baggage(ADMIN.baggage_id_seq.NEXTVAL, l_ticket_id);
    
  EXCEPTION
    WHEN INVALID_INPUTS THEN 
      dbms_output.put_line('Invalid input');

  END INSERT_TICKET;
END ONBOARD_TICKET_PKG;
/

