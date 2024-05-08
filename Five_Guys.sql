
create database bd_fiveguys

use bd_fiveguys
 
CREATE TABLE Post (
	id_post INT identity(1,1) PRIMARY KEY,
	denumire VARCHAR(50)
);
 
CREATE TABLE Angajat (
    id_angajat INT identity(1,1) PRIMARY KEY,
    nume VARCHAR(50),
    prenume VARCHAR(50),
    post VARCHAR(50),
    cnp VARCHAR(13),
	id_post INT FOREIGN KEY REFERENCES Post(id_post)
	on delete cascade
	on update cascade,
);
drop table Orders
drop table Cumparator
drop table Menu
drop table Angajat
drop table Post

 
CREATE TABLE Menu (

    id_product INT identity(1,1) PRIMARY KEY,
    name_product VARCHAR(100),
    price_product DECIMAL(10, 2),
    ingredients_product VARCHAR(MAX)

);
 
 
CREATE TABLE Cumparator (

    id_cumparator INT PRIMARY KEY,
    nume VARCHAR(50),
    prenume VARCHAR(50),
	id_angajat INT FOREIGN KEY REFERENCES Angajat(id_angajat)
	on delete cascade
	on update cascade

);

CREATE TABLE Orders (

    id_order INT PRIMARY KEY,
    id_product INT FOREIGN KEY REFERENCES Menu(id_product)
	on delete cascade
	on update cascade,
    id_angajat INT FOREIGN KEY REFERENCES Angajat(id_angajat)
	on delete cascade
	on update cascade


);

-----------------------------------------------------Lab 2-------------------------------------------------------
-- Inserare de date in tabela Post
INSERT INTO Post (denumire)
VALUES ('Post 1');

INSERT INTO Post (denumire)
VALUES ('Post 2');

-- Inserare de date in tabela Angajat
INSERT INTO Angajat (nume, prenume, post, cnp, id_post)
VALUES ('Nume1', 'Prenume1', 'Post1', '1234567890123', 1);

INSERT INTO Angajat (nume, prenume, post, cnp, id_post)
VALUES ('Nume2', 'Prenume2', 'Post2', '2345678901234', 2);

-- Inserare de date in tabela Menu
INSERT INTO Menu (name_product, price_product, ingredients_product)
VALUES ('Product 1', 10.99, 'Ingredient 1, Ingredient 2');

INSERT INTO Menu (name_product, price_product, ingredients_product)
VALUES ('Product 2', 8.99, 'Ingredient 3, Ingredient 4');

-- Inserare de date in tabela Cumparator
INSERT INTO Cumparator (id_cumparator, nume, prenume, id_angajat)
VALUES (1, 'NumeCumparator1', 'PrenumeCumparator1', 1);

INSERT INTO Cumparator (id_cumparator, nume, prenume, id_angajat)
VALUES (2, 'NumeCumparator2', 'PrenumeCumparator2', 2);

-- Inserare de date in tabela Orders
INSERT INTO Orders (id_order, id_product, id_angajat)
VALUES (1, 1, 1);

INSERT INTO Orders (id_order, id_product, id_angajat)
VALUES (2, 2, 2);

-- Modificarea numelui unui angajat cu id_angajat = 1
UPDATE Angajat
SET nume = 'NumeModificat'
WHERE id_angajat = 1 and id_post = 1;

-- Ștergerea unui angajat cu id_angajat = 1
DELETE FROM Angajat
WHERE id_angajat = 1 or id_post < 2;

-- Ștergerea tuturor comenzilor pentru un anumit produs cu id_product = 1
DELETE FROM Orders
WHERE id_product is not null;

SELECT * from Angajat
SELECT * from Cumparator
SELECT * from Orders
SELECT * from Post
SELECT * from Menu

----------------------------------------------- Lab3 -----------------------------------------------------
--Lab3 – atribuit in saptamana 5/6 cu predare in saptamana 7/8

--Pentru baza de date de la laboratorul 2, scrieti urmatoarele interogari SELECT:

--1. o interogare cu unul din operatorii UNION, INTERSECT, EXCEPT, la alegere;

--2. doua interogari cu operatorii INNER JOIN si, la alegere, LEFT JOIN, RIGHT JOIN sau FULL JOIN;
  -- fiecare interogare va extrage date din minim trei tabele aflate in relatie many-to-many;

--3. trei interogari cu clauza GROUP BY; una dintre acestea va contine clauza HAVING; se vor folosi
   --cel putin trei operatori de agregare dintre: COUNT, SUM, AVG, MIN, MAX.

--4. optional: doua interogari imbricate – se vor folosi operatorii IN si EXISTS (interogare SELECT in clauza WHERE);

--Din interogarile de mai sus:
--• cel putin una va contine o conditie compusa cu AND, OR, NOT, paranteze in clauza WHERE;
--• cel putin una va utiliza DISTINCT.
-- Afișează denumirile produselor și ingredientele acestora


SELECT name_product, ingredients_product FROM Menu
UNION
SELECT denumire, NULL FROM Post;

-- Interogare 1 - INNER JOIN
SELECT Angajat.nume, Angajat.prenume, Menu.name_product
FROM Angajat
INNER JOIN Orders ON Angajat.id_angajat = Orders.id_angajat
INNER JOIN Menu ON Orders.id_product = Menu.id_product
SELECT Cumparator.nume, Cumparator.prenume, Orders.id_order
FROM Cumparator
INNER JOIN Orders ON Cumparator.id_angajat = Orders.id_angajat
INNER JOIN Menu ON Orders.id_product = Menu.id_product; 

-- Interogare 2 - LEFT JOIN
SELECT Cumparator.nume, Cumparator.prenume, Orders.id_order
FROM Cumparator
LEFT JOIN Orders ON Cumparator.id_angajat = Orders.id_angajat
LEFT JOIN Menu ON Orders.id_product = Menu.id_product; 

-- Interogare 1 - Numărul total de comenzi pentru fiecare angajat
SELECT Angajat.nume, Angajat.prenume, COUNT(Orders.id_order) AS NumarComenzi
FROM Angajat
INNER JOIN Orders ON Angajat.id_angajat = Orders.id_angajat
GROUP BY Angajat.nume, Angajat.prenume;

-- Interogare 2 - Prețul mediu al produselor
SELECT AVG(price_product) AS PretMediu
FROM Menu;

-- Interogare 3 - Numărul total de angajați pentru fiecare post
SELECT Post.denumire, COUNT(Angajat.id_angajat) AS NumarAngajati
FROM Post
LEFT JOIN Angajat ON Post.id_post = Angajat.id_post
GROUP BY Post.denumire
HAVING COUNT(Angajat.id_angajat) > 0;


-- Interogare 1 - Afișează comenzi făcute de cumpărători care au cumpărat produse cu prețul mai mare de 10
SELECT DISTINCT o.*
FROM Orders o
WHERE o.id_angajat IN (
    SELECT c.id_cumparator
    FROM Cumparator c
    WHERE c.id_angajat IN (
        SELECT m.id_product
        FROM Menu m
        WHERE m.price_product > 10
    )
);


-- Interogare 2 - Afișează angajații care au plasat comenzi
SELECT nume, prenume
FROM Angajat
WHERE EXISTS (SELECT * FROM Orders WHERE Orders.id_angajat = Angajat.id_angajat);

---------------------------------------------------------Lab 4------------------------------------------------------------------


CREATE PROCEDURE InsertIntoMenu
	@name_product VARCHAR(100),
    @price_product DECIMAL(10, 2),
    @ingredients_product VARCHAR(MAX)
AS
    IF LEN(@name_product) > 3 
	BEGIN
        INSERT INTO Menu VALUES (@name_product,@price_product,@ingredients_product);
	END
    ELSE
	BEGIN
        RAISERROR('LUNGIMEA NUMELUI PREA MICA',1,1)
	END
GO
EXEC InsertIntoMenu @name_product = 'test2',@price_product = 18.99,@ingredients_product = 'NUJ'
SELECT * from Menu
EXEC InsertIntoMenu @name_product = 't',@price_product = 18.99,@ingredients_product = 'ciuri'
DELETE FROM Menu WHERE ingredients_product = 'ciuri'

CREATE PROCEDURE InsertIntoPost
    @denumire VARCHAR(50)
AS
    IF LEN(@denumire) > 5
	BEGIN
        INSERT INTO Post VALUES (@denumire);
	END
	ELSE
    BEGIN
        RAISERROR('LUNGIMEA NUMELUI PREA MICA',1,1)
	END
GO

DELETE FROM Post WHERE denumire = 'testpost'

drop procedure InsertIntoPost
delete from Post where denumire = 'testpost'
EXEC InsertIntoPost @denumire = 'testpost'
SELECT * from Post
EXEC InsertIntoPost @denumire = 'test'

CREATE FUNCTION IDEXIST(@id_post INT)
RETURNS INT AS
BEGIN
declare @value int
set @value  = 0
IF @id_post in (select id_post from Angajat)
set @value  = 1
return @value
end



CREATE PROCEDURE InsertIntoAngajat
    @nume VARCHAR(50),
    @prenume VARCHAR(50),
    @post VARCHAR(50),
    @cnp VARCHAR(13),
	@id_post INT 
AS
	IF LEN(@nume) > 2 and dbo.IDEXIST(@id_post) = 1
	BEGIN
		INSERT INTO Angajat VALUES (@nume,@prenume,@post,@cnp,@id_post)
	END
	ELSE
	BEGIN
        RAISERROR('PARAMETRII NU CORESPUND',1,1)
	END
GO

drop procedure InsertIntoAngajat

DELETE FROM Angajat WHERE nume = 'test'

EXEC InsertIntoAngajat @nume = 'test',@prenume = 'test',@post = 'test',@cnp = 'testtest',@id_post = 1
EXEC InsertIntoAngajat @nume = 'test2',@prenume = 'test2',@post = 'test2',@cnp = 'testtest2',@id_post = 19
EXEC InsertIntoAngajat @nume = 't',@prenume = 'test',@post = 'test',@cnp = 'testtest',@id_post = 1
SELECT * from Angajat
SELECT * from Post
SELECT * from Menu

drop view AngajatCumparator

CREATE VIEW AngajatCumparator AS
SELECT Angajat.nume AS NumeAngajat, Angajat.prenume AS PrenumeAngajat,
       Cumparator.nume AS NumeCumparator, Cumparator.prenume AS PrenumeCumparator
FROM Angajat
JOIN Cumparator ON Angajat.id_angajat = Cumparator.id_angajat;

Select * from AngajatCumparator

CREATE TRIGGER InsertMenuTrigger
ON Menu
AFTER INSERT
AS
BEGIN
    DECLARE @currentDate VARCHAR(50)
    SET @currentDate = CONVERT(VARCHAR(20),GETDATE(),120)
    PRINT 'DATA SI ORA OPERATIEI:' + @currentDate + '|TIP OPERATIE: INSERT |NUME TABEL: MENU'  
END
GO

CREATE TRIGGER DeleteMenuTrigger
ON Menu
AFTER Delete
AS
BEGIN
    DECLARE @currentDate VARCHAR(50)
    SET @currentDate = CONVERT(VARCHAR(20),GETDATE(),120)
    PRINT 'DATA SI ORA OPERATIEI:' + @currentDate + '|TIP OPERATIE: DELETE |NUME TABEL: MENU'  
END
GO

DELETE FROM MENU WHERE name_product = 'test2'




