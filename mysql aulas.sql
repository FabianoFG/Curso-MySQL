use hcode;
select * from tb_funcionarios;
select * from tb_pessoas;
update tb_funcionario
set salario = salario*1.1;
delete from tb_funcionario;
insert into tb_pessoas VALUES(1,'João', 'M');
insert into tb_pessoas (sexo, nome) VALUES('F', 'Maria');
insert into tb_pessoas (nome, sexo) VALUES
('Divanei', 'M'),
('Luís', 'M'),
('Djalma', 'M'),
('Nataly', 'F'),
('Tatiane', 'F'),
('Cristiane', 'F'),
('Jaqueline', 'F');
insert into tb_funcionario (id, nome, salario, admissao, sexo)
select id, nome, 950, CURRENT_DATE(), sexo FROM tb_pessoas;

select count(*) as total from tb_funcionario;
SELECT nome, salario AS atual,
CONVERT(salario*1.1,DEC(10,2)) AS 'salário com aumento de 100%'
FROM tb_funcionario;

SELECT * FROM tb_funcionario WHERE sexo = 'M' AND salario > 1000;
UPDATE tb_funcionario SET salario = salario*1.4 WHERE id = 1;
SELECT * FROM tb_funcionario WHERE sexo = 'F' OR salario >1000;

SELECT * FROM tb_funcionario WHERE nome LIKE '__v%';
SELECT * FROM tb_funcionario WHERE nome NOT LIKE 'd%';
SELECT * FROM tb_funcionario WHERE salario NOT BETWEEN 1000 AND 2000;
SELECT * FROM tb_funcionario WHERE SOUNDEX(nome) = SOUNDEX('Luíz');

SELECT * FROM tb_funcionario WHERE cadastro > '2022-02-11';
UPDATE tb_funcionario SET admissao = CURRENT_DATE() WHERE id = 1;
UPDATE tb_funcionario SET admissao = DATE_ADD(CURRENT_DATE(), INTERVAL 60 DAY) WHERE id = 2;
SELECT DATEDIFF(admissao, CURRENT_DATE()) FROM tb_funcionario WHERE id = 2;
SELECT * FROM tb_funcionario WHERE MONTH(admissao) = 4;

SELECT * FROM tb_funcionario ORDER BY nome;
SELECT * FROM tb_funcionario ORDER BY 2;
SELECT * FROM tb_funcionario ORDER BY salario DESC, nome;
SELECT * FROM tb_funcionario ORDER BY salario LIMIT 0,3;
SELECT * FROM tb_funcionario WHERE YEAR(admissao) = 2022 AND MONTH(admissao) = 2
ORDER BY salario LIMIT 0,3;

use world;
show tables;
desc city;
select name from city;
select count(name) as total from city;
select * from city where Name like 'M%' and CountryCode like 'BRA';

UPDATE tb_funcionario
SET salario = 3000
WHERE id = 5;
UPDATE tb_funcionario
SET salario = 4000, admissao = '2022-01-29'
WHERE id = 6;

START TRANSACTION;
DELETE FROM tb_funcionario WHERE id = 3;
ROLLBACK;
COMMIT;
START TRANSACTION;
TRUNCATE TABLE tb_pessoas;
ROLLBACK;

DROP TABLE tb_funcionario;
DROP TABLE tb_pessoas;
CREATE TABLE tb_pessoas(
idpessoa INT AUTO_INCREMENT NOT NULL,
desnome VARCHAR(256) NOT NULL,
dtcadastro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
CONSTRAINT PK_pessoas PRIMARY KEY (idpessoa)
) ENGINE = InnoDB;
CREATE TABLE tb_funcionarios(
idfuncionario INT AUTO_INCREMENT NOT NULL,
idpessoa INT NOT NULL,
vlsalario DECIMAL(10,2) NOT NULL DEFAULT 1000.00,
dtadmissao DATE NOT NULL,
CONSTRAINT PK_funcionarios PRIMARY KEY (idfuncionario),
CONSTRAINT PK_funcionarios_pessoas FOREIGN KEY (idpessoa)
	REFERENCES tb_pessoas (idpessoa)
);
INSERT INTO tb_pessoas VALUES(DEFAULT, 'João', DEFAULT);
SELECT * FROM tb_pessoas;
INSERT INTO tb_funcionarios VALUES(NULL, 1, 5000, current_date());
SELECT * FROM tb_funcionarios;
INSERT INTO tb_funcionarios VALUES(NULL, 2, 5000, current_date());

SELECT *
FROM tb_funcionarios a
INNER JOIN tb_pessoas b ON a.idpessoa = b.idpessoa;
SELECT *
FROM tb_funcionarios
INNER JOIN tb_pessoas USING(idpessoa);
INSERT INTO tb_pessoas VALUES(DEFAULT, 'Gláucio', DEFAULT);
SELECT * FROM tb_pessoas a
LEFT JOIN tb_funcionarios b ON a.idpessoa = b.idpessoa;
SELECT * FROM tb_pessoas a
RIGHT JOIN tb_funcionarios b ON a.idpessoa = b.idpessoa;

INSERT INTO tb_pessoas VALUE(DEFAULT, 'José', DEFAULT);
SELECT * FROM tb_pessoas WHERE desnome LIKE 'J%';
SELECT idpessoa FROM tb_pessoas WHERE desnome LIKE 'J%';
SELECT vlsalario FROM tb_funcionarios WHERE idpessoa IN(SELECT idpessoa FROM tb_pessoas WHERE desnome LIKE 'J%');
START TRANSACTION;
DELETE FROM tb_pessoas WHERE desnome LIKE 'G%';
ROLLBACK;
COMMIT;

CREATE TABLE tb_pedidos (
idpedido INT AUTO_INCREMENT NOT NULL,
idpessoa INT NOT NULL,
dtpedido DATETIME NOT NULL,
vlpedido DEC(10,2),
CONSTRAINT PK_pedidos PRIMARY KEY(idpedido),
CONSTRAINT PK_pedidos_pessoas FOREIGN KEY(idpessoa) REFERENCES tb_pessoas (idpessoa)
);
SELECT * FROM tb_pedidos;
INSERT INTO tb_pedidos VALUES(DEFAULT, 1, CURRENT_DATE(), 22000.00);
INSERT INTO tb_pedidos VALUES(DEFAULT, 1, CURRENT_DATE(), 5000.00);
INSERT INTO tb_pedidos VALUES(DEFAULT, 1, CURRENT_DATE(), 10000.00);
INSERT INTO tb_pedidos VALUES(DEFAULT, 1, CURRENT_DATE(), 1000.00);
INSERT INTO tb_pedidos VALUES(DEFAULT, 1, CURRENT_DATE(), 3000.00);
insert into tb_pessoas VALUES(DEFAULT, 'Andressa', DEFAULT);
INSERT INTO tb_pedidos VALUES(DEFAULT, 3, CURRENT_DATE(), 1999.90);
INSERT INTO tb_pedidos VALUES(DEFAULT, 3, CURRENT_DATE(), 2000.00);
INSERT INTO tb_pedidos VALUES(DEFAULT, 3, CURRENT_DATE(), 123.45);
insert into tb_pessoas VALUES(DEFAULT, 'Camila', DEFAULT);
INSERT INTO tb_pedidos VALUES(DEFAULT, 4, CURRENT_DATE(), 40000.00);
SELECT b.desnome, SUM(a.vlpedido) AS total FROM tb_pedidos a INNER JOIN tb_pessoas b USING(idpessoa) GROUP BY b.idpessoa;

CREATE VIEW v_pedidostotais
AS
SELECT b.desnome,
SUM(a.vlpedido) AS total,
CONVERT(AVG(a.vlpedido),DEC(10,2)) AS media,
CONVERT(MIN(a.vlpedido),DEC(10,2)) AS 'menor valor',
CONVERT(MAX(a.vlpedido),DEC(10,2)) AS 'maior valor',
COUNT(*) AS 'total de pedidos'
FROM tb_pedidos a INNER JOIN tb_pessoas b USING(idpessoa)
GROUP BY b.idpessoa
HAVING SUM(a.vlpedido) > 6200
ORDER BY SUM(a.vlpedido);

SELECT * FROM v_pedidostotais WHERE total > 40000;

SELECT * FROM tb_pessoas;
DELIMITER $$
CREATE PROCEDURE sp_pessoa_save (
pdesnome VARCHAR(256)
)
BEGIN
	INSERT INTO tb_pessoas VALUES(NULL, pdesnome, DEFAULT);
	SELECT * FROM tb_pessoas WHERE idpessoa = LAST_INSERT_ID();
END $$
DELIMITER ;
CALL sp_pessoa_save('Massaharu');
DROP PROCEDURE sp_pessoa_save;

DELIMITER $$
CREATE PROCEDURE sp_funcionario_save (
pdesnome VARCHAR(256),
pvlsalario DECIMAL(10,2),
pdtadmissao DATETIME
)
BEGIN
	DECLARE vidpessoa INT;
    START TRANSACTION;
    IF NOT EXISTS(SELECT idpessoa FROM tb_pessoas WHERE desnome = pdesnome) THEN
		INSERT INTO tb_pessoas VALUES(NULL, pdesnome, DEFAULT);
        SET vidpessoa = LAST_INSERT_ID();
	ELSE
		SELECT 'Usuário já cadastrado!' AS resultado;
	END IF;
    IF NOT EXISTS(SELECT idpessoa FROM tb_funcionarios WHERE idpessoa = vidpessoa) THEN
		INSERT INTO tb_funcionarios VALUES(NULL, vidpessoa, pvlsalario, pdtadmissao);
	ELSE
		SELECT 'Usuário já cadastrado!' AS resultado;
	END IF;
    COMMIT;
	SELECT 'Dados cadastrados com sucesso!' AS resultado;
END $$
DELIMITER ;
CALL sp_funcionario_save('Divanei', 50000, CURRENT_DATE());

SET GLOBAL log_bin_trust_function_creators = 1;
DELIMITER $$
CREATE FUNCTION fn_imposto_renda(
	pvlsalario DECIMAL(10,2)
)
RETURNS DEC(10,2)
BEGIN
	DECLARE vimposto DECIMAL(10,2);
    SET vimposto = CASE
		WHEN pvlsalario <= 1903.98 THEN 0
        WHEN pvlsalario >= 1903.99 AND pvlsalario <= 2826.65 THEN (pvlsalario * .075) -142.80
        WHEN pvlsalario >= 2826.66 AND pvlsalario <= 3751.05 THEN (pvlsalario * .15) -354.80
        WHEN pvlsalario >= 3751.06 AND pvlsalario <= 4664.68 THEN (pvlsalario * .225) -636.13
        WHEN pvlsalario >= 4664.68 THEN (pvlsalario * .275) -869.36
	END;
    RETURN vimposto;
END $$
DELIMITER ;
SELECT *, fn_imposto_renda(a.vlsalario) AS vlimposto
FROM tb_funcionarios a
INNER JOIN tb_pessoas b USING(idpessoa);
DROP FUNCTION fn_imposto_renda;