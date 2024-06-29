USE ecommerce;
CREATE TABLE IF NOT EXISTS users_deleted_accounts (
			`UserId` int(11) NOT NULL,
			`Fname` varchar(45) NOT NULL,
			`InitMname` char(1) NOT NULL,
			`Lname` varchar(45) NOT NULL,
			`CPF` char(11) NOT NULL UNIQUE,
			`BirthDate` date NOT NULL,
			`Phone` varchar(15) NOT NULL UNIQUE,
            `exclusion_date` datetime default now(),
			PRIMARY KEY (`IdClientFP`)
);

# trigger que insere os usuario que excluiram sua conta na table de contas deletadas
delimiter //
CREATE TRIGGER before_remove_user_trigger
BEFORE DELETE ON ClientFP
FOR EACH ROW
	BEGIN
		INSERT INTO users_deleted_accounts
		VALUES (OLD.IdClientFP, OLD.Fname, OLD.InitMname, OLD.Lname, OLD.CPF, OLD.BirthDate, OLD.Phone, now());

	END
//
delimiter ;

DELETE FROM ClientFP WHERE IdClientFP = 5;
SELECT * FROM clientFP;
SELECT * FROM users_deleted_accounts;




USE company;

# trigger que determina salario de acordo com a soma de horas trabalhadas em projetos
delimiter //
CREATE TRIGGER update_employee_salary_before_update_works_on
AFTER UPDATE ON works_on
FOR EACH ROW
BEGIN
	-- Pegando o total de horas trabalhadas pelo funcionário
	SELECT sum(Hours) INTO @emp_worked_hours FROM employee e
		INNER JOIN works_on w ON w.Essn = e.ssn
		INNER JOIN project p ON p.Pnumber = w.Pno
    WHERE e.Ssn = NEW.Essn;
    
	IF (@emp_worked_hours > 10) THEN
		UPDATE employee SET salary = 35000 WHERE ssn = NEW.Essn;
	
    ELSEIF (@emp_worked_hours > 5) THEN
		UPDATE employee SET salary = 25000 WHERE ssn = NEW.Essn;
	
    ELSE
		UPDATE employee SET salary = 10000 WHERE ssn = NEW.Essn;
        
    END IF;
END
//
delimiter ;

select * from works_on;
set @ssn = '333446666';
select * from employee where ssn = @ssn;
update works_on set Hours = 5.1 where Essn = @ssn;
