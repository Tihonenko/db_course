-- for plsql
set serveroutput on;
--

SELECT * FROM "User";
select * from ROLE;

--SELECT * FROM user_errors;

---- test create user ----
DECLARE
    v_user_id RAW(16);
BEGIN
    create_user('test4', 'admin1234', 'test', v_user_id);
    DBMS_OUTPUT.PUT_LINE('Новый пользователь успешно добавлен. Идентификатор пользователя: ' || v_user_id);
END;

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