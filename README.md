# Desafio Dio - Personalizando Acessos e Automatizando ações no MySQL



Neste projeto, vamos personalizar os acessos e automatizar ações no banco de dados MySQL usando triggers e procedimentos armazenados.



### **Pré-requisitos**

- MySQL ou outro sistema de gerenciamento de banco de dados

- Conhecimento básico de SQL

  

  ### Criando Triggers

Os triggers são procedimentos que são executados automaticamente quando certos eventos ocorrem no banco de dados. Vamos criar um trigger para registrar quando um novo usuário for criado:

sql



```sql
CREATE TRIGGER novo_usuario_criado AFTER INSERT ON usuarios
FOR EACH ROW
BEGIN
    INSERT INTO log (usuario_id, data_hora) VALUES (NEW.id, NOW());
END;
```



### **Criando Procedimentos Armazenados**



Os procedimentos armazenados são funções armazenadas no banco de dados que podem ser chamadas para executar tarefas específicas. Vamos criar um procedimento para conceder permissões a um novo usuário:

sql



```sql
CREATE PROCEDURE conceder_permissoes(IN usuario_id INT)
BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON tarefas TO usuario_id;
END;
```



### **Exemplo de Uso**

Aqui está um exemplo de como usar os triggers e procedimentos armazenados que criamos:

sql



```sql
-- Inserir um novo usuário
INSERT INTO usuarios (nome, email) VALUES ('João', 'joao@exemplo.com');

-- Chamar o procedimento para conceder permissões ao novo usuário
CALL conceder_permissoes(LAST_INSERT_ID());

-- Verificar o log de novos usuários criados
SELECT * FROM log;
```



definiremos permissões de acesso às views de acordo com o tipo de conta de usuário. Lembre-se de que as views são armazenadas no banco de dados como "tabelas", permitindo que definamos permissões de acesso específicas a esses itens.

Para ilustrar, vamos criar um usuário chamado "gerente" que terá acesso às informações de empregados e departamentos. No entanto, os empregados não terão acesso às informações relacionadas aos departamentos ou gerentes.



Exemplo de criação de usuário e definição de permissões:



```
-- Criação do usuário "gerente"
CREATE USER 'gerente'@'localhost' IDENTIFIED BY 'senha_gerente';

-- Concedendo permissões para visualizar as views de empregados e departamentos
GRANT SELECT ON nome_do_banco_de_dados.view_empregados TO 'gerente'@'localhost';
GRANT SELECT ON nome_do_banco_de_dados.view_departamentos TO 'gerente'@'localhost';
```



Lembre-se de adaptar o código acima ao seu ambiente específico e ao nome do banco de dados que você está utilizando.

------

## Criando Gatilhos para Cenário de E-Commerce



### Objetivo



A criação de triggers está associada a ações que podem ser executadas antes ou depois da inserção ou atualização de dados. Além disso, em casos de remoção, também podemos utilizar triggers. Vamos criar as seguintes triggers para o cenário de e-commerce:



1. **Triggers de Remoção (Before Delete)**
   - Essas triggers serão acionadas antes da remoção de registros.
   - 
2. **Triggers de Atualização (Before Update)**
   - Essas triggers serão acionadas antes da atualização de registros.



### Exemplo de Trigger para Base



```
-- Trigger para remoção (before delete)
DELIMITER //
CREATE TRIGGER before_delete_usuario
BEFORE DELETE ON usuarios
FOR EACH ROW
BEGIN
    -- Realize as ações necessárias antes da remoção do usuário
    -- Por exemplo, fazer backup dos dados ou registrar a exclusão
END;
//
DELIMITER ;

-- Trigger para atualização (before update)
DELIMITER //
CREATE TRIGGER before_update_colaborador
BEFORE UPDATE ON colaboradores
FOR EACH ROW
BEGIN
    -- Realize as ações necessárias antes da atualização do colaborador
    -- Por exemplo, verificar se o salário está dentro de limites aceitáveis
END;
//
DELIMITER ;
```









### **Conclusão**

Neste projeto, criamos triggers e procedimentos armazenados para personalizar acessos e automatizar ações no banco de dados MySQL. Isso melhorou a segurança e a eficiência do banco de dados. Você pode personalizar ainda mais o banco de dados para atender às suas necessidades específicas.
