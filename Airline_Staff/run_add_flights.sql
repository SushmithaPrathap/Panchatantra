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
--Test Cases for flight

EXECUTE ONBOARD_FLIGHT_PKG.INSERT_FLIGHT('Airbus A320',  TO_TIMESTAMP('2023-04-21 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-04-22 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'BOM', 'BOS', 'On Time', 300, 1010, 0, 6001);

--flight type
--EXECUTE ONBOARD_FLIGHT_PKG.INSERT_FLIGHT('',  TO_TIMESTAMP('2023-04-21 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-04-22 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'BOM', 'BOS', 'On Time', 300, 1010, 0, 6001);
--flight type
-- EXECUTE ONBOARD_FLIGHT_PKG.INSERT_FLIGHT( TO_TIMESTAMP('2023-04-21 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-04-22 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'BOM', 'BOS', 'On Time', 300, 1010, 0, 6001);

-- EXECUTE flight_updating_pkg.update_flight(4009, 'Airbus A380', 'BOM', 'BOS', 'On Time', 300, 1010, 0, 187);


select * from flight;

select * from schedule;

