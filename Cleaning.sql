

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


INSERT INTO Media_Data 
SELECT * FROM Netflix_table 

---Columns with multiple values were moved to separate tables.---
  
	CREATE TABLE Casts( 
						id INT IDENTITY(1,1) PRIMARY KEY, 
						cast_id INT , 
						cast_name VARCHAR(90), 
						show_id VARCHAR(10) FOREIGN KEY (show_id) REFERENCES Media_Data(show_id) 
						) 
   CREATE TABLE Countries ( 
						country_id INT IDENTITY(1,1) PRIMARY KEY, 
						country_name VARCHAR(20) , 
						show_id VARCHAR(10) FOREIGN KEY (show_id) REFERENCES Media_Data(show_İd), 
						) 
   CREATE TABLE Countries (  
						id INT IDENTITY(1,1) PRIMARY KEY 
						country_id INT, 
						country_name VARCHAR(50), 
						show_id VARCHAR(10), 
						FOREIGN KEY (show_id) REFERENCES Media_Data(show_id) 
						) 
   CREATE TABLE Genre( 
						id INT IDENTITY(1,1) PRIMARY KEY, 
						genre_id INT, 
						genre_name VARCHAR(40), 
						show_id VARCHAR(10) FOREIGN KEY(show_id) REFERENCES Media_Data(show_id) 
						) 
   CREATE TABLE Director( 
						id INT IDENTITY(1,1) PRIMARY KEY, 
						director_id INT , 
						show_id VARCHAR(10) FOREIGN KEY (show_id) REFERENCES Media_Data(show_id), 
						director_name VARCHAR(90) 
						) 

---Data was transferred to the relevant tables---
  
	INSERT INTO Casts(cast_id,cast_name,show_id) 
	SELECT DENSE_RANK() OVER( ORDER BY TRIM(Value)), 
			TRIM(Value), 
			show_id 
	FROM Media_Data 
	CROSS APPLY STRING_SPLIT(Casts,',') 
		
	INSERT INTO Countries (country_id,country_name,show_id)  
	SELECT DENSE_RANK() OVER(ORDER BY TRIM(Value)), 
			TRIM(Value) as Country, 
			show_id  
	FROM Media_Data  
	CROSS APPLY STRING_SPLIT(country,',') 
		
	INSERT INTO Genre (genre_id,genre_name,show_id) 
	SELECT DENSE_RANK() OVER (ORDER BY TRIM(Value)), 
			TRIM(Value), 
			show_id  
	FROM Media_Data 
	CROSS APPLY STRING_SPLIT(listed_in,',') 
		
	INSERT INTO Director (director_id,show_id ,director_name) 
	SELECT DENSE_RANK() OVER (ORDER BY TRIM(Value)), 
			show_id , 
			TRIM(Value) 
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




