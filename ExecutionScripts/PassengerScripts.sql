set serveroutput on
--- TEST CASES FOR PASSENGER INSERTS;
EXECUTE airportadmin.passenger_onboarding_pkg.insert_passenger(25,'15 Cawfield','Female',9566186692,'Annvi','Jain',TO_DATE('2022-04-05', 'YYYY-MM-DD'),9566186692,'Annvi@yahoo.com');
EXECUTE airportadmin.passenger_onboarding_pkg.insert_passenger(25,'15 Cawfield','Female',956,'Annvi','Jain',TO_DATE('2022-04-05', 'YYYY-MM-DD'),9566186692,'Annvi@yahoo.com');
EXECUTE airportadmin.passenger_onboarding_pkg.insert_passenger(25,'15 Cawfield','Female',956,'Annvi','Jain',TO_DATE('2022-04-05', 'YYYY-MM-DD'),9566186692,'Annvi@yahoo.com');
EXECUTE airportadmin.passenger_onboarding_pkg.insert_passenger(25,'15 Cawfield','Female',9566186692,'Annvi','Jain',TO_DATE('2022-04-05', 'YYYY-MM-DD'),9566186692,'Annviyahoo.com');
EXECUTE airportadmin.passenger_onboarding_pkg.insert_passenger(25,'15 Cawfield','M',9566186692,'Annvi','Jain',TO_DATE('2022-04-05', 'YYYY-MM-DD'),9566186692,'Annviyahoo.com');

--- TEST CASES FOR PASSENGER WANTING TO BOOK A TICKET
EXECUTE airportadmin.passenger_onboarding_pkg.insert_passenger(25,'15 Cawfield','Female',9566186692,'Annvi','Jain',TO_DATE('2022-04-05', 'YYYY-MM-DD'),9566186692,'Annvi@yahoo.com');
EXECUTE airportadmin.passenger_onboarding_pkg.insert_passenger(25,'15 Cawfield','Male',9566186692,'Abhi','Jain',TO_DATE('2022-04-05', 'YYYY-MM-DD'),9566186692,'Abhi@yahoo.com');
EXECUTE airportadmin.passenger_onboarding_pkg.insert_passenger(25,'15 Cawfield','Male',9566186692,'Manikanta','Jain',TO_DATE('2022-04-05', 'YYYY-MM-DD'),9566186692,'Manikanta@yahoo.com');

-- TEST CASES FOR PASSENGER WANTING TO UPDATE HIS DETAILS
EXECUTE airportadmin.passenger_updating_pkg.update_passenger(1001,26,'15 Cawfield','Female',9566186692,'Abhishek','Jain',TO_DATE('2022-04-05', 'YYYY-MM-DD'),9566186692,'Ani@yahoo.com');
EXECUTE airportadmin.passenger_updating_pkg.update_passenger(1001,26,'15 Cawfield','Female',9566186692,'Abhishek','Jain',TO_DATE('2022-04-05', 'YYYY-MM-DD'),9566186692,'Ani@yahoo.com');
EXECUTE airportadmin.passenger_updating_pkg.update_passenger(1000,26,'15 Cawfield','Female',9566186692,'Abhishek','Jain',TO_DATE('2022-04-05', 'YYYY-MM-DD'),9566186692,'Ani@yahoo.com');

-- TEST CASES FOR PASSENGER TO DELETE HIS DETAILS
EXECUTE airportadmin.passenger_delete_pkg.delete_ticket(500003);
EXECUTE airportadmin.passenger_delete_pkg.delete_ticket('5000');
EXECUTE airportadmin.passenger_delete_pkg.delete_ticket('Abishek');
EXECUTE airportadmin.passenger_delete_pkg.delete_ticket(50004);
