---- default roles ----
INSERT INTO Role (name) VALUES ('manager');
INSERT INTO Role (name) VALUES ('user');
INSERT INTO Role (name) VALUES ('guest');
INSERT INTO Role (name) VALUES ('admin');

select * from role;

DECLARE
    ID NVARCHAR2(255);
BEGIN
    
    ID := UTL_ENCODE.base64_encode(SYS_GUID());
    INSERT INTO Role (role_id,name) VALUES (ID, 'manager');
    ID := UTL_ENCODE.base64_encode(SYS_GUID());

    INSERT INTO Role (role_id, name) VALUES (ID,'user');
    ID := UTL_ENCODE.base64_encode(SYS_GUID());

    INSERT INTO Role (role_id, name) VALUES (ID, 'guest');
    ID := UTL_ENCODE.base64_encode(SYS_GUID());

    INSERT INTO Role (role_id, name) VALUES (ID, 'admin');
    DBMS_OUTPUT.PUT_LINE('Новый пользователь успешно добавлен. Идентификатор пользователя:');
END;