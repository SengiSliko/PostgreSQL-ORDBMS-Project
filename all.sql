/* Domains */
DROP TYPE student_titles;
CREATE TYPE student_titles AS ENUM('Ms', 'Miss', 'Mrs', 'Mr', 'Mnr');
CREATE TYPE supervisor_titles AS ENUM('Ms', 'Miss', 'Mrs', 'Mr', 'Mnr', 'Dr', 'Prof');
CREATE TYPE postgrad_category AS ENUM('Part time', 'Full time');

DROP TYPE module_code_domain;
CREATE DOMAIN module_code_domain AS VARCHAR(6) 
CHECK (
    VALUE ~ '^\w{3}\d{3}$'
);

CREATE DOMAIN stud_number AS CHAR(6)
CHECK (
    VALUE ~ '^\d{6}$'
);

DROP DOMAIN person_name;
CREATE DOMAIN person_name AS VARCHAR(30) 
CHECK (
    VALUE ~ '^[A-Za-z]+$'
);

CREATE DOMAIN phrase AS VARCHAR(50) 
CHECK (
    VALUE ~ '^[A-Za-z ]*$'
);

/* Types */
DROP TYPE TypeSupervisor;
CREATE TYPE TypeSupervisor AS (
    title supervisor_titles,
    fname person_name,
    sname person_name
);

DROP TYPE Typefullnames;
CREATE TYPE Typefullnames AS (
    title student_titles,
    fname person_name,
    sname person_name
);

/* Domain arrays are unique to Postgres 11+ */
DROP TYPE module_code_type;
CREATE TYPE module_code_type AS (
    code module_code_domain 
);


/* Sequences */
CREATE SEQUENCE student_key_seq 
INCREMENT 1
MINVALUE 0 
START 0;
CREATE SEQUENCE course_key_seq 
MINVALUE 0 
INCREMENT 1 
START 0;
CREATE SEQUENCE degree_key_seq 
INCREMENT 1
MINVALUE 0  
START 0;

/* Tables */
DROP TABLE Student;
CREATE TABLE Student (
    student_key INTEGER NOT NULL DEFAULT nextval('student_key_seq'),
    student_number stud_number,
    student_name Typefullnames,
    date_of_birth DATE,
    degree_code VARCHAR(5),
    year_of_study INTEGER,
    PRIMARY KEY (student_key),
    FOREIGN KEY(degree_code) REFERENCES DegreeProgram(degree_code)
);

SELECT * from student;

DROP TABLE Undergraudate;
CREATE TABLE Undergraudate (
    courseRegistration module_code_type[],
    PRIMARY KEY(student_key)
    /* Not supported in Postgres 9 */
    /*FOREIGN KEY(EACH item of courseRegistration) REFERENCES Course*/
)
INHERITS(Student);

DROP TABLE Postgraduate;
CREATE TABLE Postgraduate (
    category postgrad_category,
    supervisor TypeSupervisor,
    PRIMARY KEY(student_key)
)
INHERITS(Student);

DROP TABLE DegreeProgram;
CREATE TABLE DegreeProgram (
    degree_key INTEGER NOT NULL DEFAULT nextval('degree_key_seq'),
    degree_code VARCHAR(5) UNIQUE NOT NULL,
    degree_name phrase,
    number_of_years INTEGER,
    faculty phrase,
    PRIMARY KEY(degree_key)
);

DROP TABLE Course;
CREATE TABLE Course (
    course_key INTEGER NOT NULL DEFAULT nextval('course_key_seq'),
    course_code module_code_domain UNIQUE NOT NULL,
    course_name phrase,
    department phrase,
    credits INTEGER,
    PRIMARY KEY(course_key)
);

/* Functions */

CREATE FUNCTION personFullNames(Typefullnames) RETURNS TEXT AS
$$
    SELECT concat($1.title,' ',$1.fname,' ', $1.sname);
$$ LANGUAGE SQL;

CREATE FUNCTION ageInYears(DATE) RETURNS INTEGER AS
$$
    DECLARE today DATE; toRet INTEGER;
    BEGIN
        RETURN EXTRACT(YEAR FROM now()) - EXTRACT(YEAR FROM $1);
    END;
$$
LANGUAGE PLPGSQL;

DROP FUNCTION isRegisteredFor(module_code_type[], module_code_type);
CREATE FUNCTION isRegisteredFor(module_code_type[], module_code_type) RETURNS BOOLEAN AS
$$
    DECLARE item module_code_type;
    BEGIN
        FOREACH item IN ARRAY $1
        LOOP 
            IF item = $2
            THEN 
                RETURN TRUE;
            END IF;
        END LOOP;
        RETURN FALSE;
    END;
$$ LANGUAGE PLPGSQL;

DROP FUNCTION isFinalYearStudent(int, int);
CREATE FUNCTION isFinalYearStudent(int, int) RETURNS BOOLEAN AS
$$
BEGIN
    IF $1 = $2
    THEN
        RETURN TRUE;    
    END IF;
    RETURN FALSE;
END;
$$
LANGUAGE PLPGSQL;

DROP FUNCTION isFullTime(postgrad_category);
CREATE FUNCTION isFullTime(postgrad_category) RETURNS BOOLEAN AS
$$
BEGIN
    RETURN $1 = 'Full time'::postgrad_category;
END;
$$ LANGUAGE PLPGSQL;

DROP FUNCTION isPartTime(postgrad_category);
CREATE FUNCTION isPartTime(postgrad_category) RETURNS BOOLEAN AS
$$
BEGIN
    RETURN $1 = 'Part time'::postgrad_category;
END;
$$ LANGUAGE PLPGSQL;

CREATE FUNCTION personFullNames(TypeSupervisor) RETURNS TEXT AS
$$
    SELECT concat($1.title,' ',$1.fname,' ', $1.sname);
$$ LANGUAGE SQL;

/* SQL Statements */
INSERT INTO DegreeProgram(degree_key, degree_code, degree_name, number_of_years, faculty) VALUES
(DEFAULT, 'BSc', 'Bachelor of Science', 3, 'EBIT'),
(DEFAULT, 'BIT', 'Bachelor of IT', 4, 'EBIT'),
(DEFAULT, 'PhD', 'Philosophiae Doctor', 5, 'EBIT');

SELECT * FROM DegreeProgram;

INSERT INTO Course(course_code, course_name, department, credits) VALUES
('COS301', 'Software Engineering', 'Computer Science', 40),
('COS326', 'Database Systems', 'Computer Science', 20),
('MTH301', 'Discrete Mathematics', 'Mathematics', 15),
('PHL301', 'Logical Reasoning', 'Philosophy', 15);

SELECT * FROM Course;

INSERT INTO Undergraudate(student_number, student_name, date_of_birth, degree_code, year_of_study,courseRegistration) 
VALUES
('140010', ROW('Mr','Liam','Burgess'),'01-10-1996','BSc',3,
    CAST (ARRAY[ROW('COS301'), ROW('COS326'), ROW('MTH301')] AS module_code_type[])),
('140015', ROW('Mnr','John','Cena'),'05-25-1995','BSc',3,
    CAST (ARRAY[ROW('COS301'), ROW('PHL301'), ROW('MTH301')] AS module_code_type[])),
('131120', ROW('Mrs','Celine','Nel'),'01-30-1995','BIT',3,
    CAST (ARRAY[ROW('COS301'), ROW('COS326'), ROW('PHL301')] AS module_code_type[])),
('131140', ROW('Ms','Rock','Afeller'),'02-20-1996','BIT',4,
    CAST (ARRAY[ROW('COS301'), ROW('COS326'), ROW('MTH301'), ROW('PHL301')] AS module_code_type[]));    


SELECT * from Undergraudate;

INSERT INTO Postgraduate(student_number, student_name, date_of_birth, degree_code, year_of_study, category, supervisor)
VALUES
('101122', ROW('Mr','John','Swanson'),'06-15-1987','PhD',2,'Full time',ROW('Dr','L','Marshall')),
('121101', ROW('Mr','Danie','Nel'),'04-27-1985','PhD',3,'Part time',ROW('Prof','P','Lutu'));

SELECT * FROM Postgraduate;

/* Demo code */
SELECT student_key, student_number as "Student Number", 
personFullNames(student_name) as "Student Name",
ageInYears(date_of_birth) as "Age in Years"
FROM Undergraudate;

SELECT student_key, student_number as "Student Number", 
personFullNames(student_name) as "Student Name",
degree_code as "Degree Code",
year_of_study as "Year of Study",
courseRegistration as "Courses"
FROM Undergraudate;

SELECT student_key, student_number as "Student Number", 
personFullNames(student_name) as "Student Name",
degree_code as "Degree Code",
year_of_study as "Year of Study",
category as "Category",
personFullNames(supervisor) as "Supervisor"
FROM Postgraduate;

SELECT student_key, student_number as "Student Number", 
personFullNames(student_name) as "Student Name",
U.degree_code as "Degree Code",
year_of_study as "Year of Study",
courseRegistration as "Courses"
FROM Undergraudate as U, DegreeProgram as D
WHERE isFinalYearStudent(U.year_of_study, D.number_of_years) AND U.degree_code = D.degree_code;

SELECT student_key, student_number as "Student Number", 
personFullNames(student_name) as "Student Name",
degree_code as "Degree Code",
year_of_study as "Year of Study",
courseRegistration as "Courses"
FROM Undergraudate
WHERE isregisteredfor(courseregistration, ROW('MTH301'));

SELECT student_key, student_number as "Student Number", 
personFullNames(student_name) as "Student Name",
degree_code as "Degree Code",
year_of_study as "Year of Study",
category as "Category",
personFullNames(supervisor) as "Supervisor"
FROM Postgraduate
WHERE isfulltime(category);

SELECT student_key, student_number as "Student Number", 
personFullNames(student_name) as "Student Name",
degree_code as "Degree Code",
year_of_study as "Year of Study",
category as "Category",
personFullNames(supervisor) as "Supervisor"
FROM Postgraduate
WHERE isparttime(category);