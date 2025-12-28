-- Fixing Column by Column
SET SQL_SAFE_UPDATES = 0;


-- STEP 1: Student Name
INSERT INTO clean_students (first_name, last_name)
SELECT
    SUBSTRING_INDEX(REPLACE(REPLACE(student_name, '"',''), '''',''), ' ', 1),
    SUBSTRING_INDEX(REPLACE(REPLACE(student_name, '"',''), '''',''), ' ', -1)
FROM raw_students;

-- STEP 2: Date Of Birth
UPDATE clean_students c
JOIN raw_students r
ON c.first_name = SUBSTRING_INDEX(REPLACE(REPLACE(r.student_name,'"',''),'''',''),' ',1)
AND c.last_name  = SUBSTRING_INDEX(REPLACE(REPLACE(r.student_name,'"',''),'''',''),' ',-1)
SET c.date_of_birth =
CASE
    WHEN r.date_of_birth LIKE '%-%:%' THEN STR_TO_DATE(REPLACE(REPLACE(r.date_of_birth,'"',''),'''',''), '%m-%d-%Y %H:%i:%s')
    WHEN r.date_of_birth LIKE '%/%/%' THEN STR_TO_DATE(REPLACE(REPLACE(r.date_of_birth,'"',''),'''',''), '%m/%d/%Y')
    WHEN LENGTH(REPLACE(REPLACE(r.date_of_birth,'"',''),'''','')) = 8 THEN STR_TO_DATE(REPLACE(REPLACE(r.date_of_birth,'"',''),'''',''), '%m%d%Y')
    WHEN LENGTH(REPLACE(REPLACE(r.date_of_birth,'"',''),'''','')) = 6 THEN STR_TO_DATE(REPLACE(REPLACE(r.date_of_birth,'"',''),'''',''), '%m%d%y')
END;

-- STEP 3: State
UPDATE clean_students c
JOIN raw_students r
ON c.first_name = SUBSTRING_INDEX(REPLACE(REPLACE(r.student_name,'"',''),'''',''),' ',1)
AND c.last_name  = SUBSTRING_INDEX(REPLACE(REPLACE(r.student_name,'"',''),'''',''),' ',-1)
SET c.state_code =
CASE
    WHEN UPPER(r.state) IN ('CA','CALIFORNIA') THEN 'CA'
    WHEN UPPER(r.state) IN ('NY','NEW YORK') THEN 'NY'
    WHEN UPPER(r.state) IN ('TX','TEXAS') THEN 'TX'
    WHEN UPPER(r.state) IN ('FL','FLORIDA') THEN 'FL'
    ELSE NULL
END;

-- STEP 4: Mobile Number
UPDATE clean_students c
JOIN raw_students r
ON c.first_name = SUBSTRING_INDEX(REPLACE(REPLACE(r.student_name,'"',''),'''',''),' ',1)
AND c.last_name  = SUBSTRING_INDEX(REPLACE(REPLACE(r.student_name,'"',''),'''',''),' ',-1)
SET c.mobile_number =
RIGHT(REGEXP_REPLACE(r.mobile_number, '[^0-9]', ''), 10);

-- STEP 5: Email
UPDATE clean_students c
JOIN raw_students r
ON c.first_name = SUBSTRING_INDEX(REPLACE(REPLACE(r.student_name,'"',''),'''',''),' ',1)
AND c.last_name  = SUBSTRING_INDEX(REPLACE(REPLACE(r.student_name,'"',''),'''',''),' ',-1)
SET c.email = LOWER(r.email);


-- STEP 6: GPA
UPDATE clean_students c
JOIN raw_students r
ON c.first_name = SUBSTRING_INDEX(REPLACE(REPLACE(r.student_name,'"',''),'''',''),' ',1)
AND c.last_name  = SUBSTRING_INDEX(REPLACE(REPLACE(r.student_name,'"',''),'''',''),' ',-1)
SET c.gpa =
CASE
    WHEN r.gpa REGEXP '^[0-9]+(\\.[0-9]+)?$'
         AND r.gpa BETWEEN 0 AND 4.0
    THEN CAST(r.gpa AS DECIMAL(3,2))
    ELSE NULL
END;

SET SQL_SAFE_UPDATES = 1;
SELECT * FROM clean_students;

SELECT *
INTO OUTFILE 'D:/Projects/Messy Data Cleaning/clean_students.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM clean_students;

