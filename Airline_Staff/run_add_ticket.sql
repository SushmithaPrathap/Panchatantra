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

CREATE OR REPLACE TRIGGER UPDATE_TICKET_TRG
BEFORE UPDATE ON TICKET
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

EXECUTE ONBOARD_TICKET_PKG.INSERT_TICKET(50004, 4005, 'E6', 'Gluten Free', 'BOS', 'HKG', TO_DATE('2023-05-15', 'YYYY-MM-DD'), 'Business', 'Cash', 2345, 250.00);
/
SELECT weight FROM baggage WHERE ticket_id = 7005;
EXECUTE ONBOARD_TICKET_PKG.INSERT_TICKET(50004, 4005, 'P6', 'Gluten Free', 'HKG', 'BOM', TO_DATE('2023-05-16', 'YYYY-MM-DD'), 'Economy', 'Cash', 2345, 150.00);
/
SELECT weight FROM baggage WHERE ticket_id = 7007;
--invalid order_id
EXECUTE ONBOARD_TICKET_PKG.INSERT_TICKET(5000, 4005, 'P6', 'Gluten Free', 'HKG', 'BOM', TO_DATE('2023-05-16', 'YYYY-MM-DD'), 'Economy', 'Cash', 2345, 150.00);
--invalid order_id null
EXECUTE ONBOARD_TICKET_PKG.INSERT_TICKET(null, 4005, 'P6', 'Gluten Free', 'HKG', 'BOM', TO_DATE('2023-05-16', 'YYYY-MM-DD'), 'Economy', 'Cash', 2345, 150.00);
--empty string for meal preferences
EXECUTE ONBOARD_TICKET_PKG.INSERT_TICKET(50004, 4005, 'P6', '', 'HKG', 'BOM', TO_DATE('2023-05-16', 'YYYY-MM-DD'), 'Economy', 'Cash', 2345, 150.00);
--empty string for class
EXECUTE ONBOARD_TICKET_PKG.INSERT_TICKET(50004, 4005, 'P6', '', 'HKG', 'BOM', TO_DATE('2023-05-16', 'YYYY-MM-DD'), '', 'Cash', 2345, 150.00);
--0 cash
EXECUTE ONBOARD_TICKET_PKG.INSERT_TICKET(50004, 4005, 'P6', '', 'HKG', 'BOM', TO_DATE('2023-05-16', 'YYYY-MM-DD'), '', 'Cash', 2345, 0.00);
--Previous date
EXECUTE ONBOARD_TICKET_PKG.INSERT_TICKET(50004, 4005, 'P6', '', 'HKG', 'BOM', TO_DATE('2023-04-11', 'YYYY-MM-DD'), '', 'Cash', 2345, 0.00);
--Invalid flight_id
EXECUTE ONBOARD_TICKET_PKG.INSERT_TICKET(50004, 400, 'P6', '', 'HKG', 'BOM', TO_DATE('2023-04-11', 'YYYY-MM-DD'), '', 'Cash', 2345, 0.00);

-- EXECUTE ticket_updating_pkg.update_ticket(7005, 50004, 4005, 'E7', 'Gluten Free', 'BOS', 'HKG', TO_DATE('2023-05-18', 'YYYY-MM-DD'), 'Economy', 'Cash', 2345, 250.00);
