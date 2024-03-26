1) ÖRNEK SORU: Yazar tablosunu KEMAL UYUMAZ isimli yazarı ekleyin.
    INSERT INTO yazar (yazarad,yazarsoyad)
    VALUES ('KEMAL','UYUMAZ')


	2) Biyografi türünü tür tablosuna ekleyiniz.
	    INSERT INTO tur (turadi)
        VALUES ('BIYOGRAFI TURU')


	3) 10A sınıfı olan ÇAĞLAR ÜZÜMCÜ isimli erkek, sınıfı 9B olan LEYLA ALAGÖZ isimli kız ve sınıfı 11C olan Ayşe Bektaş isimli kız öğrencileri tek sorguda ekleyin.
        INSERT INTO ogrenci (ograd , ogrsoyad , cinsiyet , sinif)
         VALUES ('CAGLAR' , 'UZUMCU','E','10A'),
       ('LEYLA' , 'ALAGOZ','K','9B'),
       ('AYSE' , 'BEKTAS' , 'K' , '11C');

	4) Öğrenci tablosundaki rastgele bir öğrenciyi yazarlar tablosuna yazar olarak ekleyiniz.
    INSERT INTO yazar(yazarad,yazarsoyad)
   SELECT ograd , ogrsoyad FROM ogrenci
   ORDER BY RAND()
   LIMIT 1;

	5) Öğrenci numarası 10 ile 30 arasındaki öğrencileri yazar olarak ekleyiniz.
    INSERT INTO yazar(yazarad,yazarsoyad)
   SELECT ograd , ogrsoyad FROM ogrenci
   WHERE ogrno > 10 AND ogrno < 30

	6) Nurettin Belek isimli yazarı ekleyip yazar numarasını yazdırınız.
	(Not: Otomatik arttırmada son arttırılan değer @@IDENTITY değişkeni içinde tutulur.)
    INSERT INTO yazar (yazarad, yazarsoyad)
   VALUES ('Nurettin', 'Belek')
   SELECT @IDENTITY yazarno;


	7) 10B sınıfındaki öğrenci numarası 3 olan öğrenciyi 10C sınıfına geçirin.
    UPDATE ogrenci
   SET sinif = '10C'
   WHERE ogrno =3

	8) 9A sınıfındaki tüm öğrencileri 10A sınıfına aktarın
    UPDATE ogrenci
    SET sinif ='10A'
    WHERE sinif = '9A'

	9) Tüm öğrencilerin puanını 5 puan arttırın.
    UPDATE ogrenci
    SET puan = puan +5


	10) 25 numaralı yazarı silin.
    DELETE FROM yazar WHERE yazarno = 25

	11) Doğum tarihi null olan öğrencileri listeleyin. (insert sorgusu ile girilen 3 öğrenci listelenecektir)
    SELECT * FROM ogrenci
    WHERE dtarih IS NULL
    LIMIT 3;

	12) Doğum tarihi null olan öğrencileri silin.
    DELETE FROM ogrenci WHERE dtarih IS NULL

	13) Kitap tablosunda adı a ile başlayan kitapların puanlarını 2 artırın.
    UPDATE kitap
    SET puan = puan+2
    WHERE kitapadi LIKE 'a%'

	14) Kişisel Gelişim isimli bir tür oluşturun.
    INSERT INTO tur (turadi)
    VALUES('Kisisel Gelisim')

	15) Kitap tablosundaki Başarı Rehberi kitabının türünü bu tür ile değiştirin.
    UPDATE kitap
    SET turno = {SELECT turno FROM tur WHERE turadi ='Kisisel Gelisim'}
    WHERE kitapadi ='Başarı Rehberi'

	16) Öğrenci tablosunu kontrol etmek amaçlı tüm öğrencileri görüntüleyen "ogrencilistesi" adında bir prosedür oluşturun.
    CREATE FUNCTION ogrenciListesi()
    RETURNS SETOFF ogrenci
    LANGUAGE 'sql'
    AS $BODY$
        SELECT * FROM ogrenci
    $BODY$

	17) Öğrenci tablosuna yeni öğrenci eklemek için "ekle" adında bir prosedür oluşturun.
    CREATE PROCEDURE ekle(
     	IN ogrno bigint
     	IN ograd character varying,
     	IN ogrsoyad character varying,
     	IN cinsiyet character,
     	IN dtarih character varying,
     	IN sinif character varying ,
     	IN puan bigint
     )
     LANGUAGE 'sql'
     AS $BODY$
     	INSERT INTO ogrenci(ogrno,ograd,ogrsoyad,cinsiyet,dtarih,sinif,puan)
     	VALUES(ogrno,ograd,ogrsoyad,cinsiyet,dtarih,sinif,puan)
     $BODY$;

     CALL ekle(77,'Eda','Kalayciogu','K','13.11','0923',75);

	18) Öğrenci noya göre öğrenci silebilmeyi sağlayan "sil" adında bir prosedür oluşturun.
    CREATE PROCEDURE sil(IN ogrenciNo bigint)
    LANGUAGE 'sql'
    AS $BODY$
         	DELETE FROM ogrenci
         	WHERE ogrno = ogrenciNo
         $BODY$;

    CALL sil(5);


	19) Öğrenci numarasını kullanarak kolay bir biçimde öğrencinin sınıfını değiştirebileceğimiz bir prosedür oluşturun.
    CREATE PROCEDURE changeClass(IN ogrenciNo bigint , IN class character varying)
    LANGUAGE 'sql'
    AS $BODY$
    UPDATE ogrenci
    SET class = sinif
    WHERE ogrenciNo = ogrno
    $BODY$

    CALL changeClass(2,'11C');

	20) Öğrenci adı ve soyadını "Ad Soyad" olarak birleştirip, ad soyada göre kolayca arama yapmayı sağlayan bir prosedür yazın.
    CREATE PROCEDURE searchOgr(IN fullName character varying)
    LANGUAGE 'sql'
        AS $BODY$
           SELECT * FROM ogrenci
           WHERE CONCAT(ogrenciAd , ogrenciSoyad)
           ILIKE CONCAT('%',fullName, '%')
        $BODY$


	21) Daha önceden oluşturduğunu tüm prosedürleri silin.
    DROP PROCEDURE IF EXISTS 'ekle'
     DROP PROCEDURE IF EXISTS 'sil'
     DROP PROCEDURE IF EXISTS 'changeClass'
     DROP PROCEDURE IF EXISTS 'searchOgr'


	#Esnek görevler (Esnek görevlerin hepsini Select in Select ile gerçekleştirmeniz beklenmektedir.)
	22) Select in select yöntemiyle dram türündeki kitapları listeleyiniz.
    SELECT * FROM kitap
    WHERE turno = (SELECT turno FROM tur WHERE turadi ='Dram')

	23) Adı e harfi ile başlayan yazarların kitaplarını listeleyin.
    SELECT *
    FROM kitap
    WHERE yazarno IN (SELECT yazarno FROM yazar WHERE yazarad LIKE 'E%' );

	24) Kitap okumayan öğrencileri listeleyiniz.
    SELECT * FROM ogrenci WHERE ogrno NOT IN (SELECT ogrno FROM islem)

	25) Okunmayan kitapları listeleyiniz
    SELECT * FROM kitap WHERE kitapno NOT IN (SELECT kitapno FROM islem)

	26) Mayıs ayında okunmayan kitapları listeleyiniz.
    SELECT * FROM kitap
    WHERE kitapno IN (SELECT kitapno FROM islem WHERE
    EXTRACT (MONTH FROM atarih::timestamp) != 5
    AND
    EXTRACT (MONTH FROM vtarih::timestamp) != 5)