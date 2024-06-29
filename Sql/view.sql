											-- Conectando ao Banco de Dados Company
show databases;
use company;
show tables;

----------------------------------------------------------------------------------------------------------------------------------------------------

														-- Criando VIEWS

# 1- Número de empregados por departamento e localidade 
create view Localidade_View as
	select l.Dlocation, count(*) from Departament d
		inner join Dep_locations l on l.Dnumber = d.Dnumber
		inner join Employee e on e.Dno = d.Dnumber
		group by l.Dlocation;

select * from Localidade_View;

# 2- Lista de departamentos e seus gerentes 
create view Gerentes_View as
	select concat(e.Fname,' ',e.Fname) as Nome_Completo, e.Ssn, d.Dname from Employee e
		inner join Departament d on e.Ssn = d.Mgr_ssn
		order by e.Fname;

select * from Gerentes_View;

# 3- Projetos com maior número de empregados (ex: por ordenação desc) 
create view Projetos_View as
	select p.Pname as Nome_Projeto, count(*) as Quantidade_Funcionarios, p.Pnumber as Numero_Projeto from Project p
		inner join Works_on w on p.Pnumber = w.Pno
		inner join Employee e on e.Ssn = w.Essn
		group by p.Pname
        order by count(*) desc;

select * from Projetos_View;

# 4- Lista de projetos, departamentos e gerentes 
create view PDG_View as
	select p.Pname as Nomes_Projetos, d.Dname as Nomes_Departamentos, d.Mgr_ssn as Ssn_Gerentes, e.Fname as Nomes_Gerentes from Project p
		inner join Departament d on d.Dnumber = p.Dnum
		inner join Employee e on e.Ssn = d.Mgr_ssn;

select * from PDG_View;

# 5- Quais empregados possuem dependentes e se são gerentes 
create view Dependentes_View as
	select concat(e.Fname,' ',e.Lname) as Nome_Gerente, x.Dependent_name from Employee e
		inner join Dependent x on x.Essn = e.Ssn
		inner join Departament d on d.Mgr_ssn = e.Ssn;

select * from Dependentes_View;

----------------------------------------------------------------------------------------------------------------------------------------------------

											-- Criando Usuário para acessar View

create user 'usuarioFulano'@localhost identified by '111111111';					-- criando usuário
grant all privileges on Company.Localidade_View to 'usuarioFulano'@localhost;		-- liberando acesso da viwe para o usuário acima

SELECT user, host FROM mysql.user;

SELECT TABLE_SCHEMA, TABLE_NAME
FROM information_schema.TABLE_PRIVILEGES
WHERE TABLE_SCHEMA = 'Company' 
AND TABLE_NAME = 'Localidade_View' 
AND GRANTEE = "'usuarioFulano'@'localhost'";