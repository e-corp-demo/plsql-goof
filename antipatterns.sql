-- This function contains several bad style choices and anti-patterns.
-- SonarQube should identify issues like the use of GOTO, magic numbers, and inconsistent naming.

CREATE OR REPLACE FUNCTION calculate_bonus (
p_salary IN NUMBER
) RETURN NUMBER IS
l_bonus_amount NUMBER;
-- Inconsistent and non-descriptive variable names
x NUMBER := 0;
BEGIN
-- Unnecessary use of GOTO statement, which makes code difficult to read and maintain.
IF p_salary > 100000 THEN
GOTO high_bonus;
END IF;

-- Magic number without a constant or comment to explain its purpose.
l_bonus_amount := p_salary * 0.10;

-- End of function logic
RETURN l_bonus_amount;

<<high_bonus>>
-- Another magic number
l_bonus_amount := p_salary * 0.25;
RETURN l_bonus_amount;
END;
/