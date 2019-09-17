
/*
 DELETE the existing tables (if any) in the employee database for Lab 3
 */ 

DROP TABLE IF EXISTS works_on CASCADE;
DROP TABLE IF EXISTS dept_location CASCADE;
DROP TABLE IF EXISTS department CASCADE;
DROP TABLE IF EXISTS project CASCADE;
DROP TABLE IF EXISTS employee CASCADE;

/*
 Create the employee database for Lab 3
 */ 

/* Create the department table */
CREATE TABLE department (
  dname        varchar(30) NOT NULL,
  dnumber      integer PRIMARY KEY,
  mgrssn       integer,
  mgrstartdate date
);


/* Create the dept_location table (depends on department) */
CREATE TABLE dept_location (
  dnumber   integer REFERENCES department(dnumber),
  dlocation varchar(30),
  PRIMARY KEY (dnumber,dlocation)
);


/* Create the employee table (depends on department) */
CREATE TABLE employee (
  fname      varchar(25) NOT NULL,
  minit      char(1),
  lname      varchar(25) NOT NULL,
  ssn        integer    
    PRIMARY KEY,
  bdate      date NOT NULL,
  address    varchar(200),
  sex        char(1) NOT NULL 
    CHECK (sex IN ('M','F','O')),
  salary     decimal(12,2) NOT NULL,
  superssn   integer,
  dno        integer
    REFERENCES department(dnumber)
);


/* Create the project table. */
CREATE TABLE project (
  pname     varchar(30) NOT NULL,
  pnumber   integer PRIMARY KEY,
  plocation varchar(30) NOT NULL,
  dnum      integer NOT NULL REFERENCES department(dnumber)
);


/* Create the works_on table */
CREATE TABLE works_on (
  ssn        integer NOT NULL REFERENCES employee(ssn),
  pno        integer REFERENCES project(pnumber),
  hours      integer,
  CONSTRAINT ssn_pno PRIMARY KEY(ssn, pno)
);

/* Insert sample data into department, dept_location and employee */

/*
 * Departments
 */
INSERT INTO department 
(dname, dnumber, mgrssn, mgrstartdate) VALUES
('Information Technology', 1000, 20765,	'01/01/07');

INSERT INTO department 
(dname, dnumber, mgrssn, mgrstartdate) VALUES
('Administration', 1001, 20915, '29/02/04');

INSERT INTO department 
(dname, dnumber, mgrssn, mgrstartdate) VALUES
('Finance', 1007, 21287, '07/06/05');

/*
 * Department locations 
 */
INSERT INTO dept_location 
(dnumber,dlocation) VALUES 
(1000,'Canberra');

INSERT INTO dept_location 
(dnumber,dlocation) VALUES 
(1000,'Sydney');

INSERT INTO dept_location 
(dnumber,dlocation) VALUES 
(1001,'Canberra');

INSERT INTO dept_location 
(dnumber,dlocation) VALUES 
(1007,'Canberra');

INSERT INTO dept_location 
(dnumber,dlocation) VALUES 
(1007,'Sydney');


/*
 * Employees without a middle initial
 */
INSERT INTO employee 
(fname, lname, ssn, bdate, address, sex, salary, superssn, dno) VALUES 
('Michio',	'Morishima',	20118,	'18/07/1973',	'79 Macpherson St, Turner',	
    'M',	52107,	21286,	1000);
INSERT INTO employee 
(fname, lname, ssn, bdate, address, sex, salary, superssn, dno) VALUES 
('John',	'Backus',	20766,	'03/12/1984',	'25 Burns St, Yarralumla',	
    'M',	46789,	21287,	1007);
INSERT INTO employee 
(fname, lname, ssn, bdate, address, sex, salary, superssn, dno) VALUES 
('Gramsci',	'Antonio',	20876,	'22/01/1991',	'27 Garibaldi St, Ashfield, NSW',	
    'M',	71569,	20915,	1001);
INSERT INTO employee 
(fname, lname, ssn, bdate, address, sex, salary, superssn, dno) VALUES 
('Ada',		'Lovelace',	21286,	'10/12/1985',	'17 Ainslie Ave, Reid, ACT',	
    'F',	62107,	21286,	1000);
INSERT INTO employee 
(fname, lname, ssn, bdate, address, sex, salary, superssn, dno) VALUES 
('Milton',	'Friedman',	29057,	'31/07/1972',	'75 Wakefield Ave, Ainslie',	
    'M',	37764,	21287,	1007);

/*
 * Employees with a middle initial
 */
INSERT INTO employee 
(fname, minit, lname, ssn, bdate, address, sex, salary, superssn, dno) VALUES 
('Edsger',	'W',	'Dijkstra',	20765,	'11/05/1980',	
  '192 Wattle St, O''Connor ACT',	'M',	
  73567,	20766,	1000);
INSERT INTO employee 
(fname, minit, lname, ssn, bdate, address, sex, salary, superssn, dno) VALUES 
('Grace',	'M',	'Hopper',	20864,	'09/12/1976',	
  '45 Cobol St, Parramatta, NSW',	'F',	
  78563,	21286,	1000);
INSERT INTO employee 
(fname, minit, lname, ssn, bdate, address, sex, salary, superssn, dno) VALUES 
('Frederick',	'W',	'Taylor',	20915,	'20/03/1986',	
  '14 Blackett St, Downer, ACT',	'M',	
  56098,	20915,	1001);
INSERT INTO employee 
(fname, minit, lname, ssn, bdate, address, sex, salary, superssn, dno) VALUES 
('John',	'M',	'Keynes',	21287,	'05/06/1983',	
  '94 Earle St, Lyneham, ACT',	'M',	
  73567,	21287,	1007);


/* 
 * Projects
 */
INSERT INTO project 
(pname,pnumber,plocation,dnum) VALUES
('Difference Engine',	9000,	'Canberra',	1000);

INSERT INTO project 
(pname,pnumber,plocation,dnum) VALUES
('Red tape is Fun',	9001,	'Canberra',	1001);

INSERT INTO project 
(pname,pnumber,plocation,dnum) VALUES
('Object Oriented COBOL',	9002,	'Sydney',	1000);

/*
 * Works_on
 */
INSERT INTO works_on 
(ssn, pno, hours) VALUES 
(20765, 9000, 100);

INSERT INTO works_on 
(ssn, pno, hours) VALUES 
(20765, 9001, 500);

INSERT INTO works_on 
(ssn, pno, hours) VALUES 
(20864, 9002, 50);

INSERT INTO works_on 
(ssn, pno, hours) VALUES 
(20915, 9000, 250);

