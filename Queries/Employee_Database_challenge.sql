SELECT * from employees

-- DELIVERABLE 1
SELECT employees.emp_no,
	employees.first_name,
	employees.last_name,
	titles.title,
	titles.from_date,
	titles.to_date
INTO employees_titles_dates
FROM employees
LEFT JOIN titles
ON employees.emp_no = titles.emp_no
WHERE (employees.birth_date BETWEEN '1952-01-01' and '1955-12-31');

SELECT * from employees_titles_dates

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (etd.emp_no) etd.emp_no,
etd.first_name,
etd.last_name,
etd.title

INTO scrubbed_employees_titles_dates
FROM employees_titles_dates AS etd
WHERE etd.to_date = '9999-01-01'
ORDER BY etd.emp_no, etd.to_date DESC;

SELECT * FROM scrubbed_employees_titles_dates;

SELECT COUNT(scrubbed_employees_titles_dates.emp_no)
FROM scrubbed_employees_titles_dates;

SELECT COUNT(scrubbed_employees_titles_dates.emp_no), scrubbed_employees_titles_dates.title
INTO retiring_titles
FROM scrubbed_employees_titles_dates
GROUP BY scrubbed_employees_titles_dates.title
ORDER BY COUNT(title) DESC;

SELECT * FROM retiring_titles;

-- DELIVERABLE 2
SELECT employees.emp_no,
	employees.first_name,
	employees.last_name,
	employees.birth_date,
	dept_emp.from_date,
	dept_emp.to_date,
	titles.title
INTO employees_dates_titles_prelim
FROM employees
	INNER JOIN dept_emp
		ON (employees.emp_no = dept_emp.emp_no)
	INNER JOIN titles
		ON (employees.emp_no = titles.emp_no)
WHERE (employees.birth_date BETWEEN '1965-01-01' and '1965-12-31')
AND (dept_emp.to_date = '9999-01-01');

SELECT DISTINCT ON (employees_dates_titles_prelim.emp_no) employees_dates_titles_prelim.emp_no,
	employees_dates_titles_prelim.first_name,
	employees_dates_titles_prelim.last_name,
	employees_dates_titles_prelim.birth_date,
	employees_dates_titles_prelim.from_date,
	employees_dates_titles_prelim.to_date,
	employees_dates_titles_prelim.title
INTO mentorship_eligibility
FROM employees_dates_titles_prelim; 

SELECT * FROM mentorship_eligibility;