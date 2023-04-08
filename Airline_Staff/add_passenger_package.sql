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
  FUNCTION check_passenger(in_passenger_id IN NUMBER) RETURN NUMBER IS
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
    l_yes NUMBER;
  BEGIN
    l_yes := PASSENGER_TICKET_PACKAGE.check_passenger(p_passenger_id);
    DBMS_OUTPUT.PUT_LINE('Passenger exist ' || l_yes);
    IF l_yes = 1 THEN
      RAISE_APPLICATION_ERROR(-20001, 'PASSENGER ALREADY EXISTS');
    END IF;
    INSERT INTO passenger (
      passenger_id, age, address, sex, govt_id_nos, first_name, last_name, dob, contact_number, email
    ) VALUES (
      p_passenger_id, p_age, p_address, p_sex, p_govt_id_nos, p_first_name, p_last_name, p_dob, p_contact_number, p_email
    );
    COMMIT;
     PROCEDURE INSERT_ORDER() 
   BEGIN
    INSERT INTO orders (order_id, passenger_id, amount, status) 
     VALUES (ADMIN.orders_seq.NEXTVAL, p_passenger_id, 100.0, 'Pending'); 
    COMMIT;
  END INSERT_ORDER;
  END INSERT_PASSENGER;
END PASSENGER_TICKET_PACKAGE;
/


-- check how to add the tikcet after adding the order

-- CREATE OR REPLACE PACKAGE CREATE_TICKET_PACKAGE AS
--   FUNCTION check_order(in_order_id IN NUMBER) RETURN NUMBER;
--   PROCEDURE INSERT_TICKET(
--     p_passenger_id IN NUMBER,
--     p_age IN NUMBER,
--     p_address IN VARCHAR2,
--     p_sex IN VARCHAR2,
--     p_govt_id_nos IN VARCHAR2,
--     p_first_name IN VARCHAR2,
--     p_last_name IN VARCHAR2,
--     p_dob IN DATE,
--     p_contact_number IN NUMBER,
--     p_email IN VARCHAR2
--   );
-- END PASSENGER_TICKET_PACKAGE;
-- /


-- CREATE OR REPLACE PROCEDURE PASSENGER_INSERT IS
-- BEGIN
--     INSERT INTO passenger (passenger_id, age, address, sex, govt_id_nos, first_name, last_name, dob, contact_number, email)
--     VALUES( p_passenger_id , p_age , p_address, p_sex, p_govt_id_nos, p_first_name, p_last_name, p_dob, p_contact_number, p_email)
--     commit;
-- EXCEPTION
--   WHEN OTHERS THEN
--     ROLLBACK;
--     DBMS_OUTPUT.PUT_LINE('Error inserting Passenger: ' || SQLERRM);
-- END PASSENGER_INSERT;

