CREATE OR REPLACE PACKAGE acct_pkg AS
  FUNCTION calculate_total_revenue RETURN FLOAT;
END acct_pkg;
/

CREATE OR REPLACE PACKAGE BODY acct_pkg AS
  FUNCTION calculate_total_revenue RETURN FLOAT AS
    total_revenue FLOAT := 0;
  BEGIN
    SELECT SUM(amount) INTO total_revenue
    FROM ORDERS
    WHERE status = 'completed'; -- you can adjust the status criteria to your specific needs
    
    RETURN total_revenue;
  END calculate_total_revenue;
END acct_pkg;
/