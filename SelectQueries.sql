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
WHERE isregisteredfor(courseregistration, ROW('COS326'));

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