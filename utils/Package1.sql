CREATE OR REPLACE PACKAGE pkg_AdminDuties
as
  procedure update_flight_status(p_flight_id NUMBER,p_status VARCHAR2);
  TYPE flight_info_rec IS RECORD (
    flight_id NUMBER,
    source VARCHAR2(50),
    departure_time TIMESTAMP,
    destination VARCHAR2(50),
    arrival_time TIMESTAMP
  );
  TYPE flight_info_tab IS TABLE OF flight_info_rec;
  Function get_departing_flights(airport_code VARCHAR2, flight_date TIMESTAMP) return flight_info_tab pipelined;
END pkg_AdminDuties;
/

CREATE OR REPLACE PACKAGE BODY pkg_AdminDuties
as 
  procedure update_flight_status(p_flight_id NUMBER,p_status VARCHAR2)
  is 
  BEGIN
    UPDATE flight
    SET status = p_status
    WHERE flight_id = p_flight_id;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Flight ' || p_flight_id || ' status updated to ' || p_status);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Flight ' || p_flight_id || ' not found.');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
  END;
  
  Function get_departing_flights(airport_code VARCHAR2, flight_date TIMESTAMP) return flight_info_tab pipelined is
    l_flight_info flight_info_rec;
    cursor flights_cur is
      select f.flight_id, f.source, f.departure_time, f.destination, f.arrival_time
      from flight f
      where f.flight_id = airport_code and  f.departure_time = ''||flight_date||'';
  l_query_str VARCHAR2(4000);
  begin
    l_query_str := 'SELECT f.flight_id, f.source, f.departure_time, f.destination, f.arrival_time '
                    || 'FROM flight f '
                    || 'WHERE f.source = ' || airport_code || ' and f.departure_time = ' || flight_date;
    
    DBMS_OUTPUT.PUT_LINE('Query: ' || l_query_str);  
    for flights_rec in flights_cur loop
      l_flight_info.flight_id := flights_rec.flight_id;
      l_flight_info.source := flights_rec.source;
      l_flight_info.departure_time := flights_rec.departure_time;
      l_flight_info.destination := flights_rec.destination;
      l_flight_info.arrival_time := flights_rec.arrival_time;
      pipe row(l_flight_info);
    end loop;

    return;
  end get_departing_flights;
END pkg_AdminDuties;
/

show errors;
--Function calls
--set serveroutput on;
--SELECT * FROM TABLE(pkg_AdminDuties.get_departing_flights(101, TO_TIMESTAMP('22-MAR-23 12.00.00.000000000 PM')));