-- drop database ecommerce;
-- create database ecommerce;
use ecommerce;

-- tabela clientes
create table clients(
    idClients int auto_increment primary key,
    Fname varchar(50),
    Minit char(3),
    Lname varchar(50),
    CPF char(11),
    CNPJ char(14),
    birthDate date,
    Addres varchar(255),
    accountType enum('Pessoa Física', 'Pessoa Jurídica') not null,
    constraint unique_cpf_clients unique (CPF),
    constraint unique_cnpj_clients unique (CNPJ)
);

-- cadastro de clientes
create table register(
    idRegister int auto_increment primary key,
    idClients int,
    registerDate datetime default current_timestamp,
    constraint fk_register_clients foreign key (idClients) references clients(idClients)
);

-- tabela produto
create table product(
	idProduct int auto_increment primary key,
    Pname varchar(50) not null,
    classification_kids bool default false,
    category enum('Eletrônico','Vestimenta','Brinquedos','alimentos','Móveis') not null,
    avaliação float default 0,
    size varchar(10)
);

-- tabela forma de pagamento
create table payment(
	idClient int,
    idPayment int,
    typePayment enum('Boleto','Cartão','Dois cartões','Pix'),
    limitAvailable float,
    primary key(idClient, idPayment)
);

-- tabela pedido 
create table orders(
	idOrder int auto_increment primary key,
    idOrderclients int,
    orderStatus enum('Cancelado','Confirmado','Em processamento') default 'Em processamento',
    orderDescription varchar(255),
    sendValue float default 10,
    paymentCash bool default false,
    constraint fk_orders_clients foreign key (idOrderClients) references clients(idClients)
		on update cascade
);

-- tabela estoque
create table productStorage(
	idProdStorage int auto_increment primary key,
    storageLocation varchar(255), 
    Quantity int default 0,
    entryDate timestamp,
    exitDate timestamp
);

-- tabela fornecedor
create table supplier(
	idSupplier int auto_increment primary key,
    socialName varchar(255) not null, 
    CNPJ char(15) not null,
    contact char(11) not null,
	constraint unique_supplier unique (CNPJ)	
);

-- tabela produto/fornecedor
create table productSupplier(
	idPsSupplier int,
    idPsProduct int,
    quantity int not null, 
    primary key (idPsSupplier, idPsProduct),
    constraint fk_product_supplier_supplier foreign key(idPsSupplier) references supplier(idSupplier),
    constraint fk_product_supplier_product foreign key(idPsProduct) references product(idProduct)
);

-- tabela vendedor
create table seller(
	idSeller int auto_increment primary key,
    socialName varchar(255) not null,
    AbsName varchar(255),
    CNPJ char(15) not null,
    CPF char(11),
    location varchar(255),
    contact char(11) not null,
	constraint unique_cnpj_seller unique (CNPJ),
	constraint unique_cpf_seller unique (CPF)
);

-- tabela Produto/vendedor
create table productSeller(
	idPseller int,
    idPproduct int,
    prodQuantity int default 1,
    saleDate datetime,
    primary key (idPseller, idPproduct),
    constraint fk_product_seller foreign key(idPSeller) references seller(idSeller),
    constraint fk_product_product foreign key(idPproduct) references product(idProduct)
);

-- tabela produto/pedido
create table productOrder(
idPOproduct int,
idPOorder int,
poQuantity int default 1,
poStatus enum('Disponível','Sem estoque') default 'Disponível',
orderDate datetime,
primary key (idPOproduct, idPOorder),
constraint fk_productorder_seller foreign key (idPOproduct) references product(idProduct),
constraint fk_productorder_product foreign key (idPOorder) references orders(idOrder)
);

-- tabela produto/estoque
create table storageLocation(
idLproduct int,
idLstorage int,
location varchar(255) not null,
primary key (idLproduct, idLstorage),
constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idProdStorage)
);

-- Tabela de entrega
create table delivery(
    idDelivery int auto_increment primary key,
    idOrder int,
    deliveryAddress varchar(255) not null,
    deliveryStatus enum('Em trânsito', 'Entregue', 'Cancelado') default 'Em trânsito',
    trackingCode varchar(20),
    constraint fk_delivery_order foreign key (idOrder) references orders(idOrder)
);

-- Inserindo dados na tabela clients
update clients
set Lname = 'Wilson'
where idClients = 4;
INSERT INTO clients(Fname, Minit, Lname, CPF, CNPJ, birthDate, Addres, accountType) 
VALUES 
('João', 'A', 'Silva', '12345678901', NULL, '1980-01-01', 'Rua das Flores, 123', 'Pessoa Física'),
('Andréia', 'B', 'Martins', '23456789012', NULL, '1985-02-02', 'Rua das Orquídeas, 456', 'Pessoa Física'),
('Carlos', 'C', 'Oliveira', '34567890123', NULL, '1990-03-03', 'Avenida das Rosas, 789', 'Pessoa Física'),
('Kleber', 'D', 'Wilson', NULL, '4567890123456', NULL, 'Rua das Margaridas, 012', 'Pessoa Jurídica'),
('Júlia', 'E', 'Alamar', NULL, '5678901234567', NULL, 'Avenida das Tulipas, 345', 'Pessoa Jurídica');
select * from clients;
-- Inserindo dados na tabela register
INSERT INTO register(idClients) 
VALUES 
(1), (2), (3), (4), (5);

-- Inserindo dados na tabela product
INSERT INTO product(Pname, classification_kids, category, avaliação, size) 
VALUES 
('Camiseta', false, 'Vestimenta', 4.5, 'M'),
('Calça', false, 'Vestimenta', 4.0, 'G'),
('Boneca', true, 'Brinquedos', 4.8, NULL),
('TV', false, 'Eletrônico', 4.7, '42"'),
('Cadeira', false, 'Móveis', 4.3, NULL);

-- Inserindo dados na tabela payment
INSERT INTO payment(idClient, idPayment, typePayment, limitAvailable) 
VALUES 
(1, 1, 'Boleto', 1000.00),
(2, 2, 'Cartão', 2000.00),
(3, 3, 'Dois cartões', 3000.00),
(4, 4, 'Pix', 4000.00),
(5, 5, 'Boleto', 5000.00);

-- Inserindo dados na tabela orders
INSERT INTO orders(idOrderclients, orderDescription, sendValue, paymentCash) 
VALUES 
(1, 'Pedido de camiseta', 10, false),
(2, 'Pedido de calça', 20, false),
(3, 'Pedido de boneca', 30, true),
(4, 'Pedido de TV', 40, false),
(5, 'Pedido de cadeira', 50, true);

-- Inserindo dados na tabela productStorage
INSERT INTO productStorage(storageLocation, Quantity, entryDate, exitDate) 
VALUES 
('Armazém 1', 100, NOW(), NULL),
('Armazém 2', 200, NOW(), NULL),
('Armazém 3', 300, NOW(), NULL),
('Armazém 4', 400, NOW(), NULL),
('Armazém 5', 500, NOW(), NULL);

-- Inserindo dados na tabela supplier
INSERT INTO supplier(socialName, CNPJ, contact) 
VALUES 
('Fornecedor 1', '6789012345678', '11923456789'),
('Fornecedor 2', '7890123456789', '11934567890'),
('Fornecedor 3', '8901234567890', '11945678901'),
('Fornecedor 4', '9012345678901', '11956789012'),
('Fornecedor 5', '0123456789012', '11967890123');

-- Inserindo dados na tabela productSupplier
INSERT INTO productSupplier(idPsSupplier, idPsProduct, quantity) 
VALUES 
(1, 1, 50),
(2, 2, 100),
(3, 3, 150),
(4, 4, 200),
(5, 5, 250);

-- Inserindo dados na tabela seller
INSERT INTO seller(socialName, AbsName, CNPJ, CPF, location, contact) 
VALUES 
('Vendedor 1', 'Vend1', '1234567890123', NULL, 'Rua das Azaleias, 678', '11967890123'),
('Vendedor 2', 'Vend2', '2345678901234', NULL, 'Avenida das Violetas, 901', '11978901234'),
('Vendedor 3', 'Vend3', '3456789012345', NULL, 'Rua das Hortências, 234', '11989012345'),
('Vendedor 4', 'Vend4', '4567890123456', NULL, 'Avenida das Begônias, 567', '11990123456'),
('Vendedor 5', 'Vend5', '5678901234567', NULL, 'Rua das Dálias, 890', '11901234567');

-- Inserindo dados na tabela productSeller
INSERT INTO productSeller(idPseller, idPproduct, prodQuantity, saleDate) 
VALUES 
(1, 1, 10, NOW()), 
(2, 2, 20, NOW()),
(3, 3, 30, NOW()),
(4, 4, 40, NOW()),
(5, 5, 50, NOW());

-- Inserindo dados na tabela productOrder
INSERT INTO productOrder(idPOproduct, idPOorder, poQuantity, orderDate) 
VALUES 
(1, 1, 1, NOW()), 
(2, 2, 2, NOW()), 
(3, 3, 3, NOW()), 
(4, 4, 4, NOW()), 
(5, 5, 5, NOW());

-- Inserindo dados na tabela storageLocation
INSERT INTO storageLocation(idLproduct, idLstorage, location) 
VALUES 
(1, 1, 'Prateleira A1'), 
(2, 2, 'Prateleira B2'), 
(3, 3, 'Prateleira C3'), 
(4, 4, 'Prateleira D4'), 
(5, 5, 'Prateleira E5');

-- Inserindo dados na tabela delivery
INSERT INTO delivery(idOrder, deliveryAddress, trackingCode) 
VALUES 
(1, 'Rua das Flores, 123', 'BR123456789BR'),
(2, 'Rua das Orquídeas, 456', 'BR234567890BR'),
(3, 'Avenida das Rosas, 789', 'BR345678901BR'),
(4, 'Rua das Margaridas, 012', 'BR456789012BR'),
(5, 'Avenida das Tulipas, 345', 'BR567890123BR');

-- Recuperações simples com SELECT Statement
select * from clients;

-- Filtros com WHERE Statement
SELECT * FROM clients
WHERE accountType = 'Pessoa Física';

-- Expressões para gerar atributos derivados
SELECT idClients, CONCAT(Fname, ' ', Lname) AS FullName FROM clients;

-- Ordenação dos dados com ORDER BY
SELECT * FROM clients
ORDER BY Lname;

-- Condições de filtros aos grupos – HAVING Statement
SELECT accountType, COUNT(*) FROM clients
GROUP BY accountType
HAVING COUNT(*) > 1;

-- Junções entre tabelas
SELECT clients.Fname, clients.Lname, orders.orderDescription 
FROM clients 
JOIN orders ON clients.idClients = orders.idOrderclients;

-- Quantos pedidos foram feitos por cada cliente?
SELECT clients.idClients, COUNT(orders.idOrder) AS NumberOfOrders
FROM clients
JOIN orders ON clients.idClients = orders.idOrderclients
GROUP BY clients.idClients;

-- Algum vendedor também é fornecedor?
SELECT seller.idSeller
FROM seller
JOIN supplier ON seller.CNPJ = supplier.CNPJ;

-- Relação de produtos, fornecedores e estoques
SELECT product.idProduct, supplier.idSupplier, productStorage.idProdStorage
FROM productSupplier
JOIN product ON productSupplier.idPsProduct = product.idProduct
JOIN supplier ON productSupplier.idPsSupplier = supplier.idSupplier
JOIN storageLocation ON product.idProduct = storageLocation.idLproduct
JOIN productStorage ON storageLocation.idLstorage = productStorage.idProdStorage;

-- Relação de nomes dos fornecedores e nomes dos produtos
SELECT supplier.socialName, product.Pname
FROM productSupplier
JOIN product ON productSupplier.idPsProduct = product.idProduct
JOIN supplier ON productSupplier.idPsSupplier = supplier.idSupplier;

DELIMITER //
CREATE PROCEDURE ManageClients(IN op INT, IN id INT, IN Fname VARCHAR(10), IN Minit CHAR(3), IN Lname VARCHAR(20), IN CPF CHAR(11), IN Addres VARCHAR(30))
BEGIN
    CASE op
        WHEN 1 THEN -- Select
            SELECT * FROM clients WHERE idClient = id;
        WHEN 2 THEN -- Update
            UPDATE clients SET Fname = Fname, Minit = Minit, Lname = Lname, CPF = CPF, Addres = Addres WHERE idClient = id;
        WHEN 3 THEN -- Delete
            DELETE FROM clients WHERE idClient = id;
        WHEN 4 THEN -- Insert
            INSERT INTO clients(Fname, Minit, Lname, CPF, Addres) VALUES(Fname, Minit, Lname, CPF, Addres);
    END CASE;
END //
DELIMITER ;

CALL ManageClients(4, 1 ,'Antônio', 'A', 'Marques', '12345678999', 'Rio das Ostras,236');

-- Trigger de Remoção
DELIMITER //
CREATE TRIGGER before_delete_clients
BEFORE DELETE ON clients
FOR EACH ROW
BEGIN
    INSERT INTO clients_backup SELECT * FROM clients WHERE idClients = OLD.idClients;
END; //
DELIMITER ;

show databases;
show tables;

