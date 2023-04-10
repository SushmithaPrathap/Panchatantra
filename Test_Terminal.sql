set serveroutput on;

--- TEST CASES FOR AIRPORT INSERTS;
EXECUTE TERMINAL_PKG.INSERT_TERMINAL('LOG', NULL, 'MA', 'USA');
EXECUTE TERMINAL_PKG.INSERT_TERMINAL('LOG 123', 'Boston', 'MA', 'USA');
EXECUTE TERMINAL_PKG.INSERT_TERMINAL('LOG', 'Boston', 'MA', 'USA');
EXECUTE TERMINAL_PKG.INSERT_TERMINAL('LAX', 'Los Angeles', 'California', 'United States');
select * from airport;

--- TEST CASES FOR AIRPORT UPDATES;
EXECUTE airport_updating_pkg.update_airport(NULL, 'CDN', 'Texas', 'TX', 'USA');
EXECUTE airport_updating_pkg.update_airport(31, 'CDN', 'Texas', 'TX', 'USA');
EXECUTE airport_updating_pkg.update_airport(1, 'CDN', 'Texas 123', 'TX', 'USA');
EXECUTE airport_updating_pkg.update_airport(1, 'CDN', 'Texas', 'TX', 'USA');
select * from airport;

--- TEST CASES FOR AIRPORT DELETES;
EXECUTE airport_deleting_pkg.delete_airport(56);
EXECUTE airport_deleting_pkg.delete_airport(2);
select * from airport;

COMMIT;