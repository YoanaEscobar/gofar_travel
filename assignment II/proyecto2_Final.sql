----Realizado por:
--Julian Soto Giraldo
--Yoana Escobar Diaz
--------------------Entrega 2----------------------------
--------------------Preparacion de Ambiente--------------
--1
CREATE TABLESPACE proyecto2 DATAFILE
'proyecto2.dbf' SIZE 1024M

--2
CREATE USER administrador 
identified by 12345
default tablespace proyecto2

--3
GRANT CONNECT, DBA TO administrador;


----------------------CREACION DE TABLAS-----------------------------------
----------------------crear tabla de CITY--------------------------------
create table CITY (
IdCity number(20) not null,
City_State varchar2(80) not null,
Zip varchar2(80) not null,
CONSTRAINT PK_CITY_IdCity PRIMARY KEY(IdCity));

select * from CITY


CREATE SEQUENCE Incremento_IdCity
INCREMENT BY 1
START WITH 1



-----------------------crear tabla de PATIENT------------------------------
create table PATIENT (
IdPatient number(20) not null, 
NroPatient number(20) unique not null, 
Names varchar2(80) not null,
Address varchar2(80)not null,
IdCity number(20) not null,
CONSTRAINT PK_PATIENT_IdPatient PRIMARY KEY(IdPatient),
CONSTRAINT FK_CITY_IdCity FOREIGN KEY (IdCity) REFERENCES CITY(IdCity));

select * from PATIENT


CREATE SEQUENCE Incremento_IdPatient
INCREMENT BY 1
START WITH 1


-----------------------------crear tabla BILL---------------------------------------

create table BILL (
IdBill number(20) not null, 
B_Date date not null, 
Date_Admitted date not null,
Discharge_Date date not null,
Balance_Due float(20) not null,
IdPatient number(20) not null, 
CONSTRAINT PK_BILL_IdBill PRIMARY KEY(IdBill),
CONSTRAINT FK_PATIENT_IdPatient FOREIGN KEY (IdPatient) REFERENCES PATIENT(IdPatient));

select * from BILL


CREATE SEQUENCE Incremento_IdBill
INCREMENT BY 1
START WITH 1


-------------------------crear tabla COST_CENTER-----------------------------------

create table COST_CENTER (
IdCost_Center number(20) not null,
Code_Cost_Center number(20) unique not null,
CC_Name varchar2(80) not null,
CONSTRAINT PK_COST_CENTER_IdCost_Center PRIMARY KEY(IdCost_Center));


select * from COST_CENTER


CREATE SEQUENCE Incremento_IdCost_Center
INCREMENT BY 1
START WITH 1


--------------------------crear tabla BILL_DETAILS-------------------------------------

create table BILL_DETAILS (
IdBill_Details number(20) not null, 
Date_Charged date not null, 
Item_Code number(20) unique not null,
BD_Description varchar2(300) not null,
Charge float(20) not null,
IdCost_Center number(20) not null,
CONSTRAINT PK_BILL_DETAILS_IdBill_Details PRIMARY KEY(IdBill_Details),
CONSTRAINT FK_COST_CENTER_IdCost_Center FOREIGN KEY (IdCost_Center) REFERENCES COST_CENTER(IdCost_Center));

select * from BILL_DETAILS


CREATE SEQUENCE Incremento_IdBill_Details
INCREMENT BY 1
START WITH 1


-------------------------crear tabla de muchos a muchos BILL_AND_DETAILS-------------------------------

create table BILL_AND_DETAILS (
IdBill_and_Details number(20) not null,
IdBill number(20) not null, 
IdBill_Details number(20) not null, 
CONSTRAINT PK_B_A_D_IdBill_and_Details PRIMARY KEY(IdBill_and_Details),
CONSTRAINT FK_BILL_DETAILS_IdBill_Details FOREIGN KEY (IdBill_Details) REFERENCES BILL_DETAILS(IdBill_Details),
CONSTRAINT FK_BILL_IdBill FOREIGN KEY (IdBill) REFERENCES BILL(IdBill));


select * from BILL_AND_DETAILS



CREATE SEQUENCE Incremento_IdBill_and_Details
INCREMENT BY 1
START WITH 1


--------------------------DATA INSERT----------------------------------------
------------------------inserción tabla CITY---------------------------------

INSERT INTO CITY (IdCity, City_State, Zip)
VALUES (Incremento_IdCity.nextval, 'Alabama', '20');

INSERT INTO CITY (IdCity, City_State, Zip)
VALUES (Incremento_IdCity.nextval, 'Indiana', '25');

INSERT INTO CITY (IdCity, City_State, Zip)
VALUES (Incremento_IdCity.nextval, 'Florida', '30');

INSERT INTO CITY (IdCity, City_State, Zip)
VALUES (Incremento_IdCity.nextval, 'California', '35');

INSERT INTO CITY (IdCity, City_State, Zip)
VALUES (Incremento_IdCity.nextval, 'Kansas', '40');


select * from City


------------------------inserción tabla PATIENT----------------------------------------

INSERT INTO PATIENT (IdPatient, NroPatient, Names, Address, IdCity )
VALUES (Incremento_IdPatient.nextval, 100, 'Julio', 'Calle 20# 40-12',1);

INSERT INTO PATIENT (IdPatient, NroPatient, Names, Address, IdCity )
VALUES (Incremento_IdPatient.nextval, 200, 'Andrea', 'Calle 80 Apt 103',2);

INSERT INTO PATIENT (IdPatient, NroPatient, Names, Address, IdCity )
VALUES (Incremento_IdPatient.nextval, 300, 'Alison', 'Carrera 42',3);

INSERT INTO PATIENT (IdPatient, NroPatient, Names, Address, IdCity )
VALUES (Incremento_IdPatient.nextval, 400, 'David Alejandro', 'Transversal 12# 302',4);

INSERT INTO PATIENT (IdPatient, NroPatient, Names, Address, IdCity )
VALUES (Incremento_IdPatient.nextval, 500, 'Juan David', 'Calle 12# 302',5);

INSERT INTO PATIENT (IdPatient, NroPatient, Names, Address, IdCity )
VALUES (Incremento_IdPatient.nextval, 600, 'Karen', 'Calle 70# 2-15',5);

INSERT INTO PATIENT (IdPatient, NroPatient, Names, Address, IdCity )
VALUES (Incremento_IdPatient.nextval, 700, 'Carolina', 'Transversal 10',4);

INSERT INTO PATIENT (IdPatient, NroPatient, Names, Address, IdCity )
VALUES (Incremento_IdPatient.nextval, 800, 'Adriana', 'Carrera 30',3);

INSERT INTO PATIENT (IdPatient, NroPatient, Names, Address, IdCity )
VALUES (Incremento_IdPatient.nextval, 900, 'Diego', 'Calle 50',2);

INSERT INTO PATIENT (IdPatient, NroPatient, Names, Address, IdCity )
VALUES (Incremento_IdPatient.nextval, 1000, 'Rubiela', 'Transversal 20',1);

INSERT INTO PATIENT (IdPatient, NroPatient, Names, Address, IdCity )
VALUES (Incremento_IdPatient.nextval, 1100, 'Juan Carlos', 'Calle 25',2);

INSERT INTO PATIENT (IdPatient, NroPatient, Names, Address, IdCity )
VALUES (Incremento_IdPatient.nextval, 1200, 'Daniel', 'Transversal 70',3);

select * from PATIENT

---------------------------inserción tabla COST_CENTER------------------------------

INSERT INTO COST_CENTER (IdCost_Center, Code_Cost_Center, CC_Name)
VALUES (Incremento_IdCost_Center.nextval, 1000, 'DG' );

INSERT INTO COST_CENTER (IdCost_Center, Code_Cost_Center, CC_Name)
VALUES (Incremento_IdCost_Center.nextval, 2000, 'Quimica' );

INSERT INTO COST_CENTER (IdCost_Center, Code_Cost_Center, CC_Name)
VALUES (Incremento_IdCost_Center.nextval, 3000, 'Radiology');

INSERT INTO COST_CENTER (IdCost_Center, Code_Cost_Center, CC_Name)
VALUES (Incremento_IdCost_Center.nextval, 4000, 'Laboratory' );

INSERT INTO COST_CENTER (IdCost_Center, Code_Cost_Center, CC_Name)
VALUES (Incremento_IdCost_Center.nextval, 5000, 'Room board' );

select * from COST_CENTER


---------------------------------inserción tabla BILL_DETAILS------------------------------------------------------


INSERT INTO BILL_DETAILS (IdBill_Details, Date_Charged, Item_Code, BD_Description,Charge, IdCost_Center )
VALUES (Incremento_IdBill_Details.nextval, TO_DATE('2017/05/03', 'yyyy/mm/dd'), 50, 'Rayos X', 20000.00,1 );

INSERT INTO BILL_DETAILS (IdBill_Details, Date_Charged, Item_Code, BD_Description,Charge, IdCost_Center )
VALUES (Incremento_IdBill_Details.nextval, TO_DATE('2017/05/08', 'yyyy/mm/dd'), 100, 'Glucosa', 40000.00,1 );

-----

INSERT INTO BILL_DETAILS (IdBill_Details, Date_Charged, Item_Code, BD_Description,Charge, IdCost_Center )
VALUES (Incremento_IdBill_Details.nextval, TO_DATE('2017/06/04', 'yyyy/mm/dd'), 150, 'Examen 1', 10000.00,2 );

INSERT INTO BILL_DETAILS (IdBill_Details, Date_Charged, Item_Code, BD_Description,Charge, IdCost_Center )
VALUES (Incremento_IdBill_Details.nextval, TO_DATE('2017/06/13', 'yyyy/mm/dd'), 200, 'Examen 2', 60000.00,2 );

----

INSERT INTO BILL_DETAILS (IdBill_Details, Date_Charged, Item_Code, BD_Description,Charge, IdCost_Center )
VALUES (Incremento_IdBill_Details.nextval, TO_DATE('2017/04/04', 'yyyy/mm/dd'), 250, 'Compuestos', 15000.00,3 );

INSERT INTO BILL_DETAILS (IdBill_Details, Date_Charged, Item_Code, BD_Description,Charge, IdCost_Center )
VALUES (Incremento_IdBill_Details.nextval, TO_DATE('2017/02/13', 'yyyy/mm/dd'), 300, 'Simples', 62000.00,3 );

-------

INSERT INTO BILL_DETAILS (IdBill_Details, Date_Charged, Item_Code, BD_Description,Charge, IdCost_Center )
VALUES (Incremento_IdBill_Details.nextval, TO_DATE('2017/08/01', 'yyyy/mm/dd'), 350, 'Compuestos', 50000.00,4 );

INSERT INTO BILL_DETAILS (IdBill_Details, Date_Charged, Item_Code, BD_Description,Charge, IdCost_Center )
VALUES (Incremento_IdBill_Details.nextval, TO_DATE('2017/08/20', 'yyyy/mm/dd'), 400, 'Simples', 2000.00,4 );

-------

INSERT INTO BILL_DETAILS (IdBill_Details, Date_Charged, Item_Code, BD_Description,Charge, IdCost_Center )
VALUES (Incremento_IdBill_Details.nextval, TO_DATE('2017/08/06', 'yyyy/mm/dd'), 450, 'Recurso 1', 80000.00,5 );

INSERT INTO BILL_DETAILS (IdBill_Details, Date_Charged, Item_Code, BD_Description,Charge, IdCost_Center )
VALUES (Incremento_IdBill_Details.nextval, TO_DATE('2017/08/22', 'yyyy/mm/dd'), 500, 'Recurso 2', 900000.00,5 );


select * from BILL_DETAILS



------------------------------------------------inserción tabla BILL----------------------------------------------------------------

INSERT INTO BILL(IdBill, B_Date, Date_Admitted, Discharge_Date, Balance_Due, IdPatient)
VALUES (Incremento_IdBill.nextval, TO_DATE('2017/09/10', 'yyyy/mm/dd'), TO_DATE('2017/09/01', 'yyyy/mm/dd'), TO_DATE('2017/09/05', 'yyyy/mm/dd'),1000000.00,5);

INSERT INTO BILL (IdBill, B_Date, Date_Admitted, Discharge_Date,Balance_Due, IdPatient)
VALUES (Incremento_IdBill.nextval, TO_DATE('2017/09/12', 'yyyy/mm/dd'), TO_DATE('2017/09/03', 'yyyy/mm/dd'), TO_DATE('2017/09/06', 'yyyy/mm/dd') ,3000000.00,10);

select * from BILL


--------------------------------------inserción tabla BILL_AND_DETAILS------------------------------------------------------------------

INSERT INTO BILL_AND_DETAILS (IdBill_and_Details, IdBill, IdBill_Details )
VALUES (Incremento_IdBill_and_Details.nextval,1,10 );

INSERT INTO BILL_AND_DETAILS (IdBill_and_Details, IdBill, IdBill_Details )
VALUES (Incremento_IdBill_and_Details.nextval,1,9 );

INSERT INTO BILL_AND_DETAILS (IdBill_and_Details, IdBill, IdBill_Details )
VALUES (Incremento_IdBill_and_Details.nextval,2,8 );

INSERT INTO BILL_AND_DETAILS (IdBill_and_Details, IdBill, IdBill_Details )
VALUES (Incremento_IdBill_and_Details.nextval,2,6 );


select * from BILL
select * from BILL_DETAILS
select * from BILL_AND_DETAILS


-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------

-----------------------------------------------Entrega 2-----------------------------------------------

--3. Create a view to display the information of the bill (patient, patient_name, patient_address, date, total,
--total_room_board) which has the highest balance due for the 'Room & board' cost center. (0.5)

--3. Cree una vista para mostrar la información de la factura (patient, patient_name, patient_address, date, total,
--total_room_board) que tiene el mayor saldo adeudado para el centro de costos de 'Room & board'. (0.5)

CREATE OR REPLACE VIEW punto3 AS
SELECT  P.NROPATIENT,
        P.NAMES,
        P.ADDRESS, 
        F.B_DATE, 
        SUM(L.CHARGE) as "TOTAL",
        (
            -- mayor saldo adeudado para el centro de costos de 'Room board'
            SELECT      SUM(L.CHARGE)
            FROM        BILL_DETAILS L 
            INNER JOIN  COST_CENTER C
            ON          L.IDCOST_CENTER     =   C.IDCOST_CENTER
            INNER JOIN  BILL_AND_DETAILS D
            ON          L.IDBILL_DETAILS    =   D.IDBILL_DETAILS
            INNER JOIN  BILL F
            ON          D.IDBILL            =   F.IDBILL
            INNER JOIN  PATIENT P
            ON          F.IDPATIENT         =   P.IDPATIENT  
            WHERE       C.CC_NAME               =   'Room board'
        ) 
        TOTAL_ROOM_BOARD        
FROM        BILL_DETAILS L 
INNER JOIN  COST_CENTER C
ON          C.IDCOST_CENTER = L.IDCOST_CENTER 
INNER JOIN  BILL_AND_DETAILS D
ON          L.IDBILL_DETAILS    =   D.IDBILL_DETAILS
INNER JOIN  BILL F
ON          D.IDBILL            =   F.IDBILL
INNER JOIN  PATIENT P
ON          F.IDPATIENT         =   P.IDPATIENT
WHERE       P.IDPATIENT IN 
    (
        SELECT      P.IDPATIENT 
        FROM        PATIENT P
        INNER JOIN  BILL F
        ON          P.IDPATIENT         =   F.IDPATIENT
        INNER JOIN  BILL_AND_DETAILS L
        ON          F.IDBILL    =   L.IDBILL
        INNER JOIN  BILL_DETAILS N
        ON          L.IDBILL_DETAILS = N.IDBILL_DETAILS
        INNER JOIN  COST_CENTER C 
        ON          N.IDCOST_CENTER = C.IDCOST_CENTER
        WHERE       C.CC_NAME               =   'Room board'
    )
GROUP BY    P.NROPATIENT,
            P.NAMES,
            P.ADDRESS,
            F.B_DATE

SELECT * FROM punto3;

----------------------------------------------------------------------------------------------------------------------------
 
--4. Create two functions, the first one which receives 2 params: (cost_center_id, bill_id) and return the
--total balance for all items which belongs to the cost center and associated to a bill. The second one
--also receives 2 params (cost_center_id, bill_id) and return the total of number of items associated to a
--bill which belongs to the cost center (0.5)

--4. Crea dos funciones, la primera que recibe 2 params: (cost_center_id, bill_id) y devuelve el
--saldo total de todos los artículos que pertenecen al centro de costos y están asociados a una factura. 

--El segundo:
--también recibe 2 params (cost_center_id, bill_id) y devuelve el total de la cantidad de elementos asociados a una
--factura que pertenece al centro de costos (0.5)


-------------------------------------------funcion 1-------------------------------------------------------------
CREATE or replace FUNCTION balance_total(cost_center_id in integer,bill_id in integer)
return number is 
SALIDA NUMBER;
BEGIN  
     SELECT SUM(L.CHARGE) AS "SALDO TOTAL ARTICULOS" INTO SALIDA
            FROM        BILL_DETAILS L 
            INNER JOIN  COST_CENTER C
            ON          L.IDCOST_CENTER     =   C.IDCOST_CENTER
            INNER JOIN  BILL_AND_DETAILS D
            ON          L.IDBILL_DETAILS    =   D.IDBILL_DETAILS
            INNER JOIN  BILL F
            ON          D.IDBILL            =   F.IDBILL
            INNER JOIN  PATIENT P
            ON          F.IDPATIENT         =   P.IDPATIENT  
            WHERE       C.IDCOST_CENTER              =   cost_center_id    AND    F.IDBILL= bill_id; 
RETURN SALIDA;
END;

select balance_total(&cost_center_id,&bill_id) as "SALDO TOTAL ARTICULOS" from dual;


------------------------------------------funcion 2----------------------------------------------------------------


CREATE or replace FUNCTION cantidad_elementos(cost_center_id in integer,bill_id in integer)
return number is 
SALIDA NUMBER;
BEGIN  
     SELECT COUNT(L.ITEM_CODE) AS "CANTIDAD TOTAL" INTO SALIDA
            FROM        BILL_DETAILS L 
            INNER JOIN  COST_CENTER C
            ON          L.IDCOST_CENTER     =   C.IDCOST_CENTER
            INNER JOIN  BILL_AND_DETAILS D
            ON          L.IDBILL_DETAILS    =   D.IDBILL_DETAILS
            INNER JOIN  BILL F
            ON          D.IDBILL            =   F.IDBILL
            INNER JOIN  PATIENT P
            ON          F.IDPATIENT         =   P.IDPATIENT  
            WHERE       C.IDCOST_CENTER     =   cost_center_id    AND    F.IDBILL= bill_id; 
RETURN SALIDA;
END;

select cantidad_elementos(&cost_center_id,&bill_id) as "CANTIDAD TOTAL" from dual;

---------------------------------------------------------------------------------------------------------------

--5. Create a view to display the information of the bills patient, patient_name, patient_address, date,
--date_admitted, discharge_date, total_items_room_board, balance_room_and_board,
--total_items_laboratory, balance_laboratory, total_items_radiology, balance_radiology. Use the
--functions created in the previous step (0.5)


--5. Cree una vista para mostrar la información de las facturas patient, patient_name, patient_address, date,
--date_admitted, discharge_date, total_items_room_board, balance_room_and_board,
--total_items_laboratory, balance_laboratory, total_items_radiology, balance_radiology. Utilizar el
--funciones creadas en el paso anterior (0.5)


CREATE OR REPLACE VIEW punto5 AS
SELECT  DISTINCT 
        P.NROPATIENT,
        P.NAMES,
        P.ADDRESS, 
        F.B_DATE, 
        F.DATE_ADMITTED,
        F.DISCHARGE_DATE,
        
        (select cantidad_elementos ('5','1') FROM dual) TOTAL_ITEMS_ROOM_BOARD,
        (select balance_total('5','1') from dual) BALANCE_ROOM_AND_BOARD,
        
        (select cantidad_elementos('4','2') FROM dual) TOTAL_ITEMS_LABORATORY,
        (select balance_total('4','2') from dual) BALANCE_LABORATORY,
        
        (select cantidad_elementos('3','2') FROM dual) TOTAL_ITEMS_RADIOLOGY,
        (select balance_total('3','2') from dual) BALANCE_RADIOLOGY    

FROM        BILL_DETAILS L 
INNER JOIN  COST_CENTER C
ON          C.IDCOST_CENTER = L.IDCOST_CENTER 
INNER JOIN  BILL_AND_DETAILS D
ON          L.IDBILL_DETAILS    =   D.IDBILL_DETAILS
INNER JOIN  BILL F
ON          D.IDBILL            =   F.IDBILL
INNER JOIN  PATIENT P
ON          F.IDPATIENT         =   P.IDPATIENT
WHERE       F.IDPATIENT         =   P.IDPATIENT;


----------------------------------------------------------------------------------------

--6. Create the explain plan for the last step (add a screenshot or copy and paste the information returned)
--(0.5)

select * from punto5;

-------------------------------------------------------------------------------------------------------------------
--7. The product owner has requested a change, they want to handle some sort of inventory for items
--which belongs to each cost center, the table where you store those items should have a column
--"units_available" or "unidades_disponibles" (if you made the diagram in spanish). (0.5)


ALTER TABLE BILL_DETAILS
  ADD units_available number(9) default 100;

select * from BILL_DETAILS;


------------------------------------------------------------------------------------------------------------------------
--8. Create a trigger which decreases the number of units available when an item is associated to a bill.(0.5)

create or replace trigger dec_units_ava
before insert or update of IDBILL_DETAILS on BILL_AND_DETAILS 
for each row
declare
--declaracion de variabes de trabajo nuevas y viejas unidades
  unidades_viejas number;
  unidades_nuevas number; 
begin
   if (:old.IDBILL_DETAILS IS NULL) then
    unidades_viejas := 0;  --inicializacion de variable vieja
   else
    select units_available into unidades_viejas from BILL_DETAILS where IDBILL_DETAILS = :old.IDBILL_DETAILS;
    --guarda en variable vieja items viejos
   end if;
    --guarda en variable nueva items nuevos
  select units_available into unidades_nuevas from BILL_DETAILS where IDBILL_DETAILS = :new.IDBILL_DETAILS; 
  --valida la existencia de unidades disponibles
  if (unidades_nuevas > 0) then
  --valida la actualizacion
    if (:old.IDBILL_DETAILS != :new.IDBILL_DETAILS) then
      update BILL_DETAILS set units_available = (unidades_viejas + 1) where IDBILL_DETAILS = :old.IDBILL_DETAILS;
    end if;
    update BILL_DETAILS set units_available = (unidades_nuevas - 1) where IDBILL_DETAILS = :new.IDBILL_DETAILS;
  else
    dbms_output.put_line('No existen unidades para este producto');
  end if;
end;


select * from BILL_DETAILS;

select * from BILL;

select * from BILL_AND_DETAILS;

--inserción tabla BILL
INSERT INTO BILL(IdBill, B_Date, Date_Admitted, Discharge_Date, Balance_Due, IdPatient)
VALUES (Incremento_IdBill.nextval, TO_DATE('2017/09/10', 'yyyy/mm/dd'), TO_DATE('2017/09/01', 'yyyy/mm/dd'), TO_DATE('2017/09/08', 'yyyy/mm/dd'),4.00,4);

--inserción tabla BILL_AND_DETAILS
INSERT INTO BILL_AND_DETAILS (IdBill_and_Details, IdBill, IdBill_Details )
VALUES (Incremento_IdBill_and_Details.nextval,3,1 );

--------------------------------------------------------------------------------------------------------------------------

--9. Create a procedure to increase the cost of each item as follows (0.5) :
--? If the item belongs to Room & board cost center: 2%
--? If the item belongs to Laboratory: 3.5%
--? If the item belongs to Radiology: 4%

CREATE OR REPLACE PROCEDURE increase_cost
IS

BEGIN
    
    update BILL_DETAILS set CHARGE = CHARGE + CHARGE*0.02 
    where IDCOST_CENTER =
    (SELECT C.IDCOST_CENTER  FROM COST_CENTER C WHERE C.CC_NAME='Room board');
       
       
     update BILL_DETAILS set CHARGE = CHARGE + CHARGE*0.035 
    where IDCOST_CENTER =
    (SELECT C.IDCOST_CENTER  FROM COST_CENTER C WHERE C.CC_NAME='Laboratory');
    
    
     update BILL_DETAILS set CHARGE = CHARGE + CHARGE*0.04 
    where IDCOST_CENTER =
    (SELECT C.IDCOST_CENTER  FROM COST_CENTER C WHERE C.CC_NAME='Radiology');

END;

select * from cost_center;
select * from BILL_DETAILS;

-----------------------------------------------------------------------------------------------



