set serveroutput on;

--- TEST CASES FOR terminal INSERTS;
EXECUTE TERMINAL_PKG.INSERT_TERMINAL('Terminal F');
EXECUTE TERMINAL_PKG.INSERT_TERMINAL('');
EXECUTE TERMINAL_PKG.INSERT_TERMINAL(NULL);

select * from terminal;

--- TEST CASES FOR terminal UPDATES;
EXECUTE terminal_updating_pkg.update_terminal(6000, 'T1');
EXECUTE terminal_updating_pkg.update_terminal(7000, 'T1');
EXECUTE terminal_updating_pkg.update_terminal(6000, NULL);
EXECUTE terminal_updating_pkg.update_terminal(6000, 'Terminal A');
select * from terminal;

