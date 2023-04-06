CREATE OR REPLACE TRIGGER INSERT_FLIGHT_TRG
BEFORE INSERT ON FLIGHT
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
  FLIGHT_PKG.INSERT_FLIGHT(
    p_flight_id => 115,
    p_duration => 187,
    p_flight_type => 'Airbus A380',
    p_departure_time => TO_TIMESTAMP('2023-04-08 12:00:00', 'YYYY-MM-DD HH24:MI:SS')
    p_arrival_time => TO_TIMESTAMP('2023-04-07 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
    p_destination => 'BOS',
    p_source => 'LHR',
    p_status => 'On Time',
    p_no_pax => 300,
    p_airline_id => 1010,
    p_seats_filled => 0
  );
END;