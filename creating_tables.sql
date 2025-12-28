DROP DATABASE IF EXISTS student_cleaning;
CREATE DATABASE IF NOT EXISTS student_cleaning;
USE student_cleaning;

CREATE TABLE raw_students (
    student_name   VARCHAR(255),
    date_of_birth  VARCHAR(255),
    state          VARCHAR(100),
    mobile_number  VARCHAR(50),
    email          VARCHAR(255),
    gpa            VARCHAR(20)
);


CREATE TABLE clean_students (
    student_id     INT AUTO_INCREMENT PRIMARY KEY,
    first_name     VARCHAR(100),
    last_name      VARCHAR(100),
    date_of_birth  DATE,
    state_code     CHAR(2),
    mobile_number  CHAR(10),
    email          VARCHAR(255),
    gpa            DECIMAL(3,2)
);
