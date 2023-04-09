set serveroutput on;

--Testing onboarding airline
EXECUTE airline_pkg.insert_airline('6E', 'Indigo');
EXECUTE airline_pkg.insert_airline('AI', 'Air India');
EXECUTE airline_pkg.insert_airline(null, 'Air Asia');
EXECUTE airline_pkg.insert_airline('khj', 'Air Asia');
select * from airlines;

--Testing update airline
EXECUTE update_airline_pkg.update_airline_name(NULL, 'WD6');
--Testing delete airline
EXECUTE delete_airline_pkg.delete_airline(1002);