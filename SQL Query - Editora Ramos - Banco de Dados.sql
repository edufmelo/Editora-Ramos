DROP DATABASE IF EXISTS editoras;
CREATE DATABASE editoras;
USE editoras;
CREATE TABLE Editora ( -- uma editora precisa de um nome, e ele deve ser único
 ID_Editora INT PRIMARY KEY AUTO_INCREMENT,
 Nome VARCHAR(50) UNIQUE NOT NULL
);
CREATE TABLE Livro ( -- livro deve ter titulo (que não precisa ser único) e ISBN (unico),paginas(maior que zero) , edição(maior que zero), deve ser relacionado a uma editora e ter um idioma( tem default),
-- e precisa de uma faixa etária
 ID_Livro INT PRIMARY KEY AUTO_INCREMENT,
 ISBN VARCHAR(30) NOT NULL UNIQUE,
 Titulo VARCHAR(50) NOT NULL,
 Paginas INT NOT NULL CHECK (Paginas > 0) ,
 Edicao INT NOT NULL CHECK (Edicao > 0),
 Data_Publicacao DATE,
 fk_Editora_ID_Editora INT NOT NULL,
 fk_Idioma_ID_Idioma INT NOT NULL DEFAULT (1) , -- 1 é PT
 fk_Faixa_Etaria_ID_Faixa_Etaria INT NOT NULL DEFAULT (1) -- 1 é 'não informado'
);
CREATE TABLE Autor ( -- autor deve ter um nome(que nao precisa ser unico) , podemos ter datas de nasc.e fale. , desde que fale.>nasc. , sexo e nacionalidade tem default
 ID_Autor INT PRIMARY KEY AUTO_INCREMENT,
 Nome VARCHAR(100) NOT NULL,
 Data_Nascimento DATE,
 Data_Falecimento DATE,
 fk_Sexo_ID_Sexo INT NOT NULL DEFAULT (1) , -- 1 é 'não informado'
  fk_Nacionalidade_ID_Nacionalidade INT NOT NULL DEFAULT (1) , -- 1 é 'não informado'
 CHECK (Data_Falecimento > Data_Nascimento OR Data_Falecimento IS NULL)
);
CREATE TABLE Revista ( -- revista deve ter um nome , e um ISSN (que não pode ser repetido) , e deve estar relacionada a uma editora, assim como livro
 ID_Revista INT PRIMARY KEY AUTO_INCREMENT,
 Nome VARCHAR(100) NOT NULL,
 ISSN VARCHAR(50) UNIQUE NOT NULL,
 fk_Editora_ID_Editora INT NOT NULL
);
CREATE TABLE Edicao ( -- edicao não deve ser menor ou igual a zero(como livro), e deve ter um numero de paginas (também maior que zero). Data_edicao e Edicao são obrigatórios pois são PKs
 Edicao INT CHECK (Edicao > 0),
 fk_Revista_ID_Revista INT,
 Paginas INT NOT NULL CHECK (Paginas > 0),
 Data_edicao DATE, -- alterado pois Data é palavra reservada
 PRIMARY KEY (Edicao, fk_Revista_ID_Revista)
);
CREATE TABLE Sexo ( -- sexo deve ter nome obrigatoriamente e deve ser unico, não cadastraremos 'Feminino' duas vezes, por exemplo
 ID_Sexo INT PRIMARY KEY AUTO_INCREMENT,
 Sexo VARCHAR(50) UNIQUE NOT NULL
);
CREATE TABLE Nacionalidade (-- nacionalidade deve ter nome obrigatoriamente e deve ser unica
 ID_Nacionalidade INT PRIMARY KEY AUTO_INCREMENT,
 Nacionalidade VARCHAR(100) UNIQUE NOT NULL
);
CREATE TABLE Idioma (-- idioma deve ter nome obrigatoriamente e deve ser unico
 ID_Idioma INT PRIMARY KEY AUTO_INCREMENT,
 Idioma VARCHAR(50) UNIQUE NOT NULL
);
CREATE TABLE Faixa_Etaria (-- faixa etaria deve ter nome obrigatoriamente e deve ser unica
 ID_Faixa_Etaria INT PRIMARY KEY AUTO_INCREMENT,
 Faixa_Etaria VARCHAR(20) UNIQUE NOT NULL
);
CREATE TABLE Tema (-- tema deve ter nome obrigatoriamente e deve ser unico
 ID_Tema INT PRIMARY KEY AUTO_INCREMENT,
 Tema VARCHAR(20) UNIQUE NOT NULL
);
CREATE TABLE Autoria (
 fk_Livro_ID_Livro INT,
 fk_Autor_ID_Autor INT,
 PRIMARY KEY (fk_Livro_ID_Livro, fk_Autor_ID_Autor)
);
CREATE TABLE Tem (
 fk_Livro_ID_Livro INT,
 fk_Tema_ID_Tema INT,
 PRIMARY KEY (fk_Livro_ID_Livro, fk_Tema_ID_Tema)
);
ALTER TABLE Livro ADD CONSTRAINT FK_Livro_2 -- se uma editora é excluída, quero que os livros que ela publique também sejam excluídos
 FOREIGN KEY (fk_Editora_ID_Editora)
 REFERENCES Editora (ID_Editora)
ON DELETE CASCADE;

ALTER TABLE Livro ADD CONSTRAINT FK_Livro_3 -- nao posso excluir um idioma se ele é referenciado, pois ele é obrigatório
 FOREIGN KEY (fk_Idioma_ID_Idioma)
 REFERENCES Idioma (ID_Idioma)
 ON DELETE RESTRICT;
 
ALTER TABLE Livro ADD CONSTRAINT FK_Livro_4 -- nao posso excluir uma faixa se é referencia, pois é NOT NULL
 FOREIGN KEY (fk_Faixa_Etaria_ID_Faixa_Etaria)
 REFERENCES Faixa_Etaria (ID_Faixa_Etaria)
 ON DELETE RESTRICT;
 
ALTER TABLE Autor ADD CONSTRAINT FK_Autor_2 -- nao posso excluir sexo se é referencia, pois é NOT NULL
 FOREIGN KEY (fk_Sexo_ID_Sexo)
 REFERENCES Sexo (ID_Sexo)
 ON DELETE RESTRICT;
 
ALTER TABLE Autor ADD CONSTRAINT FK_Autor_3 -- nao posso excluir uma nacionalidade se é referencia, pois é NOT NULL
 FOREIGN KEY (fk_Nacionalidade_ID_Nacionalidade)
 REFERENCES Nacionalidade (ID_Nacionalidade)
 ON DELETE RESTRICT;
 
ALTER TABLE Revista ADD CONSTRAINT FK_Revista_2 -- se uma editora é excluída, quero que AS revistas que ela publique também sejam excluídas
 FOREIGN KEY (fk_Editora_ID_Editora)
 REFERENCES Editora (ID_Editora)
 ON DELETE CASCADE;
 
ALTER TABLE Edicao ADD CONSTRAINT FK_Edicao_2 -- se deleta uma revista, deleta todas suas edições
 FOREIGN KEY (fk_Revista_ID_Revista)
 REFERENCES Revista (ID_Revista)
 ON DELETE CASCADE;
 
ALTER TABLE Autoria ADD CONSTRAINT FK_Autoria_1 -- nao deleta livros se tiver autor com ele, para deletar livro, delete autorias primeiro
 FOREIGN KEY (fk_Livro_ID_Livro)
 REFERENCES Livro (ID_Livro)
 ON DELETE RESTRICT;
 
ALTER TABLE Autoria ADD CONSTRAINT FK_Autoria_2 -- nao deleta autor se tiver livros com ele, para deletar autor, delete autorias primeiro
 FOREIGN KEY (fk_Autor_ID_Autor)
 REFERENCES Autor (ID_Autor)
 ON DELETE RESTRICT;
 
ALTER TABLE Tem ADD CONSTRAINT FK_Tem_1 -- se excluir livro, exclua registros 'Tem' relacionados
 FOREIGN KEY (fk_Livro_ID_Livro)
 REFERENCES Livro (ID_Livro)
 ON DELETE CASCADE;
 
ALTER TABLE Tem ADD CONSTRAINT FK_Tem_2 -- se excluir tema, exclua registros 'Tem' relacionados
 FOREIGN KEY (fk_Tema_ID_Tema)
 REFERENCES Tema (ID_Tema)
 ON DELETE CASCADE;
 
 INSERT INTO Editora (Nome) VALUES
('Ramos'),
('Estrela do Saber'),
('Vereda Literária'),
('Mundo dos Livros'),
('Ponto de Leitura'),
('Horizonte Editorial'),
('Nova Era'),
('Luz do Conhecimento'),
('Navegar Editora'),
('Caminho Literário'),
('Explorar Livros'),
('Oásis Cultural'),
('Encanto das Palavras'),
('Universo do Saber'),
('Conquista Literária');

INSERT INTO Sexo (Sexo) VALUES
('Não informado'),
('Feminino'),
('Masculino'),
('Outro'),
('Transgênero'),
('Não-binário'),
('Intersexo'),
('Cisgênero Feminino'),
('Cisgênero Masculino'),
('Pangénero'),
('Agênero'),
('Bigênero'),
('Demigênero'),
('Genderfluid'),
('Gênero fluido');

INSERT INTO Nacionalidade (Nacionalidade) VALUES
('Não informado'),
('Brasileiro'),
('Colombiano'),
('Americano'),
('Francês'),
('Inglês'),
('Alemão'),
('Italiano'),
('Espanhol'),
('Argentino'),
('Japonês'),
('Chileno'),
('Mexicano'),
('Canadense'),
('Português'),
('Russo'),
('Grego');

INSERT INTO Idioma (Idioma) VALUES
('Português'),
('Espanhol'),
('Inglês'),
('Francês'),
('Alemão'),
('Italiano'),
('Japonês'),
('Chinês'),
('Russo'),
('Árabe'),
('Hindi'),
('Coreano'),
('Latim'),
('Grego'),
('Holandês');

INSERT INTO Faixa_Etaria (Faixa_Etaria) VALUES
('Não informado'),
('Livre'),
('Bebê'),
('Criança 4-6'),
('Criança 7-9'),
('Adoles. 10-12'),
('Adoles. 13-15'),
('Adoles. 16-18'),
('Jovem Adulto'),
('Adulto'),
('Meia-idade'),
('Idoso'),
('Idoso 65+'),
('Idoso 70+'),
('Idoso Plus');

INSERT INTO Tema (Tema) VALUES
('Não informado'),
('Ficção'),
('Não-ficção'),
('Aventura'),
('Mistério'),
('Fantasia'),
('Romance'),
('Ciência'),
('História'),
('Autobiografia'),
('Terror'),
('Suspense'),
('Drama'),
('Comédia'),
('Thriller'),
('Ficção Científica'),
('Ficção Histórica'),
('Ficção Policial'),
('Ficção Distópica'),
('Ficção Social');

INSERT INTO Livro (ISBN, Titulo, Data_publicacao, Paginas,fk_Faixa_Etaria_ID_Faixa_Etaria,
fk_Idioma_ID_Idioma, Edicao, fk_Editora_ID_Editora) VALUES
('978-8532511010', 'Harry Potter e a Pedra Filosofal', '2000-04-08', 264, 6, 1, 6, 1),
('978-8532530790', 'Harry Potter e a Câmara Secreta', '2017-08-19', 224, 6, 1, 6, 11),
('978-8528624021', 'Good Omens: Belas Maldições', '2019-05-20', 364, 8, 1, 1, 10),
('978-0147514011', 'Little Women', '2014-08-28', 777, 5, 3, 1, 9),
('978-65559801341', 'O Jardim Secreto', '2021-06-16', 288, 6, 1, 1, 7),
('978-0061120084', 'To Kill a Mockingbird', '2006-05-23', 336,7, 3, 5, 2),
('978-0679783268', 'Pride and Prejudice', '1995-10-10', 279,6, 3, 1, 1),
('978-6589678342', 'Razão e Sensibilidade', '2021-04-09', 288, 7, 1, 4, 3),
('978-6589678373', 'Emma', '2021-05-12', 368, 7, 1, 1, 1),
('978-6555524024', 'Mansfield Park', '2021-06-01', 480,6, 1, 1, 1),
('978-0060850524', 'Brave New World', '2006-09-19', 288,7, 3, 3, 3),
('978-0743273565', 'The Great Gatsby', '2004-09-30', 180, 7, 3, 1, 1),
('978-0156012195', 'The Little Prince', '2000-04-06', 96, 5, 3, 2, 1),
('978-1607964155', 'Le Petit Prince', '2002-06-11', 96, 5, 4, 1, 2),
('978-2070409201', 'Les Misérables', '2020-04-03', 1232, 10,4, 1, 1),
('978-0140449266', 'Crime and Punishment', '2002-12-31', 671, 10, 3, 5, 15),
('978-1503280786', 'Moby-Dick', '2014-11-29', 654, 10, 3, 4, 15),
('978-0486411095', 'The Odyssey', '1999-06-30', 560, 10, 3, 1, 15),
('978-0451524935', '1984', '1950-07-01', 328, 10, 3, 10, 15);

INSERT INTO Autor (Nome, Data_Nascimento, Data_Falecimento, fk_Nacionalidade_ID_Nacionalidade,
fk_Sexo_ID_Sexo) VALUES
('J.K. Rowling', '1965-07-31',NULL, 6, 2),
('Neil Gaiman', '1960-11-10',NULL, 6, 3),
('Terry Pratchett', '1948-04-28','2015-03-12', 6, 3),
('Louisa May Alcott', '1832-11-29','1888-03-06', 4, 2),
('Frances Hodgson Burnett', '1849-11-24','1924-10-29', 6, 2),
('Harper Lee', '1926-04-28','2016-02-19', 4, 2),
('Jane Austen', '1775-12-16','1817-07-18', 6, 2),
('Aldous Huxley', '1894-07-26','1963-11-22', 6, 3),
('F. Scott Fitzgerald', '1896-09-24','1940-12-21', 4,3),
('Antoine de Saint-Exupéry', '1900-06-29','1944-07-31', 5, 3),
('Victor Hugo', '1802-02-26', '1885-05-22', 5, 3),
('Fyodor Dostoevsky', '1821-11-11','1881-02-09', 16, 3),
('Herman Melville', '1819-08-01','1891-09-28', 4, 3),
('Homero', NULL, NULL, 17, 3),
('George Orwell', '1903-06-25','1950-01-21', 6, 3);

INSERT INTO Autoria (fk_Livro_ID_Livro, fk_Autor_ID_Autor) VALUES
(1, 1),
(2, 1),
(3, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 7),
(9, 7),
(10, 7),
(11, 8),
(12, 9),
(13,10),
(14,10),
(15,11),
(16,12),
(17, 13),
(18, 14),
(19, 15);

INSERT INTO Revista (ISSN, Nome, fk_Editora_ID_Editora) VALUES
('0102-695X', 'Revista Brasileira de Farmacognosia', 1),
('1516-8913', 'Brazilian Archives of Biology and Technology', 2),
('1679-9283', 'Acta Scientiarum. Biological Sciences', 3),
('0103-6513', 'Revista Produção', 4),
('0046-9939', 'Boletim do Instituto de Pesca', 5),
('2175-3423', 'Revista Brasileira de História & Ciências Sociais', 6),
('0034-7094', 'Revista Brasileira de Anestesiologia', 7),
('1517-3151', 'Revista Brasileira de Engenharia Biomédica', 8),
('0104-530X', 'Gestão & Produção', 9),
('1806-9126', 'Revista Brasileira de Ensino de Física', 10),
('0102-3306', 'Acta Botanica Brasilica', 11),
('0102-8650', 'Acta Cirurgica Brasileira', 12),
('0102-6712', 'Acta Limnologica Brasiliensia', 13),
('1413-7852', 'Acta Ortopedica Brasileira', 14),
('0044-5967', 'Acta Amazonica', 1);

INSERT INTO Edicao (Edicao, fk_Revista_ID_Revista, Paginas, Data_edicao) VALUES
(1, 1, 125, '2023-01-20'),
(2, 1, 101, '2023-02-20'),
(3, 1, 98, '2023-03-20'),
(1, 2, 98, '2023-01-05'),
(1, 3, 150, '2023-02-10'),
(2, 3, 100, '2023-03-15'),
(1, 4, 130, '2021-01-24'),
(2, 4, 152, '2021-02-25'),
(3, 4, 115, '2021-03-26'),
(1, 5, 110, '2023-01-10'),
(1, 6, 92, '2023-02-12'),
(2, 6, 94, '2023-03-13'),
(1, 7, 85, '2023-01-18'),
(1, 8, 112, '2023-02-02'),
(1, 9, 101, '2023-03-01'),
(2, 9, 110, '2023-03-15'),
(3, 9, 115, '2023-04-01'),
(4, 9, 111, '2023-04-15'),
(1, 10, 95, '2023-04-10'),
(1, 11, 87, '2000-02-15'),
(2, 11, 85, '2001-02-15'),
(1, 12, 94, '2023-03-10'),
(2, 12, 89, '2024-03-11'),
(1, 13, 103, '2023-01-25'),
(2, 13, 100, '2023-07-25'),
(3, 13, 98, '2024-01-25'),
(1, 14, 54, '2022-12-01'),
(1, 15, 84, '2000-03-20');

INSERT INTO Tem (fk_Livro_ID_Livro, fk_Tema_ID_Tema) VALUES
(1, 2),
(1, 6),
(2, 2),
(2, 6),
(3, 2),
(3, 4),
(4, 7),
(5, 2),
(6, 13),
(7, 7),
(8, 7),
(9, 7),
(10, 7),
(11, 16),
(12, 13),
(13, 2),
(14, 2),
(15, 13),
(15, 2),
(16, 18),
(17, 2),
(18, 2),
(19, 16);

SELECT * FROM Editora;
SELECT * FROM Sexo;
SELECT * FROM Nacionalidade;
SELECT * FROM Idioma;
SELECT * FROM Faixa_Etaria;
SELECT * FROM Tema; 
SELECT * FROM Livro;
SELECT * FROM Autor;
SELECT * FROM Autoria;
SELECT * FROM Revista;
SELECT * FROM Edicao;
SELECT * FROM Tem;

SELECT Nacionalidade.Nacionalidade, COUNT(Autor.ID_Autor) AS 'Quantidade Autores'
FROM Autor
INNER JOIN Nacionalidade ON Autor.fk_Nacionalidade_ID_Nacionalidade =
Nacionalidade.ID_Nacionalidade
GROUP BY Nacionalidade.Nacionalidade;

SELECT S.Sexo, COUNT(A.ID_Autor) AS 'Quantidade de livros por sexo', ROUND(AVG(L.Paginas),
0) AS 'Media de paginas por sexo'
FROM Sexo AS S
INNER JOIN Autor AS A ON S.ID_Sexo = A.fk_Sexo_ID_Sexo
INNER JOIN Autoria AS AU ON A.ID_Autor = AU.fk_Autor_ID_Autor
INNER JOIN Livro AS L ON AU.fk_Livro_ID_Livro = L.ID_Livro
GROUP BY S.Sexo
ORDER BY S.Sexo;

SELECT E.Nome, COUNT(L.ID_Livro) AS Quantidade_Livros, F.Faixa_Etaria
FROM Editora E
INNER JOIN Livro L ON E.ID_Editora = L.fk_Editora_ID_Editora
INNER JOIN Faixa_Etaria F ON F.ID_Faixa_Etaria = L.fk_Faixa_Etaria_ID_Faixa_Etaria
GROUP BY E.Nome, F.Faixa_Etaria
ORDER BY E.Nome;

SELECT E.Nome, A.Nome, L.Titulo, L.Paginas, I.Idioma
FROM Editora AS E
INNER JOIN Livro AS L ON E.ID_Editora = L.fk_Editora_ID_Editora
INNER JOIN Autoria AS AU ON AU.fk_Livro_ID_Livro = L.ID_Livro
INNER JOIN Autor AS A ON AU.fk_Autor_ID_Autor = A.ID_Autor
INNER JOIN Idioma AS I ON L.fk_Idioma_ID_Idioma = I.ID_Idioma
ORDER BY E.Nome;

SELECT A.Nome, A.Data_Nascimento, A.Data_Falecimento, N.Nacionalidade, S.Sexo
FROM Autor AS A
INNER JOIN Nacionalidade AS N ON N.ID_Nacionalidade = A.fk_Nacionalidade_ID_Nacionalidade
INNER JOIN Sexo AS S ON S.ID_Sexo = A.fk_Sexo_ID_Sexo
ORDER BY A.Nome;

SELECT E.Nome AS Editora, R.Nome AS Revista, Ed.Edicao AS 'Edicao Revista', Ed.Paginas,
DATE_FORMAT(Ed.Data_edicao, '%d/%m/%Y') AS 'Data de publicação'
FROM Editora E
INNER JOIN Revista R ON E.ID_Editora = R.fk_Editora_ID_Editora
INNER JOIN Edicao Ed ON R.ID_Revista = Ed.fk_Revista_ID_Revista
WHERE Ed.Edicao = 1
ORDER BY R.Nome;

USE editoras;
DELIMITER $$
CREATE PROCEDURE Inserir_livro(
 IN ISBN_cod VARCHAR(30),
 IN tit VARCHAR(50),
 IN pag INT,
 IN edicao INT,
 IN data_publi DATE,
 IN editora INT,
 IN idioma INT,
 IN faixaEtaria INT
)
BEGIN
 DECLARE falta VARCHAR(255);
 DECLARE invalido VARCHAR(255);
 DECLARE countISBN INT;
 SET falta = '';
SET invalido='';
 SET countISBN = 0;

 -- verificar se campo é inválido
 SELECT COUNT(*) INTO countISBN
 FROM Livro
 WHERE Livro.ISBN = ISBN_cod;

 IF countISBN > 0 THEN
 SET invalido = CONCAT(invalido, 'ISBN já existe na base de dados, ');
  END IF;

 IF (pag < 0 OR pag = 0 ) THEN
 SET invalido = CONCAT(invalido, 'Número de páginas deve ser maior que zero, ');
 END IF;

 IF (edicao < 0 OR edicao = 0 ) THEN
 SET invalido = CONCAT(invalido, 'Edicao deve ser maior que zero, ');
 END IF;

 -- Verificar cada parâmetro e concatenar os campos ausentes (apenas obrigatorios)
 IF ISBN_cod IS NULL THEN
 SET falta = CONCAT(falta, 'ISBN, ');
 END IF;

 IF tit IS NULL THEN
 SET falta = CONCAT(falta, 'Titulo, ');
 END IF;

 IF pag IS NULL THEN
 SET falta = CONCAT(falta, 'Paginas, ');
 END IF;

 IF edicao IS NULL THEN
 SET falta = CONCAT(falta, 'Edicao, ');
 END IF;
 
 IF editora IS NULL THEN
 SET falta = CONCAT(falta, 'fk_Editora_ID_Editora, ');
 END IF;
 
 IF idioma IS NULL THEN
 SET falta = CONCAT(falta, 'fk_Idioma_ID_Idioma, ');
 END IF;
 
 IF faixaEtaria IS NULL THEN
 SET falta = CONCAT(falta, 'fk_Faixa_Etaria_ID_Faixa_Etaria, ');
 END IF;
 
 -- Se há campos ausentes, remover a última vírgula e espaço e exibir mensagem
 IF LENGTH(falta) > 0 THEN
 SET falta = LEFT(falta, LENGTH(falta) - 2); -- Remove a última vírgula e espaço
 
 SELECT CONCAT('Erro: Campos ausentes - ', falta) AS ErrorMessage;
 
 ELSEIF LENGTH(invalido) > 0 THEN
SET invalido = LEFT(invalido, LENGTH(invalido) - 2); -- Remove a última vírgula e espaço
 
 SELECT CONCAT('Erro: Campos inválidos - ', invalido) AS ErrorMessage;

 ELSE
 -- Se todos os campos estão preenchidos, realizar a inserção
 INSERT INTO Livro (ISBN, Titulo, Data_publicacao, Paginas,fk_Faixa_Etaria_ID_Faixa_Etaria,
fk_Idioma_ID_Idioma, Edicao, fk_Editora_ID_Editora) VALUES
 (ISBN_cod,tit,data_publi,pag,faixaEtaria,idioma,edicao,editora);
 SELECT * FROM Livro;
 END IF;
END $$
DELIMITER;

DROP TABLE IF EXISTS LivroLog;
CREATE TABLE LivroLog (
ID_log INT AUTO_INCREMENT PRIMARY KEY,
Operation CHAR(6) NOT NULL,
ChangeDate DATETIME NOT NULL,
UserName VARCHAR(20) NOT NULL,
NID_Livro INT, -- new ID
OID_Livro INT, -- old ID
NISBN VARCHAR(30),
OISBN VARCHAR(30),
NTitulo VARCHAR(50),
OTitulo VARCHAR(50),
NPaginas INT,
OPaginas INT,
NEdicao INT,
OEdicao INT,
NData_Publicacao DATE,
OData_Publicacao DATE,
NEditora INT,
OEditora INT,
NIdioma INT,
OIdioma INT,
NFaixa_Etaria INT ,
OFaixa_Etaria INT
);

-- trigger insert
DROP TRIGGER IF EXISTS LivroLogInsert;
DELIMITER $$
CREATE TRIGGER LivroLogInsert
AFTER INSERT
ON Livro
FOR EACH ROW
BEGIN 
INSERT INTO LivroLog (Operation, ChangeDate, UserName, NID_Livro, NISBN, NTitulo , NPaginas,
NEdicao, NData_Publicacao, NEditora, NIdioma, NFaixa_Etaria)
SELECT 'Insert', NOW(), CURRENT_USER(), NEW.ID_Livro, NEW.ISBN,
NEW.Titulo, NEW.Paginas, NEW.Edicao, NEW.Data_Publicacao, NEW.fk_Editora_ID_Editora,
NEW.fk_Idioma_ID_Idioma, NEW.fk_Faixa_Etaria_ID_Faixa_Etaria;
END $$
DELIMITER ;
-- trigger update
DROP TRIGGER IF EXISTS LivroLogUpdate;
DELIMITER $$
CREATE TRIGGER LivroLogUpdate
AFTER UPDATE
ON Livro
FOR EACH ROW
BEGIN
	INSERT INTO LivroLog (Operation, ChangeDate, UserName, NID_Livro, OID_Livro, NISBN, OISBN,
	NTitulo, OTitulo, NPaginas, OPaginas, NEdicao, OEdicao,NData_Publicacao,OData_Publicacao,
	NEditora, OEditora, NIdioma, OIdioma, NFaixa_Etaria, OFaixa_Etaria)
	SELECT 'Update', NOW(), CURRENT_USER(), NEW.ID_Livro,
	OLD.ID_Livro,NEW.ISBN, OLD.ISBN, NEW.Titulo, OLD.Titulo, NEW.Paginas, OLD.Paginas,
	NEW.Edicao, OLD.Edicao, NEW.Data_Publicacao,OLD.Data_Publicacao,
	NEW.fk_Editora_ID_Editora, OLD.fk_Editora_ID_Editora, NEW.fk_Idioma_ID_Idioma,
	OLD.fk_Idioma_ID_Idioma, NEW.fk_Faixa_Etaria_ID_Faixa_Etaria,
	OLD.fk_Faixa_Etaria_ID_Faixa_Etaria;
END $$
DELIMITER ;

-- trigger delete
DROP TRIGGER IF EXISTS LivroLogDelete;
DELIMITER $$
CREATE TRIGGER LivroLogDelete
AFTER DELETE
ON Livro
FOR EACH ROW
BEGIN
	INSERT INTO LivroLog (Operation, ChangeDate, UserName,OID_Livro, OISBN,
	OTitulo,OPaginas,OEdicao,OData_Publicacao,OEditora, OIdioma,OFaixa_Etaria)
	SELECT 'Delete', NOW(), CURRENT_USER(), OLD.ID_Livro, OLD.ISBN,
	OLD.Titulo, OLD.Paginas, OLD.Edicao,OLD.Data_Publicacao, OLD.fk_Editora_ID_Editora,
	OLD.fk_Idioma_ID_Idioma, OLD.fk_Faixa_Etaria_ID_Faixa_Etaria;
END $$
DELIMITER ;

SELECT * FROM LivroLog; 

UPDATE Livro
SET Titulo = 'HP e a pedra filosofal'
WHERE ID_Livro = 1 ;
DELETE FROM Autoria
WHERE fk_Livro_ID_Livro=2;
DELETE FROM Livro
WHERE Livro.ID_Livro=2;