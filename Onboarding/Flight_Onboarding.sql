CREATE OR REPLACE PACKAGE ONBOARD_FLIGHT_PKG AS

  FUNCTION check_airport(in_airport_name IN VARCHAR2) RETURN NUMBER;

  FUNCTION get_duration(in_arrival_time IN DATE, in_departure_time IN DATE) RETURN NUMBER;

  PROCEDURE INSERT_FLIGHT(
    p_flight_id IN NUMBER,
    p_flight_type IN VARCHAR2,
    p_departure_time IN DATE,
    p_arrival_time IN DATE,
    p_destination IN VARCHAR2,
    p_source IN VARCHAR2,
    p_status IN VARCHAR2,
    p_no_pax IN NUMBER,
    p_airline_id IN NUMBER,
    p_seats_filled IN NUMBER,
    p_terminal_id IN NUMBER
  );
END ONBOARD_FLIGHT_PKG;
/

CREATE OR REPLACE PACKAGE BODY ONBOARD_FLIGHT_PKG AS

  FUNCTION check_airport(in_airport_name IN VARCHAR2) RETURN NUMBER IS
    v_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_result
    FROM airport
    WHERE airport_name = in_airport_name;

    RETURN v_result;
  END check_airport;

FUNCTION get_duration(in_arrival_time IN DATE, in_departure_time IN DATE) RETURN NUMBER IS
    v_result NUMBER;
  BEGIN
    IF in_arrival_time <= in_departure_time THEN
      RAISE_APPLICATION_ERROR(-20001, 'Arrival time must be after departure time');
    END IF;
    v_result := ROUND((in_arrival_time - in_departure_time) * 24 * 60);
    RETURN v_result;
  END get_duration;
  
  PROCEDURE INSERT_FLIGHT(
    p_flight_id IN NUMBER,
    -- p_duration IN NUMBER,
    p_flight_type IN VARCHAR2,
    p_departure_time IN DATE,
    p_arrival_time IN DATE,
    p_destination IN VARCHAR2,
    p_source IN VARCHAR2,
    p_status IN VARCHAR2,
    p_no_pax IN NUMBER,
    p_airline_id IN NUMBER,
    p_seats_filled IN NUMBER,
    p_terminal_id IN NUMBER
  ) AS
    l_d_airport_count NUMBER;
    l_s_airport_count NUMBER;
    l_duration NUMBER;

    INVALID_INPUTS EXCEPTION;
    
  BEGIN

   IF
    (
        p_flight_id <= 0
        OR LENGTH(p_flight_type)<= 0
        OR p_departure_time is NULL
        OR p_arrival_time is NULL
        OR LENGTH(p_source) <= 0
        OR LENGTH(p_destination)<=0
        OR LENGTH(p_status)<=0
        OR p_no_pax <= 0
        OR p_seats_filled > 0
        OR p_airline_id <= 0
        OR p_terminal_id <= 0
    ) THEN 
        RAISE INVALID_INPUTS;
    END IF;

    l_d_airport_count := ONBOARD_FLIGHT_PKG.check_airport(p_destination);
    DBMS_OUTPUT.PUT_LINE('Output value for destination: ' || l_d_airport_count);

    IF l_d_airport_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20001, 'Destination airport does not exist in airport table');
    END IF;

    l_s_airport_count := ONBOARD_FLIGHT_PKG.check_airport(p_source);
    DBMS_OUTPUT.PUT_LINE('Output value for source: ' || l_s_airport_count);

    IF l_s_airport_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20002, 'Source airport does not exist in airport table');
    END IF;

     l_duration := ONBOARD_FLIGHT_PKG.get_duration(p_arrival_time, p_departure_time);
    DBMS_OUTPUT.PUT_LINE('Duration Match: ' || l_duration);

    IF l_duration = 0 THEN
      RAISE_APPLICATION_ERROR(-20002, 'Duration is Wrong');
    END IF;

    -- Insert flight record
    INSERT INTO flight (
      flight_id,
      duration,
      flight_type,
    --   departure_time,
    --   arrival_time,
      destination,
      source,
      status,
      no_pax,
      airline_id,
      seats_filled
    ) VALUES (
      p_flight_id,
      l_duration,
      p_flight_type,
    --   p_departure_time,
    --   p_arrival_time,
      p_destination,
      p_source,
      p_status,
      p_no_pax,
      p_airline_id,
      p_seats_filled
    );
    COMMIT;

--insert a schedule for the flight
    INSERT INTO schedule (schedule_id, flight_id, terminal_id, arrival_time, departure_time) 
    VALUES (ADMIN.schedule_seq.NEXTVAL, p_flight_id, p_terminal_id, p_arrival_time ,p_departure_time);       --insert a schedule sequence
    COMMIT;
EXCEPTION
  WHEN INVALID_INPUTS THEN 
    dbms_output.put_line('Invalid input' || p_arrival_time || p_departure_time ||  p_flight_id || l_duration ||
      p_flight_type ||
      p_destination ||
      p_source ||
      p_status ||
      p_no_pax ||
      p_airline_id ||
      p_seats_filled );

  END INSERT_FLIGHT;
END ONBOARD_FLIGHT_PKG;
/