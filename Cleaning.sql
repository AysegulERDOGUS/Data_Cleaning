

---Data was transferred to the new main table from scratch.---
  
CREATE TABLE Media_Data(
	show_id VARCHAR(10)  PRIMARY KEY ,
	type    VARCHAR(10),
	title	NVARCHAR(200),
	director  VARCHAR(250),
	casts	 NVARCHAR(1000),
	country VARCHAR(300),
	date_added	date,	
	release_year INT,
	rating	VARCHAR(15),
	duration VARCHAR(15),
	listed_in VARCHAR(250),
	description VARCHAR(400)
				)


INSERT INTO Media_Data(  show_id,
	type   ,
	title	,
	director  ,
	casts	,
	country ,
	date_added	,
	release_year ,
	rating	,
	duration ,
	listed_in ,
	description 
 )
SELECT * FROM Netflix_table

---Columns with multiple values were moved to separate tables.---
  
	CREATE TABLE Casts(
		cast_id INT IDENTITY(1,1) PRIMARY KEY,
		show_id VARCHAR(10) FOREIGN KEY (show_id) REFERENCES Media_Data(show_id),
		cast_name VARCHAR(90)
			         )

CREATE TABLE Countries (
		country_id INT IDENTITY(1,1) PRIMARY KEY,
		country_name VARCHAR(20) ,
		show_id VARCHAR(10) FOREIGN KEY (show_id) REFERENCES Media_Data(show_İd),
   )

CREATE TABLE Genre (
		genre_id int IDENTITY(1,1) PRIMARY KEY,
		genre_name VARCHAR(40),
		show_id VARCHAR(10) FOREIGN KEY(show_id) REFERENCES Media_Data(show_id)
			         )

CREATE TABLE Director(
		director_id INT IDENTITY(1,1) PRIMARY KEY,
		show_id VARCHAR(10) FOREIGN KEY (show_id) REFERENCES Media_Data(show_id),
		director_name VARCHAR(90)
)


---Data was transferred to the relevant tables---
  
INSERT INTO Casts (cast_name ,show_id)
SELECT DISTINCT TRIM(value) AS Cast, show_id
FROM Media_Data
CROSS APPLY STRING_SPLIT(casts,',')
ORDER BY show_id ASC


INSERT INTO Countries(country_name,show_id)
SELECT DISTINCT TRIM(Value) AS Country ,show_id
FROM Media_Data
CROSS APPLY STRING_SPLIT(country,',')


INSERT INTO Genre(genre_name,show_id)
SELECT DISTINCT TRIM(VALUE) AS Genre, show_id
FROM Media_Data
CROSS APPLY STRING_SPLIT(listed_in,',')


INSERT INTO Director(director_name,show_id)
SELECT DISTINCT TRIM(Value) AS Director_name, show_id 
FROM Media_Data
CROSS APPLY STRING_SPLIT(director,',')


---Columns with multiple values were deleted from the old table---

 ALTER TABLE Media_Data
DROP COLUMN director,
			casts,
			listed_in,
			country


---Leading spaces in text were removed using the TRIM function.---

 UPDATE Media_Data
  SET show_id = TRIM(show_id),
	 type = TRIM(type),
	 title = TRIM(title) ,
	 rating = TRIM(rating),
	 duration = TRIM(duration),
	 description = TRIM(description)


---Missing and NULL values were checked---

SELECT *
FROM Media_Data
WHERE 
  show_id IS NULL OR show_id = '' OR
  type IS NULL OR type = '' OR
  title IS NULL OR  title = '' OR
  date_added IS NULL OR date_added = '' OR
  release_year IS NULL OR release_year = '' OR
  rating IS NULL OR rating = '' OR
  duration IS NULL OR duration = '' OR
  description IS NULL OR description = ''


---Incorrectly transferred data was moved to the correct columns.---

  UPDATE Media_Data
  SET duration= rating
  WHERE duration IS NULL OR duration=''

  UPDATE Media_Data
  SET rating = ''
  WHERE duration=rating


---Year data was transferred to rows with missing year values.---
  
UPDATE Media_Data
SET date_added = CONVERT (date,CAST(release_year as varchar) +'-01-01')
WHERE date_added IS NULL OR date_added=''


---The date_added column was reformatted from varchar to date for analysis.---

UPDATE N_Customers 
SET  membership_date=CONVERT(date,membership_date,101) 

ALTER TABLE N_Customers
ALTER COLUMN membership_date date




