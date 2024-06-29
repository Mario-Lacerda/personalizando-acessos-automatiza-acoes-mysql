-- create database company;
use company;

CREATE TABLE employee(
	Fname varchar(15) not null,
    Minit char,
    Lname varchar(15) not null,
    Ssn char(9) not null, 
    Bdate date,
    Address varchar(30),
    Sex char,
    Salary decimal(10,2),
    Super_ssn char(9),
    Dno int not null,
    constraint pk_employee primary key (Ssn)
);

-- Qual o departamento com maior número de pessoas?
SELECT Dname, COUNT(*) AS NumOfEmployees
FROM employee JOIN departament ON employee.Dno = departament.Dnumber
GROUP BY Dname
ORDER BY NumOfEmployees DESC
LIMIT 1;

create table departament(
	Dname varchar(15) not null,
    Dnumber int not null,
    Mgr_ssn char(9) not null,
    Mgr_start_date date, 
    Dept_create_date date,
    constraint chk_dept_date check (Dnumber <> 0),
    constraint pk_dept primary key (Dnumber),
    constraint unique_name_dept unique(Dname),
    constraint fk_dept foreign key (Mgr_ssn) references employee(Ssn)
);

create table dept_locations(
	Dnumber int not null,
	Dlocation varchar(15) not null,
    constraint pk_dept_locations primary key (Dnumber, Dlocation),
    constraint fk_dept_locations foreign key (Dnumber) references departament (Dnumber)
);

 create table project(
	Pname varchar(15) not null,
	Pnumber int not null,
    Plocation varchar(15),
    Dnum int not null,
    constraint pk_project primary key (Pnumber),
    constraint unique_name_project unique (Pname),
    constraint fk_project foreign key (Dnum) references departament(Dnumber)
);

create table works_on(
	Essn char(9) not null,
    Pno int not null,
    Hours decimal(3,1) not null,
    primary key (Essn, Pno),
    constraint fk_works_on foreign key (Essn) references employee(Ssn),
    foreign key (Pno) references project(Pnumber)
);

create table dependent(
	Essn char(9) not null,
    dependent_name varchar(255) not null,
    Sex char,
    Bdate date,
    Age int,
    Relationship varchar(8),
    -- constraint chk_age_dependent check (Age < 21),
    constraint pk_dependent primary key(Essn, dependent_name),
    constraint fk_dependent foreign key (Essn) references employee(Ssn)
);

-- Inserindo registros na tabela employee
INSERT INTO employee VALUES ('João', 'B', 'Santos', '123456789', '1965-01-09', '731 Marambaia, Belém, PA', 'M', 30000.00, '333445555', 5);
INSERT INTO employee VALUES ('Francisco', 'T', 'Wilson', '333445555', '1955-12-08', '638 Vila Velha, Corrente, PI', 'M', 40000.00, '888665555', 5);
INSERT INTO employee VALUES ('Joyce', 'A', 'Silva', '453453453', '1972-07-31', '5631 São Brás, Belém, PA', 'F', 25000.00, '333445555', 5);
INSERT INTO employee VALUES ('Ramon', 'K', 'Nonato', '666884444', '1962-09-15', '975 Taguatiga, Braília, DF', 'M', 38000.00, '333445555', 5);
INSERT INTO employee VALUES ('Jonas', 'E', 'Borges', '888665555', '1937-11-10', '450 Nazaré, Belém, PA', 'M', 55000.00, NULL, 1);

-- Inserindo registros na tabela departament
INSERT INTO departament VALUES ('Pesquisa', 5, '333445555', '1988-05-22', '1988-05-22');
INSERT INTO departament VALUES ('Administração', 4, '987654321', '1995-01-01', '1995-01-01');
INSERT INTO departament VALUES ('Gestão', 1, '888665555', '1981-06-19', '1981-06-19');
INSERT INTO departament VALUES ('Desenvolvimento', 2, '123456789', '2001-02-03', '2001-02-03');
INSERT INTO departament VALUES ('Infraestrutura', 3, '453453453', '2003-04-05', '2003-04-05');

-- Inserindo registros na tabela dept_locations
INSERT INTO dept_locations VALUES (1, 'Belém');
INSERT INTO dept_locations VALUES (1, 'Bahia');
INSERT INTO dept_locations VALUES (5, 'Brasília');
INSERT INTO dept_locations VALUES (5, 'Corrente');
INSERT INTO dept_locations VALUES (5, 'Belém');

-- Inserindo registros na tabela project
INSERT INTO project VALUES ('ProdutoX', 1, 'Corrente', 5);
INSERT INTO project VALUES ('ProdutoY', 2, 'Bahia', 5);
INSERT INTO project VALUES ('ProdutoZ', 3, 'Belém', 5);
INSERT INTO project VALUES ('Computação', 10, 'Brasília', 5);
INSERT INTO project VALUES ('Reorganização', 20, 'Belém', 1);

-- Inserindo registros na tabela works_on
INSERT INTO works_on VALUES ('123456789', 1, 32.5);
INSERT INTO works_on VALUES ('123456789', 2, 7.5);
INSERT INTO works_on VALUES ('666884444', 3, 40.0);
INSERT INTO works_on VALUES ('453453453', 1, 20.0);
INSERT INTO works_on VALUES ('453453453', 2, 20.0);

-- Inserindo registros na tabela dependent
INSERT INTO dependent VALUES ('333445555', 'Aline', 'F', '1986-04-05', 19, 'Filha');
INSERT INTO dependent VALUES ('333445555', 'Emanoel', 'M', '1983-10-25', 21, 'Filho');
INSERT INTO dependent VALUES ('333445555', 'Joana', 'F', '1958-05-03', 57, 'Cônjuge');
INSERT INTO dependent VALUES ('333445555', 'Antonio', 'M', '1942-02-28', 82, 'Cônjuge');
INSERT INTO dependent VALUES ('123456789', 'Michel', 'M', '1988-01-04', 37, 'Filho');


-- Número de empregados por departamento e localidade
CREATE VIEW EmpregadosPorDepartamentoELocalidade AS
SELECT Dname, Dlocation, COUNT(*) AS NumOfEmployees
FROM employee JOIN departament ON employee.Dno = departament.Dnumber
JOIN dept_locations ON departament.Dnumber = dept_locations.Dnumber
GROUP BY Dname, Dlocation;

-- Lista de departamentos e seus gerentes
CREATE VIEW DepartamentosEGerentes AS
SELECT Dname, Mgr_ssn
FROM departament;

-- Projetos com maior número de empregados (por ordenação desc)
CREATE VIEW ProjetosComMaisEmpregados AS
SELECT Pname, COUNT(*) AS NumOfEmployees
FROM works_on JOIN project ON works_on.Pno = project.Pnumber
GROUP BY Pname
ORDER BY NumOfEmployees DESC;

-- Lista de projetos, departamentos e gerentes
CREATE VIEW ProjetosDepartamentosEGerentes AS
SELECT Pname, Dname, Mgr_ssn
FROM project JOIN departament ON project.Dnum = departament.Dnumber;

-- Quais empregados possuem dependentes e se são gerentes
CREATE VIEW EmpregadosComDependentes AS
SELECT employee.Ssn, COUNT(*) AS NumOfDependents, CASE WHEN departament.Mgr_ssn = employee.Ssn THEN 'Sim' ELSE 'Não' END AS IsManager
FROM employee LEFT JOIN dependent ON employee.Ssn = dependent.Essn
LEFT JOIN departament ON employee.Ssn = departament.Mgr_ssn
GROUP BY employee.Ssn;

-- Criando os usuários
CREATE USER gerente IDENTIFIED BY '123';
CREATE USER employee IDENTIFIED BY '456';

-- Definindo as permissões de acesso às tabelas
GRANT SELECT, INSERT, UPDATE, DELETE ON employee TO gerente;
GRANT SELECT, INSERT, UPDATE, DELETE ON departament TO gerente;
GRANT SELECT ON employee TO employee;

-- Definindo as permissões de acesso às views
GRANT SELECT ON EmpregadosPorDepartamentoELocalidade TO gerente;
GRANT SELECT ON DepartamentosEGerentes TO gerente;
GRANT SELECT ON ProjetosComMaisEmpregados TO gerente;
GRANT SELECT ON ProjetosDepartamentosEGerentes TO gerente;
GRANT SELECT ON EmpregadosComDependentes TO gerente;

REVOKE SELECT ON DepartamentosEGerentes FROM gerente;
REVOKE SELECT ON ProjetosDepartamentosEGerentes FROM gerente;



-- Qual o departamento com maior número de pessoas?
SELECT Dname, COUNT(*) AS NumOfEmployees
FROM employee JOIN departament ON employee.Dno = departament.Dnumber
GROUP BY Dname
ORDER BY NumOfEmployees DESC
LIMIT 1;

-- Quais são os departamentos por cidade?
SELECT Dname, Dlocation
FROM departament JOIN dept_locations ON departament.Dnumber = dept_locations.Dnumber;

-- Relação de empregados por departamento
SELECT Dname, COUNT(*) AS NumOfEmployees
FROM employee JOIN departament ON employee.Dno = departament.Dnumber
GROUP BY Dname;

-- Índice para a coluna Dno na tabela employee
CREATE INDEX idx_employee_Dno ON employee(Dno);

-- Índice para a coluna Dnumber na tabela departament
CREATE INDEX idx_departament_Dnumber ON departament(Dnumber);

-- Índice para a coluna Dnumber na tabela dept_locations
CREATE INDEX idx_dept_locations_Dnumber ON dept_locations(Dnumber);

-- Trigger de Atualização
DELIMITER //
CREATE TRIGGER before_update_employee
BEFORE UPDATE ON employee
FOR EACH ROW
BEGIN
    IF NEW.Salary < 1000 OR NEW.Salary > 10000 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O salário deve estar entre 1000 e 10000';
    END IF;
END; //
DELIMITER ;

-- show tables;