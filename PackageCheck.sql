set serveroutput on;
SELECT * FROM TABLE(pkg_AdminDuties.get_departing_flights(101, TO_TIMESTAMP('22-MAR-23 12.00.00.000000000 PM')));


commit;
SELECT * FROM flight where flight_id = 101 and departure_time = '21-MAR-23 08.00.00.000000000 AM';


SELECT * FROM flight;
/*
To Insert  A passenger please fill the following details
p_age              
p_address          
p_sex              
p_govt_id_nos      
p_first_name       
p_last_name        
p_dob              
p_contact_number   
p_email    
*/    
EXECUTE passenger_pkg.insert_passenger(25,'15 Cawfield','Female',9566186692,'Annvi','Jain',TO_DATE('2022-04-05', 'YYYY-MM-DD'),9566186692,'Annvi@yahoo.com');
EXECUTE passenger_pkg.update_passenger(123,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);

select  admin.passenger_seq.currval from dual;
select  admin.passenger_seq.nextval from dual;
select * from passenger;
select * from orders;
select * from ticket;