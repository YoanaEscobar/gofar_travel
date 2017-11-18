--------------------------------------------------------
-- Archivo creado  - sábado-noviembre-18-2017   
--------------------------------------------------------
DROP VIEW "ADMINISTRADOR"."PUNTO3";
DROP VIEW "ADMINISTRADOR"."PUNTO5";
DROP TABLE "ADMINISTRADOR"."BILL";
DROP TABLE "ADMINISTRADOR"."BILL_AND_DETAILS";
DROP TABLE "ADMINISTRADOR"."BILL_DETAILS";
DROP TABLE "ADMINISTRADOR"."CITY";
DROP TABLE "ADMINISTRADOR"."COST_CENTER";
DROP TABLE "ADMINISTRADOR"."PATIENT";
DROP SEQUENCE "ADMINISTRADOR"."INCREMENTO_IDBILL";
DROP SEQUENCE "ADMINISTRADOR"."INCREMENTO_IDBILL_AND_DETAILS";
DROP SEQUENCE "ADMINISTRADOR"."INCREMENTO_IDBILL_DETAILS";
DROP SEQUENCE "ADMINISTRADOR"."INCREMENTO_IDCITY";
DROP SEQUENCE "ADMINISTRADOR"."INCREMENTO_IDCOST_CENTER";
DROP SEQUENCE "ADMINISTRADOR"."INCREMENTO_IDPATIENT";
DROP PROCEDURE "ADMINISTRADOR"."INCREASE_COST";
DROP FUNCTION "ADMINISTRADOR"."BALANCE_TOTAL";
DROP FUNCTION "ADMINISTRADOR"."CANTIDAD_ELEMENTOS";
--------------------------------------------------------
--  DDL for View PUNTO3
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ADMINISTRADOR"."PUNTO3" ("NROPATIENT", "NAMES", "ADDRESS", "B_DATE", "TOTAL", "TOTAL_ROOM_BOARD") AS 
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
;
--------------------------------------------------------
--  DDL for View PUNTO5
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ADMINISTRADOR"."PUNTO5" ("NROPATIENT", "NAMES", "ADDRESS", "B_DATE", "DATE_ADMITTED", "DISCHARGE_DATE", "TOTAL_ITEMS_ROOM_BOARD", "BALANCE_ROOM_AND_BOARD", "TOTAL_ITEMS_LABORATORY", "BALANCE_LABORATORY", "TOTAL_ITEMS_RADIOLOGY", "BALANCE_RADIOLOGY") AS 
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
WHERE       F.IDPATIENT         =   P.IDPATIENT
;
--------------------------------------------------------
--  DDL for Table BILL
--------------------------------------------------------

  CREATE TABLE "ADMINISTRADOR"."BILL" 
   (	"IDBILL" NUMBER(20,0), 
	"B_DATE" DATE, 
	"DATE_ADMITTED" DATE, 
	"DISCHARGE_DATE" DATE, 
	"BALANCE_DUE" FLOAT(20), 
	"IDPATIENT" NUMBER(20,0)
   ) ;
--------------------------------------------------------
--  DDL for Table BILL_AND_DETAILS
--------------------------------------------------------

  CREATE TABLE "ADMINISTRADOR"."BILL_AND_DETAILS" 
   (	"IDBILL_AND_DETAILS" NUMBER(20,0), 
	"IDBILL" NUMBER(20,0), 
	"IDBILL_DETAILS" NUMBER(20,0)
   ) ;
--------------------------------------------------------
--  DDL for Table BILL_DETAILS
--------------------------------------------------------

  CREATE TABLE "ADMINISTRADOR"."BILL_DETAILS" 
   (	"IDBILL_DETAILS" NUMBER(20,0), 
	"DATE_CHARGED" DATE, 
	"ITEM_CODE" NUMBER(20,0), 
	"BD_DESCRIPTION" VARCHAR2(300 BYTE), 
	"CHARGE" FLOAT(20), 
	"IDCOST_CENTER" NUMBER(20,0), 
	"UNITS_AVAILABLE" NUMBER(9,0) DEFAULT 100
   ) ;
--------------------------------------------------------
--  DDL for Table CITY
--------------------------------------------------------

  CREATE TABLE "ADMINISTRADOR"."CITY" 
   (	"IDCITY" NUMBER(20,0), 
	"CITY_STATE" VARCHAR2(80 BYTE), 
	"ZIP" VARCHAR2(80 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table COST_CENTER
--------------------------------------------------------

  CREATE TABLE "ADMINISTRADOR"."COST_CENTER" 
   (	"IDCOST_CENTER" NUMBER(20,0), 
	"CODE_COST_CENTER" NUMBER(20,0), 
	"CC_NAME" VARCHAR2(80 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table PATIENT
--------------------------------------------------------

  CREATE TABLE "ADMINISTRADOR"."PATIENT" 
   (	"IDPATIENT" NUMBER(20,0), 
	"NROPATIENT" NUMBER(20,0), 
	"NAMES" VARCHAR2(80 BYTE), 
	"ADDRESS" VARCHAR2(80 BYTE), 
	"IDCITY" NUMBER(20,0)
   ) ;
--------------------------------------------------------
--  DDL for Sequence INCREMENTO_IDBILL
--------------------------------------------------------

   CREATE SEQUENCE  "ADMINISTRADOR"."INCREMENTO_IDBILL"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 21 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence INCREMENTO_IDBILL_AND_DETAILS
--------------------------------------------------------

   CREATE SEQUENCE  "ADMINISTRADOR"."INCREMENTO_IDBILL_AND_DETAILS"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 21 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence INCREMENTO_IDBILL_DETAILS
--------------------------------------------------------

   CREATE SEQUENCE  "ADMINISTRADOR"."INCREMENTO_IDBILL_DETAILS"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 21 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence INCREMENTO_IDCITY
--------------------------------------------------------

   CREATE SEQUENCE  "ADMINISTRADOR"."INCREMENTO_IDCITY"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 21 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence INCREMENTO_IDCOST_CENTER
--------------------------------------------------------

   CREATE SEQUENCE  "ADMINISTRADOR"."INCREMENTO_IDCOST_CENTER"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 21 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence INCREMENTO_IDPATIENT
--------------------------------------------------------

   CREATE SEQUENCE  "ADMINISTRADOR"."INCREMENTO_IDPATIENT"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 21 CACHE 20 NOORDER  NOCYCLE ;
REM INSERTING into ADMINISTRADOR.BILL
SET DEFINE OFF;
Insert into ADMINISTRADOR.BILL (IDBILL,B_DATE,DATE_ADMITTED,DISCHARGE_DATE,BALANCE_DUE,IDPATIENT) values ('1',to_date('10/09/17','DD/MM/RR'),to_date('01/09/17','DD/MM/RR'),to_date('05/09/17','DD/MM/RR'),'1000000','5');
Insert into ADMINISTRADOR.BILL (IDBILL,B_DATE,DATE_ADMITTED,DISCHARGE_DATE,BALANCE_DUE,IDPATIENT) values ('2',to_date('12/09/17','DD/MM/RR'),to_date('03/09/17','DD/MM/RR'),to_date('06/09/17','DD/MM/RR'),'3000000','10');
Insert into ADMINISTRADOR.BILL (IDBILL,B_DATE,DATE_ADMITTED,DISCHARGE_DATE,BALANCE_DUE,IDPATIENT) values ('3',to_date('10/09/17','DD/MM/RR'),to_date('01/09/17','DD/MM/RR'),to_date('08/09/17','DD/MM/RR'),'4','4');
REM INSERTING into ADMINISTRADOR.BILL_AND_DETAILS
SET DEFINE OFF;
Insert into ADMINISTRADOR.BILL_AND_DETAILS (IDBILL_AND_DETAILS,IDBILL,IDBILL_DETAILS) values ('6','1','10');
Insert into ADMINISTRADOR.BILL_AND_DETAILS (IDBILL_AND_DETAILS,IDBILL,IDBILL_DETAILS) values ('7','1','9');
Insert into ADMINISTRADOR.BILL_AND_DETAILS (IDBILL_AND_DETAILS,IDBILL,IDBILL_DETAILS) values ('8','2','8');
Insert into ADMINISTRADOR.BILL_AND_DETAILS (IDBILL_AND_DETAILS,IDBILL,IDBILL_DETAILS) values ('9','2','6');
Insert into ADMINISTRADOR.BILL_AND_DETAILS (IDBILL_AND_DETAILS,IDBILL,IDBILL_DETAILS) values ('11','3','1');
REM INSERTING into ADMINISTRADOR.BILL_DETAILS
SET DEFINE OFF;
Insert into ADMINISTRADOR.BILL_DETAILS (IDBILL_DETAILS,DATE_CHARGED,ITEM_CODE,BD_DESCRIPTION,CHARGE,IDCOST_CENTER,UNITS_AVAILABLE) values ('1',to_date('03/05/17','DD/MM/RR'),'50','Rayos X','20000','1','99');
Insert into ADMINISTRADOR.BILL_DETAILS (IDBILL_DETAILS,DATE_CHARGED,ITEM_CODE,BD_DESCRIPTION,CHARGE,IDCOST_CENTER,UNITS_AVAILABLE) values ('2',to_date('08/05/17','DD/MM/RR'),'100','Glucosa','40000','1','100');
Insert into ADMINISTRADOR.BILL_DETAILS (IDBILL_DETAILS,DATE_CHARGED,ITEM_CODE,BD_DESCRIPTION,CHARGE,IDCOST_CENTER,UNITS_AVAILABLE) values ('3',to_date('04/06/17','DD/MM/RR'),'150','Examen 1','10000','2','100');
Insert into ADMINISTRADOR.BILL_DETAILS (IDBILL_DETAILS,DATE_CHARGED,ITEM_CODE,BD_DESCRIPTION,CHARGE,IDCOST_CENTER,UNITS_AVAILABLE) values ('4',to_date('13/06/17','DD/MM/RR'),'200','Examen 2','60000','2','100');
Insert into ADMINISTRADOR.BILL_DETAILS (IDBILL_DETAILS,DATE_CHARGED,ITEM_CODE,BD_DESCRIPTION,CHARGE,IDCOST_CENTER,UNITS_AVAILABLE) values ('5',to_date('04/04/17','DD/MM/RR'),'250','Compuestos','16224','3','100');
Insert into ADMINISTRADOR.BILL_DETAILS (IDBILL_DETAILS,DATE_CHARGED,ITEM_CODE,BD_DESCRIPTION,CHARGE,IDCOST_CENTER,UNITS_AVAILABLE) values ('6',to_date('13/02/17','DD/MM/RR'),'300','Simples','67059,2','3','100');
Insert into ADMINISTRADOR.BILL_DETAILS (IDBILL_DETAILS,DATE_CHARGED,ITEM_CODE,BD_DESCRIPTION,CHARGE,IDCOST_CENTER,UNITS_AVAILABLE) values ('7',to_date('01/08/17','DD/MM/RR'),'350','Compuestos','53561,25','4','100');
Insert into ADMINISTRADOR.BILL_DETAILS (IDBILL_DETAILS,DATE_CHARGED,ITEM_CODE,BD_DESCRIPTION,CHARGE,IDCOST_CENTER,UNITS_AVAILABLE) values ('8',to_date('20/08/17','DD/MM/RR'),'400','Simples','2142,45','4','100');
Insert into ADMINISTRADOR.BILL_DETAILS (IDBILL_DETAILS,DATE_CHARGED,ITEM_CODE,BD_DESCRIPTION,CHARGE,IDCOST_CENTER,UNITS_AVAILABLE) values ('9',to_date('06/08/17','DD/MM/RR'),'450','Recurso 1','83232','5','100');
Insert into ADMINISTRADOR.BILL_DETAILS (IDBILL_DETAILS,DATE_CHARGED,ITEM_CODE,BD_DESCRIPTION,CHARGE,IDCOST_CENTER,UNITS_AVAILABLE) values ('10',to_date('22/08/17','DD/MM/RR'),'500','Recurso 2','936360','5','100');
REM INSERTING into ADMINISTRADOR.CITY
SET DEFINE OFF;
Insert into ADMINISTRADOR.CITY (IDCITY,CITY_STATE,ZIP) values ('1','Alabama','20');
Insert into ADMINISTRADOR.CITY (IDCITY,CITY_STATE,ZIP) values ('2','Indiana','25');
Insert into ADMINISTRADOR.CITY (IDCITY,CITY_STATE,ZIP) values ('3','Florida','30');
Insert into ADMINISTRADOR.CITY (IDCITY,CITY_STATE,ZIP) values ('4','California','35');
Insert into ADMINISTRADOR.CITY (IDCITY,CITY_STATE,ZIP) values ('5','Kansas','40');
REM INSERTING into ADMINISTRADOR.COST_CENTER
SET DEFINE OFF;
Insert into ADMINISTRADOR.COST_CENTER (IDCOST_CENTER,CODE_COST_CENTER,CC_NAME) values ('1','1000','DG');
Insert into ADMINISTRADOR.COST_CENTER (IDCOST_CENTER,CODE_COST_CENTER,CC_NAME) values ('2','2000','Quimica');
Insert into ADMINISTRADOR.COST_CENTER (IDCOST_CENTER,CODE_COST_CENTER,CC_NAME) values ('3','3000','Radiology');
Insert into ADMINISTRADOR.COST_CENTER (IDCOST_CENTER,CODE_COST_CENTER,CC_NAME) values ('4','4000','Laboratory');
Insert into ADMINISTRADOR.COST_CENTER (IDCOST_CENTER,CODE_COST_CENTER,CC_NAME) values ('5','5000','Room board');
REM INSERTING into ADMINISTRADOR.PATIENT
SET DEFINE OFF;
Insert into ADMINISTRADOR.PATIENT (IDPATIENT,NROPATIENT,NAMES,ADDRESS,IDCITY) values ('1','100','Julio','Calle 20# 40-12','1');
Insert into ADMINISTRADOR.PATIENT (IDPATIENT,NROPATIENT,NAMES,ADDRESS,IDCITY) values ('2','200','Andrea','Calle 80 Apt 103','2');
Insert into ADMINISTRADOR.PATIENT (IDPATIENT,NROPATIENT,NAMES,ADDRESS,IDCITY) values ('3','300','Alison','Carrera 42','3');
Insert into ADMINISTRADOR.PATIENT (IDPATIENT,NROPATIENT,NAMES,ADDRESS,IDCITY) values ('4','400','David Alejandro','Transversal 12# 302','4');
Insert into ADMINISTRADOR.PATIENT (IDPATIENT,NROPATIENT,NAMES,ADDRESS,IDCITY) values ('5','500','Juan David','Calle 12# 302','5');
Insert into ADMINISTRADOR.PATIENT (IDPATIENT,NROPATIENT,NAMES,ADDRESS,IDCITY) values ('6','600','Karen','Calle 70# 2-15','5');
Insert into ADMINISTRADOR.PATIENT (IDPATIENT,NROPATIENT,NAMES,ADDRESS,IDCITY) values ('7','700','Carolina','Transversal 10','4');
Insert into ADMINISTRADOR.PATIENT (IDPATIENT,NROPATIENT,NAMES,ADDRESS,IDCITY) values ('8','800','Adriana','Carrera 30','3');
Insert into ADMINISTRADOR.PATIENT (IDPATIENT,NROPATIENT,NAMES,ADDRESS,IDCITY) values ('9','900','Diego','Calle 50','2');
Insert into ADMINISTRADOR.PATIENT (IDPATIENT,NROPATIENT,NAMES,ADDRESS,IDCITY) values ('10','1000','Rubiela','Transversal 20','1');
Insert into ADMINISTRADOR.PATIENT (IDPATIENT,NROPATIENT,NAMES,ADDRESS,IDCITY) values ('11','1100','Juan Carlos','Calle 25','2');
Insert into ADMINISTRADOR.PATIENT (IDPATIENT,NROPATIENT,NAMES,ADDRESS,IDCITY) values ('12','1200','Daniel','Transversal 70','3');
REM INSERTING into ADMINISTRADOR.PUNTO3
SET DEFINE OFF;
Insert into ADMINISTRADOR.PUNTO3 (NROPATIENT,NAMES,ADDRESS,B_DATE,TOTAL,TOTAL_ROOM_BOARD) values ('500','Juan David','Calle 12# 302',to_date('10/09/17','DD/MM/RR'),'1019592','1019592');
REM INSERTING into ADMINISTRADOR.PUNTO5
SET DEFINE OFF;
Insert into ADMINISTRADOR.PUNTO5 (NROPATIENT,NAMES,ADDRESS,B_DATE,DATE_ADMITTED,DISCHARGE_DATE,TOTAL_ITEMS_ROOM_BOARD,BALANCE_ROOM_AND_BOARD,TOTAL_ITEMS_LABORATORY,BALANCE_LABORATORY,TOTAL_ITEMS_RADIOLOGY,BALANCE_RADIOLOGY) values ('1000','Rubiela','Transversal 20',to_date('12/09/17','DD/MM/RR'),to_date('03/09/17','DD/MM/RR'),to_date('06/09/17','DD/MM/RR'),'2','1019592','1','2142,45','1','67059,2');
Insert into ADMINISTRADOR.PUNTO5 (NROPATIENT,NAMES,ADDRESS,B_DATE,DATE_ADMITTED,DISCHARGE_DATE,TOTAL_ITEMS_ROOM_BOARD,BALANCE_ROOM_AND_BOARD,TOTAL_ITEMS_LABORATORY,BALANCE_LABORATORY,TOTAL_ITEMS_RADIOLOGY,BALANCE_RADIOLOGY) values ('500','Juan David','Calle 12# 302',to_date('10/09/17','DD/MM/RR'),to_date('01/09/17','DD/MM/RR'),to_date('05/09/17','DD/MM/RR'),'2','1019592','1','2142,45','1','67059,2');
Insert into ADMINISTRADOR.PUNTO5 (NROPATIENT,NAMES,ADDRESS,B_DATE,DATE_ADMITTED,DISCHARGE_DATE,TOTAL_ITEMS_ROOM_BOARD,BALANCE_ROOM_AND_BOARD,TOTAL_ITEMS_LABORATORY,BALANCE_LABORATORY,TOTAL_ITEMS_RADIOLOGY,BALANCE_RADIOLOGY) values ('400','David Alejandro','Transversal 12# 302',to_date('10/09/17','DD/MM/RR'),to_date('01/09/17','DD/MM/RR'),to_date('08/09/17','DD/MM/RR'),'2','1019592','1','2142,45','1','67059,2');
--------------------------------------------------------
--  DDL for Index PK_B_A_D_IDBILL_AND_DETAILS
--------------------------------------------------------

  CREATE UNIQUE INDEX "ADMINISTRADOR"."PK_B_A_D_IDBILL_AND_DETAILS" ON "ADMINISTRADOR"."BILL_AND_DETAILS" ("IDBILL_AND_DETAILS") 
  ;
--------------------------------------------------------
--  DDL for Index PK_BILL_DETAILS_IDBILL_DETAILS
--------------------------------------------------------

  CREATE UNIQUE INDEX "ADMINISTRADOR"."PK_BILL_DETAILS_IDBILL_DETAILS" ON "ADMINISTRADOR"."BILL_DETAILS" ("IDBILL_DETAILS") 
  ;
--------------------------------------------------------
--  DDL for Index PK_BILL_IDBILL
--------------------------------------------------------

  CREATE UNIQUE INDEX "ADMINISTRADOR"."PK_BILL_IDBILL" ON "ADMINISTRADOR"."BILL" ("IDBILL") 
  ;
--------------------------------------------------------
--  DDL for Index PK_CITY_IDCITY
--------------------------------------------------------

  CREATE UNIQUE INDEX "ADMINISTRADOR"."PK_CITY_IDCITY" ON "ADMINISTRADOR"."CITY" ("IDCITY") 
  ;
--------------------------------------------------------
--  DDL for Index PK_COST_CENTER_IDCOST_CENTER
--------------------------------------------------------

  CREATE UNIQUE INDEX "ADMINISTRADOR"."PK_COST_CENTER_IDCOST_CENTER" ON "ADMINISTRADOR"."COST_CENTER" ("IDCOST_CENTER") 
  ;
--------------------------------------------------------
--  DDL for Index PK_PATIENT_IDPATIENT
--------------------------------------------------------

  CREATE UNIQUE INDEX "ADMINISTRADOR"."PK_PATIENT_IDPATIENT" ON "ADMINISTRADOR"."PATIENT" ("IDPATIENT") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007316
--------------------------------------------------------

  CREATE UNIQUE INDEX "ADMINISTRADOR"."SYS_C007316" ON "ADMINISTRADOR"."PATIENT" ("NROPATIENT") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007330
--------------------------------------------------------

  CREATE UNIQUE INDEX "ADMINISTRADOR"."SYS_C007330" ON "ADMINISTRADOR"."COST_CENTER" ("CODE_COST_CENTER") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007338
--------------------------------------------------------

  CREATE UNIQUE INDEX "ADMINISTRADOR"."SYS_C007338" ON "ADMINISTRADOR"."BILL_DETAILS" ("ITEM_CODE") 
  ;
--------------------------------------------------------
--  DDL for Trigger DEC_UNITS_AVA
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "ADMINISTRADOR"."DEC_UNITS_AVA" 
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
/
ALTER TRIGGER "ADMINISTRADOR"."DEC_UNITS_AVA" ENABLE;
--------------------------------------------------------
--  DDL for Procedure INCREASE_COST
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "ADMINISTRADOR"."INCREASE_COST" 
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

/
--------------------------------------------------------
--  DDL for Function BALANCE_TOTAL
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "ADMINISTRADOR"."BALANCE_TOTAL" (cost_center_id in integer,bill_id in integer)
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

/
--------------------------------------------------------
--  DDL for Function CANTIDAD_ELEMENTOS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "ADMINISTRADOR"."CANTIDAD_ELEMENTOS" (cost_center_id in integer,bill_id in integer)
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

/
--------------------------------------------------------
--  Constraints for Table BILL
--------------------------------------------------------

  ALTER TABLE "ADMINISTRADOR"."BILL" ADD CONSTRAINT "PK_BILL_IDBILL" PRIMARY KEY ("IDBILL") ENABLE;
  ALTER TABLE "ADMINISTRADOR"."BILL" MODIFY ("IDPATIENT" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."BILL" MODIFY ("BALANCE_DUE" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."BILL" MODIFY ("DISCHARGE_DATE" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."BILL" MODIFY ("DATE_ADMITTED" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."BILL" MODIFY ("B_DATE" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."BILL" MODIFY ("IDBILL" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table BILL_AND_DETAILS
--------------------------------------------------------

  ALTER TABLE "ADMINISTRADOR"."BILL_AND_DETAILS" ADD CONSTRAINT "PK_B_A_D_IDBILL_AND_DETAILS" PRIMARY KEY ("IDBILL_AND_DETAILS") ENABLE;
  ALTER TABLE "ADMINISTRADOR"."BILL_AND_DETAILS" MODIFY ("IDBILL_DETAILS" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."BILL_AND_DETAILS" MODIFY ("IDBILL" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."BILL_AND_DETAILS" MODIFY ("IDBILL_AND_DETAILS" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table BILL_DETAILS
--------------------------------------------------------

  ALTER TABLE "ADMINISTRADOR"."BILL_DETAILS" ADD UNIQUE ("ITEM_CODE") ENABLE;
  ALTER TABLE "ADMINISTRADOR"."BILL_DETAILS" ADD CONSTRAINT "PK_BILL_DETAILS_IDBILL_DETAILS" PRIMARY KEY ("IDBILL_DETAILS") ENABLE;
  ALTER TABLE "ADMINISTRADOR"."BILL_DETAILS" MODIFY ("IDCOST_CENTER" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."BILL_DETAILS" MODIFY ("CHARGE" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."BILL_DETAILS" MODIFY ("BD_DESCRIPTION" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."BILL_DETAILS" MODIFY ("ITEM_CODE" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."BILL_DETAILS" MODIFY ("DATE_CHARGED" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."BILL_DETAILS" MODIFY ("IDBILL_DETAILS" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table CITY
--------------------------------------------------------

  ALTER TABLE "ADMINISTRADOR"."CITY" ADD CONSTRAINT "PK_CITY_IDCITY" PRIMARY KEY ("IDCITY") ENABLE;
  ALTER TABLE "ADMINISTRADOR"."CITY" MODIFY ("ZIP" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."CITY" MODIFY ("CITY_STATE" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."CITY" MODIFY ("IDCITY" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table COST_CENTER
--------------------------------------------------------

  ALTER TABLE "ADMINISTRADOR"."COST_CENTER" ADD UNIQUE ("CODE_COST_CENTER") ENABLE;
  ALTER TABLE "ADMINISTRADOR"."COST_CENTER" ADD CONSTRAINT "PK_COST_CENTER_IDCOST_CENTER" PRIMARY KEY ("IDCOST_CENTER") ENABLE;
  ALTER TABLE "ADMINISTRADOR"."COST_CENTER" MODIFY ("CC_NAME" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."COST_CENTER" MODIFY ("CODE_COST_CENTER" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."COST_CENTER" MODIFY ("IDCOST_CENTER" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table PATIENT
--------------------------------------------------------

  ALTER TABLE "ADMINISTRADOR"."PATIENT" ADD UNIQUE ("NROPATIENT") ENABLE;
  ALTER TABLE "ADMINISTRADOR"."PATIENT" ADD CONSTRAINT "PK_PATIENT_IDPATIENT" PRIMARY KEY ("IDPATIENT") ENABLE;
  ALTER TABLE "ADMINISTRADOR"."PATIENT" MODIFY ("IDCITY" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."PATIENT" MODIFY ("ADDRESS" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."PATIENT" MODIFY ("NAMES" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."PATIENT" MODIFY ("NROPATIENT" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."PATIENT" MODIFY ("IDPATIENT" NOT NULL ENABLE);
--------------------------------------------------------
--  Ref Constraints for Table BILL
--------------------------------------------------------

  ALTER TABLE "ADMINISTRADOR"."BILL" ADD CONSTRAINT "FK_PATIENT_IDPATIENT" FOREIGN KEY ("IDPATIENT")
	  REFERENCES "ADMINISTRADOR"."PATIENT" ("IDPATIENT") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table BILL_AND_DETAILS
--------------------------------------------------------

  ALTER TABLE "ADMINISTRADOR"."BILL_AND_DETAILS" ADD CONSTRAINT "FK_BILL_DETAILS_IDBILL_DETAILS" FOREIGN KEY ("IDBILL_DETAILS")
	  REFERENCES "ADMINISTRADOR"."BILL_DETAILS" ("IDBILL_DETAILS") ENABLE;
  ALTER TABLE "ADMINISTRADOR"."BILL_AND_DETAILS" ADD CONSTRAINT "FK_BILL_IDBILL" FOREIGN KEY ("IDBILL")
	  REFERENCES "ADMINISTRADOR"."BILL" ("IDBILL") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table BILL_DETAILS
--------------------------------------------------------

  ALTER TABLE "ADMINISTRADOR"."BILL_DETAILS" ADD CONSTRAINT "FK_COST_CENTER_IDCOST_CENTER" FOREIGN KEY ("IDCOST_CENTER")
	  REFERENCES "ADMINISTRADOR"."COST_CENTER" ("IDCOST_CENTER") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table PATIENT
--------------------------------------------------------

  ALTER TABLE "ADMINISTRADOR"."PATIENT" ADD CONSTRAINT "FK_CITY_IDCITY" FOREIGN KEY ("IDCITY")
	  REFERENCES "ADMINISTRADOR"."CITY" ("IDCITY") ENABLE;
