-- This file contains a variety of intentionally flawed PL/SQL code
-- to demonstrate SonarQube's detection capabilities for a range of issues.

-- Issue 1: %TYPE and %ROWTYPE should not be used in package specification.
-- This practice can create compile-time dependencies that are difficult to manage.
CREATE OR REPLACE PACKAGE customer_pkg AS
-- SonarQube should flag the following line:
TYPE customer_rec_type IS RECORD (
id customer.customer_id%TYPE,
name customer.customer_name%TYPE
);
v_customer_rec customer_rec_type;

-- A better approach would be to use explicit data types or a TYPE defined in the package body.
PROCEDURE process_customer_data;
END customer_pkg;
/

-- Issue 2: "CASE" should be used rather than "DECODE".
-- DECODE is non-standard and less readable than the ANSI SQL standard CASE statement.
CREATE OR REPLACE FUNCTION get_order_status_description (
p_status_code IN VARCHAR2
) RETURN VARCHAR2 IS
BEGIN
-- SonarQube should flag this use of DECODE
RETURN DECODE(p_status_code,
'P', 'Pending',
'S', 'Shipped',
'C', 'Canceled',
'Unknown Status' -- The "default" value
);
END;
/

-- Issue 3: COMMIT and ROLLBACK should not be called from a non-autonomous transaction trigger.
-- This can cause an ORA-04092 error and break the parent transaction.
CREATE OR REPLACE TRIGGER trg_employee_audit
AFTER INSERT OR UPDATE ON employees
FOR EACH ROW
BEGIN
-- SonarQube should flag this line. A COMMIT or ROLLBACK inside a DML trigger
-- is an anti-pattern.
COMMIT;

-- Add some dummy audit logic
INSERT INTO employee_audit (employee_id, change_date)
VALUES (:NEW.employee_id, SYSDATE);

EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Error in trigger: ' || SQLERRM);
-- SonarQube should also flag this ROLLBACK.
ROLLBACK;
END;
/

-- Issues 4 & 5: Cipher algorithms should be robust. Neither DES (Data Encryption Standard)
-- nor DESede (3DES) should be used.
-- These algorithms are considered weak and insecure.
CREATE OR REPLACE PROCEDURE encrypt_sensitive_data (
p_data IN VARCHAR2
) AS
v_key RAW(128) := DBMS_CRYPTO.RANDOMBYTES(16); -- 16 bytes for DES
v_encrypted_raw RAW(2000);
BEGIN
-- SonarQube should flag this use of the DES algorithm.
v_encrypted_raw := DBMS_CRYPTO.ENCRYPT(
src => UTL_I18N.STRING_TO_RAW(p_data, 'AL32UTF8'),
typ => DBMS_CRYPTO.DES + DBMS_CRYPTO.CHAIN_CBC + DBMS_CRYPTO.PAD_PKCS5,
key => v_key
);

DBMS_OUTPUT.PUT_LINE('Data encrypted using DES.');
END;
/

-- Issue 6: Weak cryptographic hash algorithms should not be used.
-- MD4, MD5, and SHA1 are considered cryptographically broken.
CREATE OR REPLACE PROCEDURE hash_data_with_weak_algorithms (
p_data IN VARCHAR2
) AS
v_raw_data RAW(2000);
BEGIN
v_raw_data := UTL_I18N.STRING_TO_RAW(p_data, 'AL32UTF8');

-- SonarQube should flag the use of MD4
DBMS_OUTPUT.PUT_LINE('Hashing with MD4: ' || DBMS_CRYPTO.Hash(v_raw_data, DBMS_CRYPTO.HASH_MD4));

-- SonarQube should flag the use of MD5
DBMS_OUTPUT.PUT_LINE('Hashing with MD5: ' || DBMS_CRYPTO.Hash(v_raw_data, DBMS_CRYPTO.HASH_MD5));

-- SonarQube should flag the use of SHA1
DBMS_OUTPUT.PUT_LINE('Hashing with SHA1: ' || DBMS_CRYPTO.Hash(v_raw_data, DBMS_CRYPTO.HASH_SH1));
END;
/