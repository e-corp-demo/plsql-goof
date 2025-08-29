-- This procedure is designed to demonstrate hardcoded credentials.
-- SonarQube's security analysis should flag this as a critical issue.

CREATE OR REPLACE PROCEDURE connect_to_legacy_system AS
-- Hardcoded username and password are a severe security vulnerability.
c_username CONSTANT VARCHAR2(20) := 'admin';
c_password CONSTANT VARCHAR2(20) := 'LegacyPass123!';
v_connection_string VARCHAR2(100);
BEGIN
-- In a real-world scenario, this would be used to establish a connection.
v_connection_string := 'jdbc:oracle:thin:@server:1521:orcl';

DBMS_OUTPUT.PUT_LINE('Attempting to connect with hardcoded credentials.');
DBMS_OUTPUT.PUT_LINE('Username: ' || c_username);
DBMS_OUTPUT.PUT_LINE('Password: ' || c_password);

-- Dummy logic to simulate a connection attempt.
IF c_username IS NOT NULL AND c_password IS NOT NULL THEN
DBMS_OUTPUT.PUT_LINE('Connection to ' || v_connection_string || ' successful.');
ELSE
DBMS_OUTPUT.PUT_LINE('Connection failed.');
END IF;
END;
/