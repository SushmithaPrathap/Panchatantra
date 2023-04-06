CREATE OR REPLACE PACKAGE PASSENGER_TICKET_PACKAGE AS

  FUNCTION check_passenger(in_passenger_id IN NUMBER) RETURN NUMBER;

  PROCEDURE INSERT_PASSENGER(
    p_passenger_id IN NUMBER,
    p_age IN NUMBER,
    p_address IN VARCHAR2,
    p_sex IN VARCHAR2,
    p_govt_id_nos IN VARCHAR2,
    p_first_name IN VARCHAR2,
    p_last_name IN VARCHAR2,
    p_dob IN DATE,
    p_contact_number IN NUMBER,
    p_email IN VARCHAR2
  );
END PASSENGER_TICKET_PACKAGE;
/


CREATE OR REPLACE PACKAGE BODY PASSENGER_TICKET_PACKAGE AS

  FUNCTION check_passenger(in_passenger_id IN VARCHAR2) RETURN NUMBER IS
    v_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_result
    FROM passenger
    WHERE passenger_id = in_passenger_id;

    RETURN v_result;
  END check_passenger;

   PROCEDURE INSERT_PASSENGER(
    p_passenger_id IN NUMBER,
    p_age IN NUMBER,
    p_address IN VARCHAR2,
    p_sex IN VARCHAR2,
    p_govt_id_nos IN VARCHAR2,
    p_first_name IN VARCHAR2,
    p_last_name IN VARCHAR2,
    p_dob IN DATE,
    p_contact_number IN NUMBER,
    p_email IN VARCHAR2
  ) AS
    l_d_airport_count NUMBER;
    l_s_airport_count NUMBER;
    l_yes BOOLEAN;
  BEGIN

    l_d_airport_count := PASSENGER_TICKET_PACKAGE.check_airport(p_destination);
    DBMS_OUTPUT.PUT_LINE('Output value for destination: ' || l_d_airport_count);

    IF l_d_airport_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20001, 'Destination airport does not exist in airport table');
    END IF;

    l_s_airport_count := PASSENGER_TICKET_PACKAGE.check_airport(p_source);
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
END PASSENGER_TICKET_PACKAGE;
/


CREATE OR REPLACE PROCEDURE PASSENGER_INSERT IS
BEGIN
    INSERT INTO passenger (passenger_id, age, address, sex, govt_id_nos, first_name, last_name, dob, contact_number, email)
    VALUES( p_passenger_id , p_age , p_address, p_sex, p_govt_id_nos, p_first_name, p_last_name, p_dob, p_contact_number, p_email)
    commit;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error inserting Passenger: ' || SQLERRM);
END PASSENGER_INSERT;

