set serveroutput on;
EXECUTE airline_pkg.insert_airline(3, '1234', 'ABC', 'Airline 3');
EXECUTE airline_pkg.update_airline(3, 'New Airline Name');
commit;
EXECUTE airline_pkg.delete_airline(1);
select * from airlines;
--DECLARE
--  airline_cur SYS_REFCURSOR;
--BEGIN
--  airline_pkg.insert_airline(1, '1234', 'ABC', 'Airline 1');
--  airline_pkg.update_airline(1, 'New Airline Name');
--  airline_pkg.delete_airline(1);
--  airline_cur := airline_pkg.get_airlines;
--  -- Now do something with the returned cursor
--END;