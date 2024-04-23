-- for plsql
set serveroutput on;
--

SELECT * FROM "User";
select * from ROLE;
---- test auth user ----
DECLARE
    l_is_authenticated BOOLEAN;
BEGIN
    authenticate_user('test3', 'admin234', l_is_authenticated);

    IF l_is_authenticated THEN
        DBMS_OUTPUT.PUT_LINE('Authentication successful!');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Authentication failed.');
    END IF;
END;

---- test update user ----
DECLARE
    test_user_id RAW(16);
BEGIN
    SELECT user_id INTO test_user_id FROM "User" WHERE username = 'test3';

    update_user(test_user_id, p_email => 'da@example.com');
END;