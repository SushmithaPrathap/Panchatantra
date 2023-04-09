set serveroutput on;
EXECUTE airport_pkg.insert_airport('LOG', 'Boston', 'MA', 'USA');
EXECUTE airport_pkg.insert_airport('LAX', 'Los Angeles', 'California', 'United States');
-- EXECUTE airport_pkg.update_airport('1', 'Texas Airport', 'Texas', 'TX', 'USA');
-- EXECUTE airport_pkg.delete_airport(1);
COMMIT;
select * from airport;