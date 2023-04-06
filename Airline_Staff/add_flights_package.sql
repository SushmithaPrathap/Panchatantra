CREATE OR REPLACE PACKAGE FLIGHT_PKG AS

  FUNCTION check_airport(in_airport_name IN VARCHAR2) RETURN NUMBER;

  FUNCTION check_duration(in_airport_name IN VARCHAR2) RETURN NUMBER;

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

  FUNCTION check_duration(in_arrival_time IN DATE, in_departure_time IN DATE, in_duration IN NUMBER) RETURN NUMBER IS
    v_result NUMBER;
  BEGIN
    IF in_departure_time - in_arrival_time = in_duration THEN
    v_result = 1;
    ELSE
    v_result = 0 ; 
    END IF;
    RETURN v_result;
  END check_duration;

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
    l_yes BOOLEAN;
  BEGIN

    l_d_airport_count := FLIGHT_PKG.check_airport(p_destination);
    DBMS_OUTPUT.PUT_LINE('Output value for destination: ' || l_d_airport_count);

    IF l_d_airport_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20001, 'Destination airport does not exist in airport table');
    END IF;

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

/*
BEGIN
  FLIGHT_PKG.INSERT_FLIGHT(
    p_flight_id => 115,
    p_duration => 187,
    p_flight_type => 'Airbus A380',
    p_departure_time => TO_TIMESTAMP('2023-03-30 08:00:00', 'YYYY-MM-DD HH24:MI:SS'),
    p_arrival_time => TO_TIMESTAMP('2023-03-29 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
    p_destination => 'BOS',
    p_source => 'LHR',
    p_status => 'On Time',
    p_no_pax => 300,
    p_airline_id => 1010,
    p_seats_filled => 0
  );
END;
*/
