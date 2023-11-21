
USE master
DROP DATABASE Exercicio4 

USE master
CREATE DATABASE Exercicio4

USE Exercicio4

CREATE TABLE Cliente(
CPF			CHAR(12)		NOT NULL,	
Nome	    VARCHAR(50)		NOT NULL,
Telefone	CHAR(09)		NOT NULL,	
PRIMARY KEY (CPF)
)
GO
SELECT * FROM Cliente

INSERT INTO Cliente VALUES
('345789092-90',	'Julio Cesar',		'8273-6541'),
('251865337-10',	'Maria Antonia',	'8765-2314'),
('876273154-16',	'Luiz Carlos',		'6128-9012'),
('791826398-00',	'Paulo Cesar',		'9076-5273')


CREATE TABLE Fornecedor (
ID				INT				NOT NULL,
Nome			VARCHAR(50)		NOT NULL,
Logradouro		VARCHAR(50)		NOT NULL,
Numero			INT				NOT NULL,	
Complemento		VARCHAR(50)		NOT NULL,
Cidade			VARCHAR(30)		NOT NULL
PRIMARY KEY (ID)
)
GO

INSERT INTO Fornecedor VALUES
(1,	'LG',			'Rod. Bandeirantes',	70000,	'Km 70',	'Itapeva'),
(2,	'Asus',			'Av. Nações Unidas',	10206,	'Sala 225',	'São Paulo'),
(3,	'AMD',			'Av. Nações Unidas',	10206,	'Sala 1095',	'São Paulo'),
(4,	'Leadership',	'Av. Nações Unidas',	10206,	'Sala 87',	'São Paulo'),	
(5,	'Inno',			'Av. Nações Unidas',	10206,	'Sala 34',	'São Paulo')

CREATE TABLE Produto(			
Codigo				INT			NOT NULL,	
Descricao			VARCHAR(50)	NOT NULL,
Fornecedor			INT			NOT NULL,
Preco				DECIMAL(7,2)NOT NULL
PRIMARY KEY (Codigo)
FOREIGN KEY (Fornecedor) REFERENCES Fornecedor(ID)
)
GO

INSERT INTO Produto VALUES
(1,	'Monitor 19 pol.',										1,	449.99),
(2,	'Netbook 1GB Ram 4 Gb HD',								2,	699.99),
(3,	'Gravador de DVD - Sata',								1,	99.99),
(4,	'Leitor de CD',											1,	49.99),
(5,	'Processador - Phenom X3 - 2.1GHz',						3,	349.99),
(6,	'Mouse',												4,	19.99),
(7,	'Teclado',												4,	25.99),
(8,	'Placa de Video - Nvidia 9800 GTX - 256MB/256 bits',	5,	599.99)

CREATE TABLE Venda (
Codigo			INT		     NOT NULL,	
Produto			INT		     NOT NULL,
Cliente			CHAR(12)     NOT NULL,
Quantidade		INT		     NOT NULL,	
Valor_Total		DECIMAL(7,2) NOT NULL,
Data_Venda		DATE		 NOT NULL
PRIMARY KEY (Codigo, Produto, Cliente)
FOREIGN KEY (Produto) REFERENCES Produto(Codigo),
FOREIGN KEY (Cliente) REFERENCES Cliente(CPF)
)
GO

INSERT INTO Venda VALUES
(1,	1,	'251865337-10',	1,	449.99,	'2009-09-03'),
(1,	4,	'251865337-10',	1,	49.99,	'2009-09-03'),
(1,	5,	'251865337-10',	1,	349.99,	'2009-09-03'),
(2,	6,	'791826398-00',	4,	79.96,	'2009-09-06'),
(3,	8,	'876273154-16',	1,	599.99,	'2009-09-06'),
(3,	3,	'876273154-16',	1,	99.99,	'2009-09-06'),
(3,	7,	'876273154-16',	1,	25.99,	'2009-09-06'),
(4,	2,	'345789092-90',	2,	1399.98,'2009-09-08')

USE Exercicio4

--Consultar no formato dd/mm/aaaa:						
--Data da Venda 4		
SELECT 
CONVERT(CHAR(10),Data_Venda,103) AS "Data Formatada"
FROM Venda

--Inserir na tabela Fornecedor, a coluna Telefone e os seguintes dados:						
--1	7216-5371					
--2	8715-3738					
--4	3654-6289					
ALTER TABLE Fornecedor ADD Telefone CHAR(9)

UPDATE Fornecedor SET Telefone = '7216-5371' WHERE ID =1
UPDATE Fornecedor SET Telefone = '8715-3738' WHERE ID =2
UPDATE Fornecedor SET Telefone = '3654-6289' WHERE ID =4

SELECT * FROM Fornecedor

--Consultar por ordem alfabética de nome, o nome, o enderço concatenado e o telefone dos fornecedores						
SELECT
 Nome,
 Logradouro + ' N°' + CAST(Numero AS VARCHAR) + ' ' + Complemento AS "Endereço Complemento",
 Telefone
FROM Fornecedor
 ORDER BY Nome ASC

--Consultar:Produto, quantidade e valor total do comprado por Julio Cesar
SELECT 
 Quantidade,
 Valor_Total
FROM Venda,Produto  
 WHERE Cliente  IN (
  SELECT CPF 
   FROM Cliente
   WHERE Nome = 'Julio Cesar');

--Data, no formato dd/mm/aaaa e valor total do produto comprado por  Paulo Cesar						
 SELECT 
 CONVERT(CHAR(10),Data_Venda,103 ) AS "Data",
 'R$ ' + CAST(Valor_Total AS VARCHAR)
 FROM Venda
  WHERE Cliente IN (
   SELECT CPF
    FROM Cliente
	WHERE Nome LIKE 'Paulo Cesar'); 

--Consultar, em ordem decrescente, o nome e o preço de todos os produtos 
SELECT 
 Descricao,
 'R$ ' + CAST(Preco AS VARCHAR) AS Preço
FROM Produto
 ORDER BY Descricao DESC

