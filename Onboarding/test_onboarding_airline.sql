set serveroutput on;

--Testing onboarding airline
EXECUTE airline_pkg.insert_airline('6E', 'Indigo');
EXECUTE airline_pkg.insert_airline(null, 'Air Asia');
EXECUTE airline_pkg.insert_airline('khj', 'Air Asia');
select * from airlines;

--Testing update airline

--Testing delete airline
EXECUTE delete_airline_pkg.delete_airline(1002);