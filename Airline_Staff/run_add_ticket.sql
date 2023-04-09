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

-- BEGIN
--   ONBOARD_TICKET_PKG.INSERT_TICKET(
--     in_ticket_id => ADMIN.ticket_seq.NEXTVAL,
--     in_order_id => 50004,
--     in_flight_id => 4005,
--     in_seat_no => 'E6',
--     in_meal_preferences => 'Gluten Free',
--     in_source => 'BOS', 
--     in_destination =>'HKG', 
--     in_date_of_travel => TO_DATE('2023-05-15', 'YYYY-MM-DD'),
--     in_class => 'Business', 
--     in_payment_type => 'Cash', 
--     in_member_id => 2345, 
--     in_transaction_amount => 250.00
--   );
-- END;

BEGIN
  ticket_updating_pkg.update_ticket(
    p_ticket_id => 7005,
    p_order_id => 50004,
    p_flight_id => 4005,
    p_seat_no => 'E7',
    p_meal_preferences => 'Gluten Free',
    p_source => 'BOS', 
    p_destination =>'HKG', 
    p_date_of_travel => TO_DATE('2023-05-18', 'YYYY-MM-DD'),
    p_class => 'Economy', 
    p_payment_type => 'Cash', 
    p_member_id => 2345, 
    p_transaction_amount => 700.00
  );
END;