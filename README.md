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



### **Conclusão**

Neste projeto, criamos triggers e procedimentos armazenados para personalizar acessos e automatizar ações no banco de dados MySQL. Isso melhorou a segurança e a eficiência do banco de dados. Você pode personalizar ainda mais o banco de dados para atender às suas necessidades específicas.
