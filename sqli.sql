-- This procedure is intentionally vulnerable to SQL Injection.
-- SonarQube should flag the use of dynamic SQL without bind variables.

CREATE OR REPLACE PROCEDURE get_employee_by_name (
p_employee_name IN VARCHAR2
) AS
v_sql_stmt VARCHAR2(200);
v_employee_id NUMBER;
v_first_name VARCHAR2(50);
v_last_name VARCHAR2(50);
BEGIN
-- Vulnerable dynamic SQL: The input parameter is concatenated directly into the query.
-- A malicious user could provide a string like 'John' OR '1'='1'--' to bypass the intended logic.
v_sql_stmt := 'SELECT employee_id, first_name, last_name FROM employees WHERE first_name = ''' || p_employee_name || '''';

DBMS_OUTPUT.PUT_LINE('Executing query: ' || v_sql_stmt);

-- Execute the vulnerable statement
EXECUTE IMMEDIATE v_sql_stmt INTO v_employee_id, v_first_name, v_last_name;

DBMS_OUTPUT.PUT_LINE('Found employee: ' || v_first_name || ' ' || v_last_name);

EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/