set serveroutput on;

--- TEST CASES FOR terminal INSERTS;
EXECUTE AIRLINE_STAFF_PKG.INSERT_AIRLINE_STAFF(1,'Harshita','Ranganath','28 Greylock, Boston, MA 02113','345 89 9901','harshita@gmail.com',8573132793,1,'Female');
EXECUTE AIRLINE_STAFF_PKG.INSERT_AIRLINE_STAFF(4,'Sushmitha','Prathap','25 Perry, Boston, MA 02313','465 09 9981','sushmitha@gmail.com',6573132783,3,'Female');
EXECUTE AIRLINE_STAFF_PKG.INSERT_AIRLINE_STAFF(10,'Abhishek','Shankar','19 Tabor, Boston, MA 02115','745 89 9951','abhishek@gmail.com',8273132713,4,'Male');
EXECUTE AIRLINE_STAFF_PKG.INSERT_AIRLINE_STAFF(4,'Anvi','Jain','26 Greylock, Boston, MA 02443','145 69 9901','anvi@gmail.com',8973132773,5,'Female');
EXECUTE AIRLINE_STAFF_PKG.INSERT_AIRLINE_STAFF(3,'Manikanta','Reddy','13 Parker, Boston, MA 02103','555 89 9201','manikanta@gmail.com',8173132773,2,'Male');
select * from airline_staff;
