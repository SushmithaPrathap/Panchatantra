CREATE OR REPLACE PACKAGE FLIGHT_PKG AS

  FUNCTION check_airport(in_airport_name IN VARCHAR2) RETURN NUMBER;

  PROCEDURE INSERT_FLIGHT(
    p_flight_id IN NUMBER,
    p_duration IN NUMBER,
    p_flight_type IN VARCHAR2,
    p_departure_time IN DATE,
    p_arrival_time IN DATE,
    p_destination IN VARCHAR2,
    p_source IN VARCHAR2,
    p_status IN VARCHAR2,
    p_no_pax IN NUMBER,
    p_airline_id IN NUMBER,
    p_seats_filled IN NUMBER
  );
END FLIGHT_PKG;
/

CREATE OR REPLACE PACKAGE BODY FLIGHT_PKG AS

FUNCTION check_airport(in_airport_name IN VARCHAR2) RETURN NUMBER IS
    v_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_result
    FROM airport
    WHERE airport_name = in_airport_name;

    RETURN v_result;
  END check_airport;

  PROCEDURE INSERT_FLIGHT(
    p_flight_id IN NUMBER,
    p_duration IN NUMBER,
    p_flight_type IN VARCHAR2,
    p_departure_time IN DATE,
    p_arrival_time IN DATE,
    p_destination IN VARCHAR2,
    p_source IN VARCHAR2,
    p_status IN VARCHAR2,
    p_no_pax IN NUMBER,
    p_airline_id IN NUMBER,
    p_seats_filled IN NUMBER
  ) AS
    l_d_airport_count NUMBER;
    l_s_airport_count NUMBER;
  BEGIN
    -- -- Check if destination airport exists
    -- SELECT COUNT(*)
    -- INTO l_d_airport_count
    -- FROM airport
    -- WHERE airport_name = p_destination;

    l_d_airport_count := FLIGHT_PKG.check_airport(p_destination);
    DBMS_OUTPUT.PUT_LINE('Output value for destination: ' || l_d_airport_count);


    IF l_d_airport_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20001, 'Destination airport does not exist in airport table');
    END IF;

    -- -- Check if source airport exists
    -- SELECT COUNT(*)
    -- INTO l_s_airport_count
    -- FROM airport
    -- WHERE airport_name = p_source;

      l_s_airport_count := FLIGHT_PKG.check_airport(p_source);
    DBMS_OUTPUT.PUT_LINE('Output value for source: ' || l_s_airport_count);

    IF l_s_airport_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20002, 'Source airport does not exist in airport table');
    END IF;

    -- Insert flight record
    INSERT INTO flight (
      flight_id,
      duration,
      flight_type,
      departure_time,
      arrival_time,
      destination,
      source,
      status,
      no_pax,
      airline_id,
      seats_filled
    ) VALUES (
      p_flight_id,
      p_duration,
      p_flight_type,
      p_departure_time,
      p_arrival_time,
      p_destination,
      p_source,
      p_status,
      p_no_pax,
      p_airline_id,
      p_seats_filled
    );
  END INSERT_FLIGHT;
END FLIGHT_PKG;
/


BEGIN
  FLIGHT_PKG.INSERT_FLIGHT(
    p_flight_id => 112,
    p_duration => 187,
    p_flight_type => 'Airbus A380',
    p_departure_time => TO_TIMESTAMP('2023-03-30 08:00:00', 'YYYY-MM-DD HH24:MI:SS'),
    p_arrival_time => TO_TIMESTAMP('2023-03-29 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
    p_destination => 'LHR',
    p_source => 'BOS',
    p_status => 'On Time',
    p_no_pax => 300,
    p_airline_id => 1010,
    p_seats_filled => 0
  );
END;
