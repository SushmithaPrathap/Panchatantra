BEGIN
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW  flight_schedule AS
    select  b.AIRLINE_NAME, a.DESTINATION, a.SOURCE, a.STATUS,c.TERMINAL_ID,
    c.ARRIVAL_TIME,c.DEPARTURE_TIME from FLIGHT a JOIN AIRLINES b on a.AIRLINE_ID = b.AIRLINE_ID
    JOIN SCHEDULE c on a.FLIGHT_ID = c.FLIGHT_ID';
    DBMS_OUTPUT.PUT_LINE('The Flight Schedule was created successfully');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
GRANT SELECT ON flight_schedule TO PASSENGERUSER;