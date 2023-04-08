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


BEGIN
  ONBOARD_FLIGHT_PKG.INSERT_FLIGHT(
    p_flight_id => ADMIN.flight_seq.NEXTVAL,
    --p_duration => 187,
    p_flight_type => 'Airbus A380',
    p_departure_time => TO_TIMESTAMP('2023-04-20 12:00:00', 'YYYY-MM-DD HH24:MI:SS'),
    p_arrival_time => TO_TIMESTAMP('2023-04-22 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
    p_destination => 'BOM',
    p_source => 'BOS',
    p_status => 'On Time',
    p_no_pax => 300,
    p_airline_id => 1010,
    p_seats_filled => 0,
    p_terminal_id => 1
  );
END;


-- select * from passenger;
-- select * from orders;
--update orders set status = 'Success' where order_id = 10;

-- BEGIN
--   PASSENGER_TICKET_PACKAGE.INSERT_PASSENGER(
--     p_passenger_id => 10,
--     p_age => 22,
--     p_address => '789 Pine St, Anytown, USA',
--     p_sex => 'Female',
--     p_govt_id_nos => 'VWX234',
--     p_first_name => 'Rose',
--     p_last_name => 'Pink',
--     p_dob =>  TO_DATE('2000-03-25', 'YYYY-MM-DD'),
--     p_contact_number => 8901234567,
--     p_email => 'avabrown@example.com'
--   );
-- END; 
