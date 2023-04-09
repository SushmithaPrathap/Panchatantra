-- TEST CASES FOR AN ACCOUNTANT
set serveroutput on;
EXECUTE airportadmin.acct_pkg.update_order_status(50006,'Completed1');
EXECUTE airportadmin.acct_pkg.update_order_status(50006,'Completed');
select airportadmin.acct_pkg.calculate_total_revenue() from dual;
execute airportadmin.acct_pkg.update_order_amount(50006,-10000);

-- TEST VIEWS FOR AN ACCOUNTANT
select * from airportadmin.flight_revenue;
select * from airportadmin.cancelled_flights;