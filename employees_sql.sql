CREATE TABLE departments(
	dept_no VARCHAR PRIMARY KEY,
	dept_name VARCHAR
);

CREATE TABLE titles(
	title_id VARCHAR PRIMARY KEY,
	title VARCHAR NOT NULL
);

CREATE TABLE employees(
	emp_no INT PRIMARY KEY NOT NULL,
	emp_title_id VARCHAR NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	sex VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	FOREIGN KEY (emp_title_id) REFERENCES titles(title_id)
);


CREATE TABLE dept_emp(
	emp_no INT NOT NULL,
	dept_no VARCHAR NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);


CREATE TABLE salaries(
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

CREATE TABLE dept_manager(
	dept_no VARCHAR NOT NULL,
	emp_no INT NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);



--- QEURIES AND ANALYSIS

---List the employee number, last name, first name, sex, and salary of each employee.

SELECT 
	e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM 
	employees as e
JOIN 
	salaries as s ON e.emp_no = s.emp_no;


---List the first name, last name, and hire date for the employees who were hired in 1986.

SELECT
	first_name, last_name, hire_date
FROM 
	employees
WHERE
	date_part('year', hire_date) = 1986;


/*---List the manager of each department along with their department number,
department name, employee number, last name, and first name.*/


SELECT 
	m.dept_no, m.emp_no, d.dept_name, e.last_name, e.first_name
FROM
	dept_manager as m
JOIN
	departments as d ON m.dept_no = d.dept_no
JOIN
	employees as e ON m.emp_no = e.emp_no;
	
/*---List the department number for each employee along with that employee’s employee number,
last name,first name, and department name.*/

SELECT 
	de.dept_no, de.emp_no, e.last_name, e.first_name, d.dept_name
FROM
	dept_emp as de
JOIN
	employees as e ON de.emp_no = e.emp_no
JOIN 
	departments as d ON de.dept_no = d.dept_no;

/*---List first name, last name, and sex of each employee whose first name is Hercules
and whose last name begins with the letter B.*/

SELECT
	first_name, last_name, sex
FROM
	employees
WHERE
	first_name = 'Hercules' AND last_name LIKE 'B%';
	
---List each employee in the Sales department, including their employee number, last name, and first name.

SELECT 
	emp_no, last_name, first_name
FROM
	employees
WHERE
	emp_no IN
		
		(SELECT 
			emp_no
		FROM 
			dept_emp
		WHERE
			dept_no IN
		 
				(SELECT 
					dept_no
				FROM 
					departments
				WHERE
					dept_name = 'Sales')
);
		
/*---List each employee in the Sales and Development departments, including their employee number,
last name, first name, and department name.*/

SELECT 
	e.emp_no, e.last_name, e.first_name, d.dept_name
FROM 
	employees as e
JOIN
	dept_emp as de ON e.emp_no = de.emp_no
JOIN
	departments as d ON de.dept_no = d.dept_no
WHERE
	d.dept_name = 'Sales' OR d.dept_name = 'Development';

/*---List the frequency counts, in descending order, of all the employee last names
(that is, how many employees share each last name).*/

SELECT 
	last_name, COUNT(*) as last_name_frequency
FROM
	employees
GROUP BY 
	last_name
ORDER BY 
	last_name_frequency DESC;