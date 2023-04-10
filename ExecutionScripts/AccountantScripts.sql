-- TEST CASES FOR AN ACCOUNTANT
set serveroutput on;
EXECUTE airportadmin.acct_pkg.update_order_status(50006,'Completed1');
EXECUTE airportadmin.acct_pkg.update_order_status(50006,'Completed');
select airportadmin.acct_pkg.calculate_total_revenue() from dual;
execute airportadmin.acct_pkg.update_order_amount(50006,-10000);


/*
VIEW 1 
*/
BEGIN
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW  flight_revenue AS
    SELECT sum(a.transaction_amount) as Revenue, c.airline_name from airportadmin.ticket a 
    JOIN airportadmin.flight b on a.flight_id = b.flight_id 
    join airportadmin.airlines c on b.airline_id = c.airline_id group by c.airline_name order by Revenue desc
    ';
    DBMS_OUTPUT.PUT_LINE('The Flight Schedule was created successfully');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

-- TEST VIEWS FOR AN ACCOUNTANT
select * from flight_revenue;

-- TEST VIEWS FOR CANCELLED FLIGHTS
select * from airportadmin.flight_schedule where status = 'Cancelled';
