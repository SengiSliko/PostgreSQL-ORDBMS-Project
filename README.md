# PostgreSQL Object-Relational DBMS beginner project

## Overview

This project demonstrates the use of PostgreSQL as an object-relational database management system (ORDBMS).  
The focus is on implementing advanced database features such as domains, user-defined types (UDTs), sequences, table inheritance, and custom functions.  

---

## Objectives

The key objectives of this project are to:

1. Gain exposure to the PostgreSQL ORDBMS.
2. Implement:
   - Domains, user-defined types (UDTs), and sequences.
   - Tables and table inheritance.
   - Functions for database operations.
3. Understand the differences between:
   - Relational DBMS.
   - Object-oriented DBMS.
   - Object-relational DBMS.

---

## Features

### Entities and Relationships

1. **Student** (Base Entity):
   - Attributes: `studentNumber`, `name` (title, first name, surname), `dateOfBirth`, `degreeProgram`, and `yearOfStudy`.
   - Functions:  
     - `personFullNames()` - Returns the full name in the format `title firstName surname`.
     - `ageInYears()` - Computes the age of the student.

2. **Undergraduate** (inherits from Student):
   - Additional Attributes: `courseRegistration` (array of course codes).
   - Functions:  
     - `isRegisteredFor(courseCode)` - Checks if the student is registered for a specific course.  
     - `isFinalYearStudent()` - Checks if the student is in their final year of study.

3. **Postgraduate** (inherits from Student):
   - Additional Attributes: `category` (part-time/full-time) and `supervisor` (title, first name, surname).
   - Functions:  
     - `isFullTime()` - Checks if the student is full-time.  
     - `isPartTime()` - Checks if the student is part-time.

4. **DegreeProgram**:
   - Attributes: `degreeCode`, `degreeName`, `numberOfYears`, and `faculty`.

5. **Course**:
   - Attributes: `courseCode`, `courseName`, `department`, and `credits`.

---

## Tasks

### Task 1: Database Structure

- **UML Class Diagram**: A diagram showing the relationships between entities.
- **SQL Creation Statements**:
  1. Define domains and user-defined types (UDTs) using `CREATE DOMAIN` and `CREATE TYPE`.
  2. Create sequences for surrogate keys using `CREATE SEQUENCE`.
  3. Implement table inheritance using `CREATE TABLE ... INHERITS`.
  4. Define functions for operations and attribute manipulations.

### Task 2: Data Insertion

- Use `INSERT INTO` statements to populate the database with predefined data:
  - **Degree Programs**: e.g., `BSc`, `BIT`, `PhD`.
  - **Courses**: e.g., `COS301`, `COS326`, `MTH301`.
  - **Students**: Undergraduate and postgraduate with varying attributes.

### Task 3: Database Queries

- **Reports** (using `SELECT` statements and functions):
  1. List all students with personal details.
  2. Retrieve registration details of undergraduate and postgraduate students.
  3. Retrieve final-year undergraduate students' registration details.
  4. Retrieve students registered for a specific course.
  5. Retrieve full-time and part-time postgraduate students' details.

---

## How to Test

1. Create a database in PostgreSQL named `studentsDB`.
2. Execute the following SQL files in order using the pgAdmin query tool:
   - `CreateStatements.sql`: Create the database objects.
   - `InsertQueries.sql`: Insert the data into the database.
   - `SelectQueries.sql`: Run the queries to generate reports.

3. Verify the outputs for correctness.

---

## Tools and Technologies

- **PostgreSQL**: ORDBMS used for implementing and managing the database.
- **pgAdmin**: Tool for managing and querying PostgreSQL databases.
- **UML Design**: Used for visualizing the database schema and relationships.

---
