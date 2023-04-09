/*

1.	Flight Duration Analysis Procedure: This procedure calculates and analyzes 
the average, minimum, and maximum flight duration for a 
particular airline or for all airlines.

*/

BEGIN
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW flight_duration_analysis AS
                    SELECT 
                      CASE
                        WHEN a.airline_id IS NULL THEN ''All Airlines''
                        ELSE TO_CHAR(a.airline_id)
                      END AS airline_id,
                      a.airline_name,
                      MIN(f.duration) AS min_duration,
                      AVG(f.duration) AS avg_duration,
                      MAX(f.duration) AS max_duration
                    FROM 
                      airportadmin.flight f
                      LEFT JOIN airportadmin.airlines a ON f.airline_id = a.airline_id
                    GROUP BY 
                      a.airline_id,a.airline_name
                        ';
    DBMS_OUTPUT.PUT_LINE('The Flight Duration Analysis was created successfully');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

/*
View 2  : Occupancy Rate
*/

BEGIN
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW occupancy_rate_analysis AS
                    SELECT 
                      CASE
                        WHEN f.airline_id IS NULL THEN ''All Airlines''
                        ELSE a.airline_name
                      END AS airline_name,
                      SUM(f.no_pax) AS total_passengers,
                      SUM(f.seats_filled) AS total_seats_filled,
                      ROUND(SUM(f.seats_filled) / SUM(f.no_pax) * 100, 2) AS occupancy_rate
                    FROM 
                      airportadmin.flight f
                      LEFT JOIN airportadmin.airlines a ON f.airline_id = a.airline_id
                    GROUP BY 
                      f.airline_id, a.airline_name;
                        ';
    DBMS_OUTPUT.PUT_LINE('The Occupancy Rate was created successfully');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/


-- Test case for View 1
SELECT * FROM flight_duration_analysis;
SELECT * FROM flight_duration_analysis where airline_id = 1005; 

-- Test case for View 2
SELECT * FROM occupancy_rate_analysis;
SELECT * FROM occupancy_rate_analysis where airline_name = 'American Airlines'; 