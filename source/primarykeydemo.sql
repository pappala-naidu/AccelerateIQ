CREATE TABLE Employee (
    employee_id NUMBER,
    emp_name VARCHAR(100),
    salary NUMBER,
    hire_date DATE,
    CONSTRAINT PK_Employee PRIMARY KEY (employee_id)
);

create table comapany(
com_id number,
comp_name varchar(100),
CONSTRAINT PK_company PRIMARY KEY (comp_id),
empid int FOREIGN KEY REFERENCES Employee(employee_id)
);