CREATE TABLE Employees (
	employee_id INT PRIMARY KEY,
	first_name VARCHAR (20),
	last_name VARCHAR (30),
	birth_day DATE,
	salary INT,
	branch_id INT
);

CREATE TABLE Branch (
	branch_id INT PRIMARY KEY,
	branch_name VARCHAR (40),
	manager_id INT,
	manager_start_date DATE,
	FOREIGN KEY (manager_id) 
		REFERENCES Employees (employee_id) ON DELETE SET NULL 
);

ALTER TABLE Employees
	ADD FOREIGN KEY (branch_id) 
		REFERENCES Branch (branch_id) ON DELETE SET NULL;

CREATE TABLE Client (
	client_id INT PRIMARY KEY,
	client_name VARCHAR (20),
	branch_id INT,
	FOREIGN KEY (branch_id) 
		REFERENCES Branch (branch_id) ON DELETE SET NULL   
);

CREATE TABLE Works_with (
	employee_id INT,
	client_id INT,
	total_sales INT,
	PRIMARY KEY (employee_id, client_id),
	FOREIGN KEY (employee_id) 
		REFERENCES Employees (employee_id) ON DELETE CASCADE,
	FOREIGN KEY (client_id) 
		REFERENCES Client (client_id) ON DELETE CASCADE   
);

CREATE TABLE Branch_supplier (
	branch_id INT,
	supplier_name VARCHAR (20),
	supply_type VARCHAR (30),
	PRIMARY KEY (branch_id, supplier_name),
	FOREIGN KEY (branch_id) 
		REFERENCES Branch (branch_id) ON DELETE CASCADE
);

INSERT INTO Employees
	VALUES  (100, "Tony", "Stark", '1974-07-03', 100000, NULL),
			(101, "Steven", "Rogers", '1917-03-17', 80000, NULL),
			(102, "Natalia", "Romanoff", '1983-01-25', 60000, NULL),
			(103, "Steven", "Strange", '1978-11-29', 83000, NULL),
			(104, "Peter", "Parker", '1999-12-08', 52000, NULL);
	
INSERT INTO Branch 
	VALUES  (1, "Parent company, NY", 100, '2008-10-05'),
			(2, "Canadian division", 103, '2020-02-01'),
			(3, "Los Angeles division", 102, '2012-04-30');
		
INSERT INTO Branch 
	VALUES  (4, "London division", NULL, NULL);
			
UPDATE Employees SET branch_id = 1 
	WHERE employee_id = 100;
	
UPDATE Employees SET branch_id = 1 
	WHERE employee_id = 102;
	
UPDATE Employees SET branch_id = 2 
	WHERE employee_id = 101;
	
UPDATE Employees SET branch_id = 2 
	WHERE employee_id = 103;
	
UPDATE Employees SET branch_id = 3 
	WHERE employee_id = 104;
	
INSERT INTO Client
	VALUES  (1, "Stark Industries", 1),
			(2, "Pym Technologies", 3),
			(3, "OSCORP", 1),
			(4, "Parker Industries", 1),
			(5, "Rand Corporation", 3),
			(6, "Weapon Plus", 2);
			
INSERT INTO Works_with 
	VALUES  (100, 3, 58000),
			(100, 5, 18000),
			(101, 3, 25000),
			(101, 6, 15000),
			(101, 5, 88000),
			(102, 4, 17800),
			(103, 1, 30000),
			(103, 6, 11000),
			(103, 2, 71000),
			(104, 1, 2000);
			
INSERT INTO Branch_supplier 
	VALUES  (1, "Office3", "Writing utensils"),
			(1, "PaperWorld", "Paper"),
			(3, "Step", "Writing utensils"),
			(2, "Novator", "Paper"),
			(3, "OPT", "Paper"),
			(2, "Office3", "Writing utensils");

-- Find all employeers, branches, clients, branch suppliers		
SELECT * FROM Employees;
SELECT * FROM Branch;
SELECT * FROM Client;
SELECT * FROM Branch_supplier;

-- Find all employees ordered by salary
SELECT * FROM Employees 
	ORDER BY salary;
SELECT * FROM Employees 
	ORDER BY salary DESC;

-- Find all employees ordered by branch then name
SELECT * FROM Employees 
	ORDER BY branch_id, first_name, last_name;

-- Find the first 3 employees in the table
SELECT * FROM Employees 
	limit 3;

-- Find the first and last names of employees
SELECT first_name, last_name FROM Employees; 

-- Find the forename and surname of all employees
SELECT first_name AS forename, last_name AS surname FROM Employees; 

-- Find out all different branches in Employees table
SELECT DISTINCT branch_id FROM Employees;

-- Find the number of employees
SELECT COUNT(employee_id) FROM Employees;

-- Find number of employees born after 1975
SELECT COUNT(employee_id) FROM employees 
	WHERE birth_day > '1975-01-01';
	
-- Find the average of all employee's salaries
SELECT AVG(salary) FROM Employees;

-- Find the sum of all employee's salaries
SELECT SUM(salary) FROM Employees;

-- Find out how many employees are in each branch
SELECT COUNT(employee_id), branch_id FROM Employees
	GROUP BY branch_id;
	
-- Find the total sales of each salesman
SELECT SUM(total_sales), employee_id FROM Works_with
	GROUP BY employee_id;

-- Find clients who are an 'Industries'
SELECT * FROM Client
	WHERE client_name LIKE "%Industries";

-- Find clients who are an 'ark'
SELECT * FROM Client
	WHERE client_name LIKE "%ark%";
SELECT * FROM Client
	WHERE client_name LIKE "_ark%";

-- Find employees born in November
SELECT * FROM Employees 
	WHERE birth_day LIKE '_____11___';

-- Find branche that is division
SELECT * FROM Branch 
	WHERE branch_name LIKE '%division';

-- Find a list of employee and branch names
SELECT first_name FROM Employees
	UNION
SELECT branch_name FROM Branch;

-- Find a list of all clients and brench suppliers' names
SELECT client_name FROM Client
	UNION
SELECT supplier_name FROM Branch_supplier;

-- Find a list of all money spend or earned by the company
SELECT total_sales FROM Works_With
	UNION
SELECT salary FROM Employees;
	
-- Find branches and names of their managers
SELECT Branch.branch_name, Employees.first_name, Employees.last_name FROM Branch
	JOIN Employees ON Employees.employee_id = Branch.manager_id;
	
-- Find all branches and names of their managers
SELECT Branch.branch_name, Employees.first_name, Employees.last_name FROM Branch
	LEFT JOIN Employees ON Employees.employee_id = Branch.manager_id;
	
-- Find branches and names of all employees, including their managers
SELECT Branch.branch_name, Employees.first_name, Employees.last_name FROM Branch
	RIGHT JOIN Employees ON Employees.employee_id = Branch.manager_id;
	
-- Find names of all employees who have sold over 30000 to a single client
SELECT first_name, last_name FROM Employees 
	WHERE employee_id IN(
		SELECT employee_id FROM Works_with  
			WHERE total_sales > 30000
		);

-- Find all clients who are hendled by the branch that Steven Strange manages
-- (Assume you know Steven's ID)
SELECT Client.client_name FROM Client 
	WHERE Client.branch_id = (
		SELECT Branch.branch_id FROM Branch 
			WHERE Branch.manager_id = 103
	);
	
