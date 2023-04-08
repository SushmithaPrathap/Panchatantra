--DROP USER PassengerUser;
/*

Create a new user PassengerUser who 
can do the following
- Create Details
- Update Details
- Delete Ticket
*/
set serveroutput on;
DECLARE
   v_count INTEGER;
BEGIN
   SELECT COUNT(*) INTO v_count FROM dba_users WHERE username = 'PASSENGERUSER';
   IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'CREATE USER PassengerUser IDENTIFIED BY WorldWideTraveller2024';
        EXECUTE IMMEDIATE 'GRANT CREATE SESSION TO PassengerUser';
        EXECUTE IMMEDIATE 'GRANT EXECUTE ON PASSENGER_ONBOARDING_PKG TO PassengerUser';
        EXECUTE IMMEDIATE 'GRANT EXECUTE ON PASSENGER_UPDATING_PKG TO PassengerUser';
        EXECUTE IMMEDIATE 'GRANT EXECUTE ON PASSENGER_DELETE_PKG TO PassengerUser';        
        DBMS_OUTPUT.PUT_LINE('User PASSENGER CREATED and assigned the necessary priviliges SUCCESSFULLY');
   ELSE
        DBMS_OUTPUT.PUT_LINE('User already exists');
   END IF;
END;
/
