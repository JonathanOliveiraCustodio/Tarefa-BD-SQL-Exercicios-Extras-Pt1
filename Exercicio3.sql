
USE master
DROP DATABASE Exercicio3 

USE master
CREATE DATABASE Exercicio3
USE Exercicio3 


CREATE TABLE Pacientes (
CPF				CHAR(11)	  NOT NULL,
Nome			VARCHAR(60)   NOT NULL,
Rua				VARCHAR(60)	  NOT NULL,	
Numero			INT			  NOT NULL,
Bairro			VARCHAR(60)	  NOT NULL,	
Telefone		CHAR(11)	  NULL,
Data_Nasc       DATE		  NOT NULL
PRIMARY KEY (CPF)
)
GO

INSERT INTO Pacientes VALUES
(35454562890,	'José Rubens',		'Campos Salles',		2750,	'Centro',		'21450998',	'1954-10-18'),
(29865439810,	'Ana Claudia',		'Sete de Setembro',		178,	'Centro',		'97382764',	'1960-05-29'),
(82176534800,	'Marcos Aurélio',	'Timóteo Penteado',		236,	'Vila Galvão',	'68172651',	'1980-09-24'),
(12386758770,	'Maria Rita',		'Castello Branco',		7765,	'Vila Rosália',	 NULL,		'1975-03-30'),
(92173458910,	'Joana de Souza',	'XV de Novembro',		298,	'Centro',		'21276578',	'1944-04-24')

CREATE TABLE Medico(		
Codigo			INT				NOT NULL,	
Nome			VARCHAR(50)		NOT NULL,
Especialidade	VARCHAR(50)		NOT NULL
PRIMARY KEY (Codigo)
)
GO

INSERT INTO Medico VALUES
(1,	'Wilson Cesar',	     'Pediatra'),
(2,	'Marcia Matos',	     'Geriatra'),
(3,	'Carolina Oliveira', 'Ortopedista'),
(4,	'Vinicius Araujo',    'Clínico Geral')


CREATE TABLE Prontuario (			
Data_Consulta			DATE		NOT NULL,	
CPF_Paciente			CHAR(11)	NOT NULL,				
Codigo_medico			INT			NOT NULL,
Diagnostico				VARCHAR(30)	NOT NULL,
Medicamento				VARCHAR(30) NOT NULL
PRIMARY KEY (Data_Consulta, CPF_Paciente,Codigo_medico)
FOREIGN KEY (CPF_Paciente)  REFERENCES Pacientes (CPF),
FOREIGN KEY (Codigo_medico) REFERENCES Medico (Codigo)
)
GO
INSERT INTO Prontuario VALUES 
('2020-09-10',	'35454562890',	2,	'Reumatismo',				'Celebra'),
('2020-09-10',	'92173458910',	2,	'Renite Alérgica',			'Allegra'),
('2020-09-12',	'29865439810',	1,	'Inflamação de garganta',	'Nimesulida'),
('2020-09-13',	'35454562890',	2,	'H1N1',						'Tamiflu'),
('2020-09-15',	'82176534800',	4,	'Gripe',					'Resprin'),
('2020-09-15',	'12386758770',	3,	'Braço Quebrado',			'Dorflex + Gesso')

SELECT * FROM Pacientes 
SELECT * FROM Medico
SELECT * FROM Prontuario
/*
Consultar:													
Nome e Endereço (concatenado) dos pacientes com mais de 50 anos													
*/
SELECT 
Nome, 
Rua + CAST(Numero AS VARCHAR) + Bairro 
FROM Pacientes
 WHERE DATEDIFF(YEAR, Data_Nasc, GETDATE()) > 50;

/*
Qual a especialidade de Carolina Oliveira													
*/
SELECT
  Nome,
  Especialidade
 FROM Medico
  WHERE Nome LIKE 'Carolina Oliveira'
/*
Qual medicamento receitado para reumatismo													
*/	
SELECT
 Diagnostico AS "Diagnóstico",
 Medicamento
FROM Prontuario
  WHERE Diagnostico LIKE 'reumatismo';												
/*
Consultar em subqueries:													
Diagnóstico e Medicamento do paciente José Rubens em suas consultas	
*/
SELECT
    Diagnostico,
	Medicamento
  
FROM Prontuario
WHERE CPF_Paciente IN
(
    SELECT CPF
    FROM Pacientes
    WHERE Nome LIKE 'José Rubens');

/*
Nome e especialidade do(s) Médico(s) que atenderam José Rubens. Caso a especialidade tenha mais de 3 letras, mostrar apenas as 3 primeiras letras concatenada com um ponto final (.)													
*/
SELECT 
Nome,
CASE
      WHEN LEN(Especialidade) > 3 THEN SUBSTRING(Especialidade, 1, 3) + '.'
        ELSE Especialidade
    END AS Especialidade
FROM Medico
 WHERE Codigo IN (
  SELECT Codigo_Medico 
   FROM Prontuario
    WHERE CPF_Paciente IN (
	 SELECT CPF
	  FROM Pacientes
	   WHERE Nome LIKE 'José Rubens'));
	

/*
CPF (Com a máscara XXX.XXX.XXX-XX), Nome, Endereço completo (Rua, nº - Bairro), Telefone (Caso nulo, mostrar um traço (-)) dos pacientes do médico Vinicius													
*/
SELECT 
 SUBSTRING(CPF,1,3) + '.' + SUBSTRING(CPF,4,3) + '.'+ SUBSTRING(CPF,7,3) + '-'+SUBSTRING(CPF,10,2),  
 Rua + ' ' +  CAST(Numero AS VARCHAR) + ' ' + Bairro AS "Enderelo Completo",
 CASE
      WHEN LEN(Telefone) IS NULL THEN  '(-)'
        ELSE Telefone
    END AS Telefone
FROM Pacientes 
 WHERE CPF IN (
  SELECT CPF_Paciente 
   FROM Prontuario
    WHERE Codigo_medico IN (
	 SELECT Codigo
	  FROM Medico WHERE Nome LIKE '%Vinicius%'));
/*
Quantos dias fazem da consulta de Maria Rita até hoje													
*/
SELECT 
 Data_Consulta,
 DATEDIFF(DAY, Data_Consulta, GETDATE()) AS "Quantida de Dias"
FROM
Prontuario 
 WHERE CPF_Paciente IN (
  SELECT CPF 
   FROM Pacientes
    WHERE Nome LIKE 'Maria Rita');
 
/*
Alterar o telefone da paciente Maria Rita, para 98345621	
*/
UPDATE Pacientes SET Telefone = '98345621' where Nome LIKE 'Maria Rita'

/*
Alterar o Endereço de Joana de Souza para Voluntários da Pátria, 1980, Jd. Aeroporto													
*/
UPDATE Pacientes
SET
   Rua = 'Voluntários da Pátria',
   Numero = 1980,
   Bairro = 'Jd. Aeroporto'
WHERE Nome LIKE 'Joana de Souza';