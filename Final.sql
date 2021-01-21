create table bankaSehir(
sehirId int IDENTITY(1,1) not null,
Sehir varchar (15),
primary key (sehirId));

create table bankaSube(
subeId int IDENTITY(1,1) not null,
Sube varchar(10),
primary key (subeId),
);

create table calisan(
calisanId int IDENTITY(1,1) not null,
ad varchar(15),
soyad varchar(20),
primary key (calisanId),
);

create table musteri(
musteriNo int IDENTITY(1,1) not null,
ad varchar(15),
soyad varchar(20),
primary key (musteriNo),
);


insert into bankaSehir (Sehir) VALUES ('Ýstanbul')
insert into bankaSehir (Sehir) VALUES ('Ýzmir')
insert into bankaSehir (Sehir) VALUES ('Balýkesir')

insert into bankaSube (Sube) VALUES ('Pendik')
insert into bankaSube (Sube) VALUES ('Güzelyalý')
insert into bankaSube (Sube) VALUES ('Fatih')
insert into bankaSube (Sube) VALUES ('Susurluk')

insert into calisan (ad,soyad) VALUES ('Ahmet', 'Demir')
insert into calisan (ad,soyad) VALUES ('Ayþe', 'Yýlmaz')
insert into calisan (ad,soyad) VALUES ('Berat', 'Kývýlcým')
insert into calisan (ad,soyad) VALUES ('Bora', 'Albayrak')
insert into calisan (ad,soyad) VALUES ('Melisa', 'Çolak')


insert into musteri (ad,soyad) VALUES ('Murat', 'Pala')
insert into musteri (ad,soyad) VALUES ('Tuðçe', 'Kanberk')
insert into musteri (ad,soyad) VALUES ('Hatice', 'Karademir')
insert into musteri (ad,soyad) VALUES ('Asya', 'Aldemir')
insert into musteri (ad,soyad) VALUES ('Egemen', 'Dur')
insert into musteri (ad,soyad) VALUES ('Emre', 'Kýsa')
insert into musteri (ad,soyad) VALUES ('Emre', 'Ardýçoðlu')
insert into musteri (ad,soyad) VALUES ('Burak', 'Murat')
insert into musteri (ad,soyad) VALUES ('Ali', 'Þaban')

SELECT*FROM dbo.bankaSehir
SELECT*FROM dbo.bankaSube
SELECT*FROM dbo.calisan
SELECT*FROM dbo.musteri


SELECT dbo.bankasehir.sehirId,Sehir,dbo.bankaSube.subeId,Sube,dbo.calisan.calisanId,dbo.calisan.ad,dbo.calisan.soyad,musteriNo,dbo.musteri.ad,dbo.musteri.soyad 
FROM dbo.bankaSehir, dbo.bankaSube, dbo.calisan, dbo.musteri 
WHERE dbo.bankaSehir.sehirId=dbo.bankaSube.sehirId AND dbo.bankaSube.subeId=dbo.calisan.subeId AND dbo.calisan.calisanId=dbo.musteri.calisanId
ORDER BY dbo.bankaSehir.sehirId



CREATE PROCEDURE deneme
AS
SELECT M.ad, M.soyad, SU.Sube FROM musteri M INNER JOIN bankaSube SU
ON M.musteriNo = SU.subeId


execute deneme



CREATE PROCEDURE deneme2
(
   @ad varchar(15),
   @soyad varchar(20)
   )
   AS
   BEGIN
   INSERT INTO calisan(ad, soyad)
   VALUES (@ad, @soyad)
   END

   execute deneme2
   
   'Fatih','Ýpek'


   --Index Rebuild---

   DECLARE @Database VARCHAR(255)  
DECLARE @Table VARCHAR(255) 
DECLARE @cmd NVARCHAR(500) 
DECLARE @fillfactor INT
SET @fillfactor = 30
DECLARE DatabaseCursor CURSOR FOR
SELECT name FROM master.dbo.sysdatabases  
WHERE name  IN ('calisan')  
ORDER BY 1 
OPEN DatabaseCursor 
FETCH NEXT FROM DatabaseCursor INTO @Database
WHILE @@FETCH_STATUS = 0 
BEGIN
   SET @cmd = 'DECLARE TableCursor CURSOR FOR SELECT ''['' + table_catalog + ''].['' + table_schema + ''].['' +
  table_name + '']'' as tableName FROM [' + @Database + '].INFORMATION_SCHEMA.TABLES
  WHERE table_type = ''BASE TABLE''' 
   -- create table cursor 
   EXEC (@cmd) 
   OPEN TableCursor  
   FETCH NEXT FROM TableCursor INTO @Table 
   WHILE @@FETCH_STATUS = 0  
   BEGIN 
       IF (@@MICROSOFTVERSION / POWER(2, 24) >= 9)
       BEGIN
           -- SQL 2005 or higher command
           SET @cmd = 'ALTER INDEX ALL ON ' + @Table + ' REBUILD WITH (FILLFACTOR = ' + CONVERT(VARCHAR(3),@fillfactor) + ')'
           EXEC (@cmd)
       END
       ELSE
       BEGIN
          -- SQL 2000 command
          DBCC DBREINDEX(@Table,' ',@fillfactor) 
       END
       FETCH NEXT FROM TableCursor INTO @Table 
   END 
   CLOSE TableCursor  
   DEALLOCATE TableCursor 
   FETCH NEXT FROM DatabaseCursor INTO @Database
END
CLOSE DatabaseCursor  
DEALLOCATE DatabaseCursor
