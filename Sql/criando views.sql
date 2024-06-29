USE company;

CREATE USER 'manager'@localhost IDENTIFIED BY 'manager123';
CREATE USER 'manager2'@localhost IDENTIFIED BY 'manager123';
CREATE USER 'employee'@localhost IDENTIFIED BY 'employee123';

# Número de empregados por departamento e localidade 
CREATE OR REPLACE DEFINER = 'manager'@localhost VIEW employee_by_department_view AS
SELECT 
	d.Dnumber,
    d.Dname,
    dl.Dlocation,
    count(*) number_of_employees
FROM employee e
	INNER JOIN departament d ON e.Dno = d.Dnumber
    INNER JOIN dept_locations dl ON dl.Dnumber = d.Dnumber
    GROUP BY d.Dnumber;

SELECT * FROM employee_by_department_view;

# Lista de departamentos e seus gerentes
CREATE OR REPLACE DEFINER = 'manager2'@localhost VIEW department_managers_view AS
SELECT 
	d.Dnumber,
    d.Dname,
    concat(e.Fname, ' ', e.Lname) Mgr_name
FROM departament d
	INNER JOIN employee e ON e.ssn = d.Mgr_ssn;

SELECT * FROM department_managers_view;

# Projetos com maior número de empregados (ex: por ordenação desc) 
CREATE OR REPLACE DEFINER = 'employee'@localhost VIEW employees_by_project_view AS
SELECT 
	p.Pnumber, 
    p.Pname,
    count(*) employees
FROM project p
	INNER JOIN departament d ON p.Dnum = d.Dnumber
	INNER JOIN employee e ON e.Dno = d.Dnumber
    GROUP BY 1
    ORDER BY employees DESC;

SELECT * FROM employees_by_project_view;

# Lista de projetos, departamentos e gerentes 
CREATE OR REPLACE DEFINER = 'manager2'@localhost VIEW project_department_manager_view AS
SELECT 
	p.Pnumber, 
    p.Pname,
    D.Dnumber,
    D.Dname,
    concat(e.Fname, ' ', e.Lname) Mgr_name
FROM project p
	INNER JOIN departament d ON p.Dnum = d.Dnumber
	INNER JOIN employee e ON e.Ssn = d.Mgr_ssn;

SELECT * FROM project_department_manager_view;

# Quais empregados possuem dependentes e se são gerentes
CREATE OR REPLACE DEFINER = 'manager2'@localhost VIEW employee_and_managers_with_dependents_view AS
SELECT
	concat(e.Fname, ' ', e.Lname) emp_name,
	(case when e.ssn in (SELECT Mgr_ssn FROM departament) then 'yes' else 'no' end) is_manager
FROM employee e
	INNER JOIN dependent d ON e.Ssn = d.Essn;

SELECT * FROM employee_and_managers_with_dependents_view;
