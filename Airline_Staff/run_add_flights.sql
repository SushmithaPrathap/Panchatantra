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


CREATE OR REPLACE TRIGGER UPDATE_SCHEDULE_TRG
BEFORE UPDATE ON SCHEDULE
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


