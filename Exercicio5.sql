USE master

CREATE DATABASE Exercicio5
USE Exercicio5

CREATE TABLE Cliente(					
Codigo				INT				NOT NULL,	
Nome				VARCHAR(50)		NOT NULL,
Logradouro			VARCHAR(30)		NOT NULL,
Numero				INT				NOT NULL,
Telefone			CHAR(08)		NOT NULL,
Data_Nasc			DATE			NOT NULL
PRIMARY KEY	(Codigo)
)
GO

INSERT INTO Cliente VALUES
(33601,	'Maria Clara',	'R. 1� de Abril',			870,	'96325874',	'2000-08-15'),
(33602,	'Alberto Souza',	'R. XV de Novembro',	987,	'95873625',	'1985-02-02'),
(33603,	'Sonia Silva',	'R. Volunt�rios da P�tria',	1151,	'75418596',	'1957-08-23'),
(33604,	'Jos� Sobrinho',	'Av. Paulista',			250,	'85236547',	'1986-12-09'),
(33605,	'Carlos Camargo',	'Av. Tiquatira',		9652,	'75896325',	'1971-03-25')

SELECT * FROM Cliente

CREATE TABLE Fornecedores(
Codigo			INT			NOT NULL,
Nome			VARCHAR(50) NOT NULL,
Atividade		VARCHAR(30) NOT NULL,
Telefone		CHAR(08)	NOT NULL,
PRIMARY KEY (Codigo)
)
GO

INSERT INTO Fornecedores VALUES
(1001,	'Estrela',		'Brinquedo',				'41525898'),
(1002,	'Lacta',		'Chocolate',				'42698596'),
(1003,	'Asus',			'Inform�tica',				'52014596'),
(1004,	'Tramontina',	'Utens�lios Dom�sticos',	'50563985'),
(1005,	'Grow',			'Brinquedos',				'47896325'),
(1006,	'Mattel',		'Bonecos',					'59865898')

CREATE TABLE Produto(
Codigo				INT				NOT NULL,	
Nome				VARCHAR(50)		NOT NULL,
Valor_Unit�rio		DECIMAL(7,2)	NOT NULL,
Quantidade_Estoque	INT				NOT NULL,
Descri��o			VARCHAR(30)		NOT NULL,
Codigo_Fornecedor	INT				NOT NULL
PRIMARY KEY (Codigo)
FOREIGN kEY (Codigo_Fornecedor) REFERENCES Fornecedores(Codigo)
)
GO

INSERT INTO Produto VALUES
(1,	'Banco Imobili�rio',		65.00,	15,	'Vers�o Super Luxo',	1001),
(2,	'Puzzle 5000 pe�as',		50.00,	5,	'Mapas Mundo',	1005),
(3,	'Faqueiro',					350.00,	0,	'120 pe�as',	1004),
(4,	'Jogo para churrasco',		75.00,	3,	'7 pe�as',	1004),
(5,	'Tablet',					750.00,	29,	'Tablet',	1003),
(6,	'Detetive',					49.00,	0,	'Nova Vers�o do Jogo',	1001),
(7,	'Chocolate com Pa�oquinha',	6.00,	0,	'Barra',	1002),
(8,	'Galak',					5.00,	65,	'Barra',	1002)

SELECT * FROM Produto

CREATE TABLE Pedido (				
Codigo				INT		NOT NULL,
Codigo_Cliente		INT		NOT NULL,
Codigo_Produto		INT		NOT NULL,
Quantidade			INT		NOT NULL,
Previs�o_Entrega	DATE	NOT NULL
PRIMARY KEY (Codigo,Codigo_Cliente,Codigo_Produto)
FOREIGN KEY (Codigo_Cliente) REFERENCES Cliente(Codigo),
FOREIGN KEY (Codigo_Produto) REFERENCES Produto(Codigo)	
)
GO

INSERT INTO Pedido VALUES
(99001,	33601,	1,	1,	'2012-06-07'),
(99001,	33601,	2,	1,	'2012-06-07'),
(99001,	33601,	8,	3,	'2012-06-07'),
(99002,	33602,	2,	1,	'2012-06-09'),
(99002,	33602,	4,	3,	'2012-06-09'),
(99003,	33605,	5,	1,	'2012-06-15')

SELECT * FROM Pedido


SELECT
    prod.Codigo AS CodigoProduto,
    prod.Nome AS NomeProduto,
    ped.Quantidade,
    ped.Quantidade * prod.Valor_Unit�rio AS ValorTotal,
    ped.Quantidade * prod.Valor_Unit�rio * 0.75 AS ValorTotalComDesconto
FROM 
    Produto prod,
    Pedido ped,
    Cliente cli
WHERE 
    ped.Codigo_Produto = prod.Codigo
    AND ped.Codigo_Cliente = cli.Codigo
    AND cli.Nome = 'Maria Clara';


-- Verificar quais brinquedos n�o tem itens em estoque.				
SELECT 
 Nome,
 Quantidade_Estoque 
FROM Produto
 WHERE Quantidade_Estoque = 0

--Alterar para reduzir em 10% o valor das barras de chocolate.				
UPDATE Produto SET Valor_Unit�rio = Valor_Unit�rio * 0.9 WHERE Descri��o LIKE 'Barra'

SELECT * FROM Produto 


--Alterar a quantidade em estoque do faqueiro para 10 pe�as.	
UPDATE Produto SET Quantidade_Estoque = 10 WHERE Nome = 'Faqueiro'

/*
Consultar quantos clientes tem mais de 40 anos.				
*/
SELECT 
 Nome
FROM Cliente
 WHERE DATEDIFF(YEAR,Data_Nasc,GETDATE()) > 40

--Consultar Nome e telefone dos fornecedores de Brinquedos e Chocolate.	
SELECT 
 Nome,
 Telefone
 FROM Fornecedores
  WHERE Atividade = 'Brinquedo' OR Atividade ='Chocolate'

--Consultar nome e desconto de 25% no pre�o dos produtos que custam menos de R$50,00
 SELECT 
  Nome,
  Valor_Unit�rio,
  'R$ ' + CAST(CAST(Valor_Unit�rio * 0.75 AS DECIMAL(7,2)) AS VARCHAR(8)) AS "Novo Valor"
  --'R$' + CONVERT(VARCHAR,Valor_Unit�rio *0.75)  AS "Valor com Desconto 25%"
 FROM Produto
  WHERE Valor_Unit�rio < 50.00

--Consultar nome e aumento de 10% no pre�o dos produtos que custam mais de R$100,00				
 SELECT
  Nome,
  Valor_Unit�rio,
  'R$ ' + CAST(CAST(Valor_Unit�rio * 1.1 AS DECIMAL(7,2)) AS VARCHAR(8)) AS "Novo Valor"
  FROM Produto 
   WHERE Valor_Unit�rio > 100.00

-- Consultar desconto de 15% no valor total de cada produto da venda 99001 usando subconsulta.
SELECT
    P.Codigo AS CodigoProduto,
    P.Nome AS NomeProduto,
    P.Valor_Unit�rio AS ValorUnitario,
    (SELECT Quantidade FROM Pedido WHERE Codigo_Produto = P.Codigo AND Codigo = 99001) AS Quantidade,
    (SELECT Quantidade * Valor_Unit�rio * 0.85 FROM Pedido WHERE Codigo_Produto = P.Codigo AND Codigo = 99001) AS ValorTotalComDesconto
FROM 
    Produto P
WHERE 
    P.Codigo IN (
        SELECT Codigo_Produto
        FROM Pedido
        WHERE Codigo = 99001
    );
--Consultar C�digo do pedido, nome do cliente e idade atual do cliente	
SELECT
    ped.Codigo AS CodigoPedido,
    cli.Nome AS NomeCliente,
    DATEDIFF(YEAR, cli.Data_Nasc, GETDATE()) AS IdadeAtual
FROM 
    Pedido ped,
    Cliente cli
WHERE 
    ped.Codigo_Cliente = cli.Codigo;



