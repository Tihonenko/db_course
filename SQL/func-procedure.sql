
---- create user ----
CREATE OR REPLACE PROCEDURE create_user (
    p_username IN NVARCHAR2,
    p_password IN NVARCHAR2,
    p_name IN NVARCHAR2,
    p_second_name IN NVARCHAR2 DEFAULT NULL,
    p_email IN NVARCHAR2 DEFAULT NULL,
    p_address IN NVARCHAR2 DEFAULT NULL,
    p_user_id OUT RAW 
)
AS
    p_role_id RAW(16);
    hashed_password NVARCHAR2(255); 
BEGIN
    hashed_password := hash_password(p_password);

    SELECT role_id INTO p_role_id from ROLE WHERE name = 'user';

    p_user_id := SYS_GUID();
    
    INSERT INTO "User" (user_id, username, name, second_name, email, address password, role_id)
    VALUES (p_user_id, p_username, p_name, p_second_name, p_email, p_address, hashed_password, p_role_id);
  
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE; 
END;

---- auth user ----
CREATE OR REPLACE PROCEDURE authenticate_user (
    p_username IN NVARCHAR2,
    p_password IN NVARCHAR2,
    p_is_authenticated OUT BOOLEAN
)
AS
    hashed_password NVARCHAR2(255);
BEGIN
    SELECT password INTO hashed_password
    FROM "User"
    WHERE username = p_username;

    p_is_authenticated := validate_password(p_password, hashed_password);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_is_authenticated := FALSE;
    WHEN OTHERS THEN
        p_is_authenticated := FALSE;
        RAISE;
END;


--SELECT * FROM user_errors;

---- test create user ----
DECLARE
    v_user_id RAW(16);
BEGIN
    create_user('test3', 'admin1234', 'test', v_user_id);
    DBMS_OUTPUT.PUT_LINE('Новый пользователь успешно добавлен. Идентификатор пользователя: ' || v_user_id);
END;

SELECT * FROM "User";

---- test auth user ----
DECLARE
    l_is_authenticated BOOLEAN;
BEGIN
    authenticate_user('test3', 'admin1', l_is_authenticated);

    IF l_is_authenticated THEN
        DBMS_OUTPUT.PUT_LINE('Authentication successful!');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Authentication failed.');
    END IF;
END;

