/*DROP DATABASE final;*/
/*CREATE DATABASE studentsDB*/

/* Enums */ 
CREATE TYPE student_titles AS ENUM('Ms', 'Miss', 'Mrs', 'Mr', 'Mnr');
CREATE TYPE supervisor_titles AS ENUM('Ms', 'Miss', 'Mrs', 'Mr', 'Mnr', 'Dr', 'Prof');
CREATE TYPE postgrad_category AS ENUM('Part time', 'Full time');

/* Domains */
CREATE DOMAIN module_code_domain AS VARCHAR(6) 
CHECK (
    VALUE ~ '^\w{3}\d{3}$'
);

CREATE DOMAIN stud_number AS CHAR(6)
CHECK (
    VALUE ~ '^\d{6}$'
);

CREATE DOMAIN person_name AS VARCHAR(30) 
CHECK (
    VALUE ~ '^[A-Za-z]+$'
);

CREATE DOMAIN phrase AS VARCHAR(50) 
CHECK (
    VALUE ~ '^[A-Za-z ]*$'
);

/* Class Types */
CREATE TYPE TypeSupervisor AS (
    title supervisor_titles,
    fname person_name,
    sname person_name
);

CREATE TYPE Typefullnames AS (
    title student_titles,
    fname person_name,
    sname person_name
);

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
CREATE TABLE Course (
    course_key INTEGER NOT NULL DEFAULT nextval('course_key_seq'),
    course_code module_code_domain UNIQUE NOT NULL,
    course_name phrase,
    department phrase,
    credits INTEGER,
    PRIMARY KEY(course_key)
);

CREATE TABLE DegreeProgram (
    degree_key INTEGER NOT NULL DEFAULT nextval('degree_key_seq'),
    degree_code VARCHAR(5) UNIQUE NOT NULL,
    degree_name phrase,
    number_of_years INTEGER,
    faculty phrase,
    PRIMARY KEY(degree_key)
);

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

CREATE TABLE Undergraudate (
    courseRegistration module_code_type[],
    PRIMARY KEY(student_key)
    /* Not supported in Postgres 9 */
    /*FOREIGN KEY(EACH item of courseRegistration) REFERENCES Course*/
)
INHERITS(Student);

CREATE TABLE Postgraduate (
    category postgrad_category,
    supervisor TypeSupervisor,
    PRIMARY KEY(student_key)
)
INHERITS(Student);

/* Functions */
/* person full names */
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

/* is registered for */
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

/* is final year */
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

/* is full time */
CREATE FUNCTION isFullTime(postgrad_category) RETURNS BOOLEAN AS
$$
BEGIN
    RETURN $1 = 'Full time'::postgrad_category;
END;
$$ LANGUAGE PLPGSQL;

/* is part time */
CREATE FUNCTION isPartTime(postgrad_category) RETURNS BOOLEAN AS
$$
BEGIN
    RETURN $1 = 'Part time'::postgrad_category;
END;
$$ LANGUAGE PLPGSQL;

/* person full names overloaded for supervisor */
CREATE FUNCTION personFullNames(TypeSupervisor) RETURNS TEXT AS
$$
    SELECT concat($1.title,' ',$1.fname,' ', $1.sname);
$$ LANGUAGE SQL;

