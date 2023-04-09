/*
View 1 for Passenger Schedule
*/

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
GRANT SELECT ON  AIRPORTADMIN.flight_schedule TO PASSENGERUSER;

/*
View 1 for Accountants
*/
BEGIN
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW  flight_revenue AS
    SELECT sum(a.transaction_amount) as Revenue, c.airline_name from ticket a 
    JOIN flight b on a.flight_id = b.flight_id 
    join airlines c on b.airline_id = c.airline_id group by c.airline_name order by Revenue desc
    ';
    DBMS_OUTPUT.PUT_LINE('The Flight Schedule was created successfully');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

GRANT SELECT ON  AIRPORTADMIN.flight_revenue TO ACCOUNTANT;
/*
View 2 for Accountants
*/

BEGIN
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW  cancelled_flights AS
    SELECT sum(a.transaction_amount) as Revenue, c.airline_name from ticket a 
    JOIN flight b on a.flight_id = b.flight_id 
    join airlines c on b.airline_id = c.airline_id group by c.airline_name order by Revenue desc
    ';
    DBMS_OUTPUT.PUT_LINE('The Flight Schedule was created successfully');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
GRANT SELECT ON  AIRPORTADMIN.cancelled_flights TO ACCOUNTANT;