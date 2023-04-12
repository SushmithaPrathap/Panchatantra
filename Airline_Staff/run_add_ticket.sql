--TEST CASES FOR TICKET UPDATE

-- EXECUTE ONBOARD_TICKET_PKG.INSERT_TICKET(50003, 4005, 'P6', 'Gluten Free', 'BOS', 'HKG', TO_DATE('2023-05-15', 'YYYY-MM-DD'), 'Business', 'Cash', 2345, 250.00);
-- /
-- SELECT weight FROM baggage WHERE ticket_id = 7005;
-- EXECUTE ONBOARD_TICKET_PKG.INSERT_TICKET(50004, 4005, 'P6', 'Gluten Free', 'HKG', 'BOM', TO_DATE('2023-05-16', 'YYYY-MM-DD'), 'Economy', 'Cash', 2345, 150.00);
-- /
-- SELECT weight FROM baggage WHERE ticket_id = 7007;
-- --invalid order_id
-- EXECUTE ONBOARD_TICKET_PKG.INSERT_TICKET(5000, 4005, 'P6', 'Gluten Free', 'HKG', 'BOM', TO_DATE('2023-05-16', 'YYYY-MM-DD'), 'Economy', 'Cash', 2345, 150.00);
-- --invalid order_id null
-- EXECUTE ONBOARD_TICKET_PKG.INSERT_TICKET(null, 4005, 'P6', 'Gluten Free', 'HKG', 'BOM', TO_DATE('2023-05-16', 'YYYY-MM-DD'), 'Economy', 'Cash', 2345, 150.00);
-- --empty string for meal preferences
-- EXECUTE ONBOARD_TICKET_PKG.INSERT_TICKET(50004, 4005, 'P6', '', 'HKG', 'BOM', TO_DATE('2023-05-16', 'YYYY-MM-DD'), 'Economy', 'Cash', 2345, 150.00);
-- --empty string for class
-- EXECUTE ONBOARD_TICKET_PKG.INSERT_TICKET(50004, 4005, 'P6', '', 'HKG', 'BOM', TO_DATE('2023-05-16', 'YYYY-MM-DD'), '', 'Cash', 2345, 150.00);
-- --0 cash
-- EXECUTE ONBOARD_TICKET_PKG.INSERT_TICKET(50004, 4005, 'P6', '', 'HKG', 'BOM', TO_DATE('2023-05-16', 'YYYY-MM-DD'), '', 'Cash', 2345, 0.00);
-- --Previous date
-- EXECUTE ONBOARD_TICKET_PKG.INSERT_TICKET(50004, 4005, 'P6', '', 'HKG', 'BOM', TO_DATE('2023-04-11', 'YYYY-MM-DD'), '', 'Cash', 2345, 0.00);
-- --Invalid flight_id
-- EXECUTE ONBOARD_TICKET_PKG.INSERT_TICKET(50004, 400, 'P6', '', 'HKG', 'BOM', TO_DATE('2023-04-11', 'YYYY-MM-DD'), '', 'Cash', 2345, 0.00);


--TEST CASES FOR TICKET UPDATE

-- EXECUTE UPDATE_TICKET_PKG.update_ticket(7006, 50003, 4005, 'P6', 'Gluten Free', 'BOS', 'HKG', TO_DATE('2023-05-15', 'YYYY-MM-DD'), 'Economy', 'Cash', 2345, 150.00);
-- /
-- SELECT weight FROM baggage WHERE ticket_id = 7005;
-- EXECUTE UPDATE_TICKET_PKG.update_ticket(7006, 50004, 4005, 'P6', 'Gluten Free', 'HKG', 'BOM', TO_DATE('2023-05-15', 'YYYY-MM-DD'), 'Economy', 'Cash', 2345, 150);
-- /
-- SELECT weight FROM baggage WHERE ticket_id = 7006;
--invalid order_id
EXECUTE UPDATE_TICKET_PKG.update_ticket(7006, 5000, 4005, 'P6', 'Gluten Free', 'HKG', 'BOM', TO_DATE('2023-05-16', 'YYYY-MM-DD'), 'Economy', 'Cash', 2345, 150.00);
-- --invalid order_id null
-- EXECUTE UPDATE_TICKET_PKG.update_ticket(null, 4005, 'P6', 'Gluten Free', 'HKG', 'BOM', TO_DATE('2023-05-16', 'YYYY-MM-DD'), 'Economy', 'Cash', 2345, 150.00);
-- --empty string for meal preferences
-- EXECUTE UPDATE_TICKET_PKG.update_ticket(7006, 50004, 4005, 'P6', '', 'HKG', 'BOM', TO_DATE('2023-05-16', 'YYYY-MM-DD'), 'Economy', 'Cash', 2345, 150.00);
-- --empty string for class
-- EXECUTE UPDATE_TICKET_PKG.update_ticket(7006, 50004, 4005, 'P6', '', 'HKG', 'BOM', TO_DATE('2023-05-16', 'YYYY-MM-DD'), '', 'Cash', 2345, 150.00);
-- --0 cash
-- EXECUTE UPDATE_TICKET_PKG.update_ticket(7006, 50004, 4005, 'P6', '', 'HKG', 'BOM', TO_DATE('2023-05-16', 'YYYY-MM-DD'), '', 'Cash', 2345, 0.00);
-- --Previous date
-- EXECUTE UPDATE_TICKET_PKG.update_ticket(7006, 50004, 4005, 'P6', '', 'HKG', 'BOM', TO_DATE('2023-04-11', 'YYYY-MM-DD'), '', 'Cash', 2345, 0.00);
-- --Invalid flight_id
-- EXECUTE UPDATE_TICKET_PKG.update_ticket(7006, 50004, 400, 'P6', '', 'HKG', 'BOM', TO_DATE('2023-04-11', 'YYYY-MM-DD'), '', 'Cash', 2345, 0.00);


select * from ticket;