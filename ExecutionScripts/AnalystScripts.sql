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
    DBMS_OUTPUT.PUT_LINE('An error occurred: '
      || SQLERRM);
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
                      f.airline_id, a.airline_name
                        ';
  DBMS_OUTPUT.PUT_LINE('The Occupancy Rate was created successfully');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: '
      || SQLERRM);
END;
/

/*
-- View 3: Retrieve count of the cancelled flights in the airport
*/
BEGIN
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW flight_cancellation_counts AS
    SELECT f.flight_id, COUNT(*) AS cancellation_count
    FROM airportadmin.ticket t
    JOIN airportadmin.flight f ON t.flight_id = f.flight_id
    WHERE f.status = ''Cancelled''
    GROUP BY f.flight_id';
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: '
      || SQLERRM);
END;
/

/*
View 4: View to see the number of employees per airline
*/
BEGIN
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW airline_staff_counts AS
    SELECT airline_name, COUNT(*) AS num_staff
    FROM airline_staff
    JOIN airlines ON airline_staff.airline_id = airlines.airline_id
    GROUP BY airline_name';
  DBMS_OUTPUT.PUT_LINE('The airline_staff_counts view was created successfully');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: '
      || SQLERRM);
END;
/

/*
View 5: The Below block of code creates views from the ticket table for monthly ticket sales
*/
BEGIN
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW monthly_ticket_sales AS
SELECT TO_CHAR(date_of_travel, 'YYYY-MM') AS month,
       SUM(Transaction_amount) AS total_sales
FROM ticket
GROUP BY TO_CHAR(date_of_travel, 'YYYY-MM')';
  DBMS_OUTPUT.PUT_LINE('The monthly_ticket_sales view was created successfully');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: '
      || SQLERRM);
END;
/*
View 6: The Below block of code creates a view to see number of flights between boston and california
*/
BEGIN
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW flights_between_boston_and_california AS
  SELECT f.flight_id, f.duration, f.flight_type, f.source, f.destination, f.status, f.no_pax, f.airline_id, f.seats_filled, s.schedule_id, s.terminal_id, s.arrival_time, s.departure_time
  FROM flight f
  JOIN schedule s ON f.flight_id = s.flight_id
  WHERE f.source = ''Boston'' AND f.destination = ''California''
  AND s.departure_time > SYSTIMESTAMP()';
  DBMS_OUTPUT.PUT_LINE('The flights_between_boston_and_california view was created successfully');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: '
      || SQLERRM);
END;


GRANT SELECT ON  AIRPORTADMIN.monthly_ticket_sales TO ACCOUNTANT;
GRANT SELECT ON  AIRPORTADMIN.monthly_ticket_sales TO ANALYST;

select * from monthly_ticket_sales;

-- Test case for View 1
SELECT * FROM flight_duration_analysis;
SELECT * FROM flight_duration_analysis where airline_id = 1005; 

-- Test case for View 2
SELECT * FROM occupancy_rate_analysis;
SELECT * FROM occupancy_rate_analysis where airline_name = 'American Airlines'; 

-- Test case for View 3
SELECT * FROM flight_cancellation_counts;