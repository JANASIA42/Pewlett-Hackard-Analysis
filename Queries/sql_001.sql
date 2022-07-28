-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
	dept_no VARCHAR(4) NOT NULL,
	dept_name VARCHAR(40) NOT NULL, 
	PRIMARY KEY (dept_no),
	UNIQUE (dept_name)
);
CREATE TABLE employees (
	emp_no INT NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	gender VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no)
);
CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);
CREATE TABLE salaries (
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no)
);
CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, title, from_date)
);
DROP TABLE dept_emp;
CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

SELECT * from departments
SELECT * from dept_emp
SELECT * from dept_manager
SELECT * from employees
SELECT * from salaries
SELECT * from titles

SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1/1/1952' and '12/31/1955')
AND (hire_date BETWEEN '1/1/1985' and '12/31/1988');

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1/1/1952' and '12/31/1952';

SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1/1/1952' and '12/31/1955')
AND (hire_date BETWEEN '1/1/1985' and '12/31/1988');

SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1/1/1952' and '12/31/1955')
AND (hire_date BETWEEN '1/1/1985' and '12/31/1988');

SELECT * FROM retirement_info;

DROP TABLE retirement_info;

-- Create new table for retiring employees.
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1/1/1952' AND '12/13/1955')
AND (hire_date BETWEEN '1/1/1985' AND '12/31/1988');

-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables.
SELECT departments.dept_name, 
	dept_manager.emp_no,
	dept_manager.from_date,
	dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Joining retirement info and dept_emp tables
SELECT retirement_info.emp_no,
	retirement_info.first_name,
	retirement_info.last_name,
	dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

SELECT retirement_info.emp_no,
	retirement_info.first_name,
	retirement_info.last_name,
	dept_emp.to_date
INTO current_emps
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no
WHERE dept_emp.to_date = ('9999-01-01');

-- Employee count by department number
SELECT COUNT(current_emps.emp_no), dept_emp.dept_no
FROM current_emps
LEFT JOIN dept_emp
ON current_emps.emp_no = dept_emp.emp_no
GROUP BY dept_emp.dept_no
ORDER BY dept_emp.dept_no;

SELECT * FROM current_emps;

SELECT * FROM salaries
ORDER BY to_date;

SELECT emp_no, first_name, last_name, gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT employees.emp_no, employees.first_name, employees.last_name, employees.gender, salaries.salary, dept_emp.to_date
INTO comp_emp_info
FROM employees
INNER JOIN salaries
ON (employees.emp_no = salaries.emp_no)
INNER JOIN dept_emp
ON (employees.emp_no = dept_emp.emp_no)
WHERE (employees.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (employees.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (dept_emp.to_date = '9999-01-01');

-- List of managers per department
SELECT  dept_manager.dept_no,
        departments.dept_name,
        dept_manager.emp_no,
        current_emps.last_name,
        current_emps.first_name,
        dept_manager.from_date,
        dept_manager.to_date
INTO manager_info
FROM dept_manager
    INNER JOIN departments
        ON (dept_manager.dept_no = departments.dept_no)
    INNER JOIN current_emps
        ON (dept_manager.emp_no = current_emps.emp_no);

SELECT current_emps.emp_no,
	current_emps.first_name,
	current_emps.last_name,
	departments.dept_name
INTO dept_info
FROM current_emps
INNER JOIN dept_emp
ON(current_emps.emp_no = dept_emp.emp_no)
INNER JOIN departments
ON (dept_emp.dept_no = departments.dept_no);

SELECT emp_no, first_name, last_name, dept_name
FROM dept_info
WHERE dept_info.dept_name = ('Sales') OR dept_info.dept_name = ('Development');

SELECT * from dept_info;


