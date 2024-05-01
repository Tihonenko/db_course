
---- create user ----
CREATE OR REPLACE PROCEDURE create_user (
    p_login IN NVARCHAR2,
    p_password IN NVARCHAR2,
    p_name IN NVARCHAR2,
    p_second_name IN NVARCHAR2 DEFAULT NULL,
    p_email IN NVARCHAR2 DEFAULT NULL,
    p_address IN NVARCHAR2 DEFAULT NULL,
    p_user_id OUT RAW 
)
AS
    p_role_id NVARCHAR2(255);
    hashed_password NVARCHAR2(255);
BEGIN
    hashed_password := hash_password(p_password);

    SELECT role_id INTO p_role_id from ROLE WHERE name = 'user';

    p_user_id := UTL_ENCODE.base64_encode(SYS_GUID());
    
    INSERT INTO "User" (user_id, login, name, second_name, email, address, password, role_id)
    VALUES (p_user_id, p_login, p_name, p_second_name, p_email, p_address, hashed_password, p_role_id);
  
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE; 
END;

---- auth user ----
CREATE OR REPLACE PROCEDURE authenticate_user (
    p_login IN NVARCHAR2,
    p_password IN NVARCHAR2,
    p_is_authenticated OUT BOOLEAN
)
AS
    hashed_password NVARCHAR2(255);
BEGIN
    SELECT password INTO hashed_password
    FROM "User"
    WHERE login = p_login;

    p_is_authenticated := validate_password(p_password, hashed_password);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_is_authenticated := FALSE;
    WHEN OTHERS THEN
        p_is_authenticated := FALSE;
        RAISE;
END;

---- update user ----
CREATE OR REPLACE PROCEDURE update_user (
    p_user_id IN RAW,
    p_name IN NVARCHAR2 DEFAULT NULL,
    p_second_name IN NVARCHAR2 DEFAULT NULL,
    p_email IN NVARCHAR2 DEFAULT NULL,
    p_address IN NVARCHAR2 DEFAULT NULL
)
AS
BEGIN
    UPDATE "User"
    SET 
        name = COALESCE(p_name, name),
        second_name = COALESCE(p_second_name, second_name),
        email = COALESCE(p_email, email),
        address = COALESCE(p_address, address)
    WHERE user_id = p_user_id;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;

---- update user password
CREATE OR REPLACE PROCEDURE change_password (
    p_user_id IN NVARCHAR2,
    p_old_password IN NVARCHAR2,
    p_new_password IN NVARCHAR2
)
AS
    stored_password RAW(64);
    is_authenticated BOOLEAN;
BEGIN
    SELECT password INTO stored_password
    FROM "User"
    WHERE user_id = p_user_id;

    is_authenticated := validate_password(p_old_password, stored_password);

    IF is_authenticated THEN
        stored_password := hash_password(p_new_password);
        UPDATE "User"
        SET password = stored_password
        WHERE user_id = p_user_id;
        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Неверный старый пароль.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'Пользователь не найден.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;


----get users
CREATE OR REPLACE FUNCTION get_users_info
RETURN user_info_table
IS
  v_users user_info_table := user_info_table();
BEGIN
  SELECT user_info_type(
    user_id, 
    login, 
    role_id, 
    name, 
    second_name, 
    email, 
    address
  )
  BULK COLLECT INTO v_users
  FROM "User";

  RETURN v_users;
END;

----get user by id 
CREATE OR REPLACE FUNCTION get_user_by_id (
  p_user_id IN NVARCHAR2
)
RETURN user_info_type
IS
  v_user user_info_type;
BEGIN
  SELECT user_info_type(
    user_id, 
    login, 
    role_id, 
    name, 
    second_name, 
    email, 
    address
  )
  INTO v_user
  FROM "User"
  WHERE user_id = p_user_id;

  RETURN v_user;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN NULL;
  WHEN OTHERS THEN
    RAISE;
END;
