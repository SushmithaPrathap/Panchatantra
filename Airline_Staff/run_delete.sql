--EXECUTE ORDER_DELETE_PKG.delete_order(50010);
EXECUTE FLIGHT_DELETE_PKG.delete_flight(4016);
-- EXECUTE FLIGHT_DELETE_PKG.delete_flight(4012);
/

--select * from orders;
--select * from ticket;
--select * from baggage;

select * from flight;
select * from schedule;