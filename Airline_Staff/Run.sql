CREATE OR REPLACE TRIGGER INSERT_SCHEDULE_TRG
BEFORE INSERT ON SCHEDULE
FOR EACH ROW
DECLARE
  l_now TIMESTAMP := SYSTIMESTAMP;
BEGIN
    -- Check if arrival and departure date are in the future
    IF :NEW.departure_time <= l_now THEN
        RAISE_APPLICATION_ERROR(-20003, 'Departure date should be in the future');
    END IF;

    IF :NEW.arrival_time <= l_now THEN
        RAISE_APPLICATION_ERROR(-20004, 'Arrival date should be in the future');
    END IF;
END;
/

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


-- BEGIN
--   ONBOARD_FLIGHT_PKG.INSERT_FLIGHT(
--     p_flight_id => ADMIN.flight_seq.NEXTVAL,
--     --p_duration => 187,
--     p_flight_type => 'Airbus A380',
--     p_departure_time => TO_TIMESTAMP('2023-04-20 12:00:00', 'YYYY-MM-DD HH24:MI:SS'),
--     p_arrival_time => TO_TIMESTAMP('2023-04-22 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
--     p_destination => 'BOM',
--     p_source => 'BOS',
--     p_status => 'On Time',
--     p_no_pax => 300,
--     p_airline_id => 1010,
--     p_seats_filled => 0,
--     p_terminal_id => 6001
--   );
-- END;

BEGIN
  ONBOARD_TICKET_PKG.INSERT_TICKET(
    in_ticket_id => ADMIN.ticket_seq.NEXTVAL,
    in_order_id => 50004,
    in_flight_id => 4005,
    in_seat_no => 'E6',
    in_meal_preferences => 'Gluten Free',
    in_source => 'BOS', 
    in_destination =>'HKG', 
    in_date_of_travel => TO_DATE('2023-05-15', 'YYYY-MM-DD'),
    in_class => 'Economy', 
    in_payment_type => 'Cash', 
    in_member_id => 2345, 
    in_transaction_amount => 250.00
  );
END;

