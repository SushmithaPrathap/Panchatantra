-- TEST CASES FOR AN ACCOUNTANT
--alter session set current_schema = ADMIN;
EXECUTE acct_pkg.update_order_status(50006s,'Completed1');
EXECUTE acct_pkg.update_order_status(50006,'Completed');DISCONNECT;
select admin.acct_pkg.calculate_total_revenue() from dual;
execute acct_pkg.update_order_amount(50006,-10000);

