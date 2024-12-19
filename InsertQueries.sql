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
