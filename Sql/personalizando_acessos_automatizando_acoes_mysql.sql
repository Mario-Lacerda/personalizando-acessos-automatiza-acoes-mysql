-- Parte 1 – Personalizando acessos com views

-- Criação das views
CREATE VIEW num_empregados_por_departamento AS
SELECT department_id, COUNT(employee_id) AS num_empregados
FROM employee
GROUP BY department_id;

CREATE VIEW lista_departamentos_gerentes AS
SELECT d.department_id, d.department_name, e.first_name, e.last_name AS gerente
FROM department d
JOIN employee e ON d.manager_id = e.employee_id;

CREATE VIEW projetos_maior_num_empregados AS
SELECT p.project_id, p.project_name, COUNT(ep.employee_id) AS num_empregados
FROM project p
JOIN employee_project ep ON p.project_id = ep.project_id
GROUP BY p.project_id
ORDER BY COUNT(ep.employee_id) DESC;

CREATE VIEW lista_projetos_departamentos_gerentes AS
SELECT p.project_id, p.project_name, d.department_name, e.first_name, e.last_name AS gerente
FROM project p
JOIN department d ON p.department_id = d.department_id
JOIN employee e ON d.manager_id = e.employee_id;

CREATE VIEW empregados_com_dependentes_gerentes AS
SELECT e.first_name, e.last_name, CASE WHEN e.manager_id IS NOT NULL THEN 'Sim' ELSE 'Não' END AS possui_dependentes, CASE WHEN e.manager_id IS NOT NULL THEN 'Sim' ELSE 'Não' END AS e_gerente
FROM employee e
LEFT JOIN dependent d ON e.employee_id = d.employee_id;

-- Permissões de acesso às views
GRANT SELECT ON num_empregados_por_departamento TO gerente@localhost;
GRANT SELECT ON lista_departamentos_gerentes TO gerente@localhost;
GRANT SELECT ON projetos_maior_num_empregados TO gerente@localhost;
GRANT SELECT ON lista_projetos_departamentos_gerentes TO gerente@localhost;
GRANT SELECT ON empregados_com_dependentes_gerentes TO gerente@localhost;

-- Parte 2 – Criando gatilhos para cenário de e-commerce

-- Trigger de remoção
CREATE TRIGGER before_delete_user
BEFORE DELETE ON users
FOR EACH ROW
BEGIN
    INSERT INTO deleted_users (user_id, username, deleted_at)
    VALUES (OLD.user_id, OLD.username, NOW());
END;

-- Trigger de atualização
CREATE TRIGGER before_update_employee_salary
BEFORE UPDATE ON employee
FOR EACH ROW
BEGIN
    -- Lógica para atualizar salário base
END;
