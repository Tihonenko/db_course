---- add publisher
CREATE OR REPLACE PROCEDURE create_publisher (
  p_name IN NVARCHAR2,
  p_publisher_id OUT NVARCHAR2
)
AS
BEGIN
  p_publisher_id := UTL_ENCODE.base64_encode(SYS_GUID());

  INSERT INTO Publisher (publisher_id, name)
  VALUES (p_publisher_id, p_name);

  COMMIT;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    RAISE_APPLICATION_ERROR(-20001, 'Издатель с таким именем уже существует.');
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
END;

----update publisher
CREATE OR REPLACE PROCEDURE update_publisher (
    p_publisher_id IN NVARCHAR2,
    p_name IN NVARCHAR2
)
AS
BEGIN
    UPDATE Publisher
    SET name = p_name
    WHERE publisher_id = p_publisher_id;

    COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20002, 'Издатель не найден.');
  WHEN DUP_VAL_ON_INDEX THEN
    RAISE_APPLICATION_ERROR(-20001, 'Издатель с таким именем уже существует.');
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
END;


---- delete publisher
CREATE OR REPLACE PROCEDURE delete_publisher (
  p_publisher_id IN NVARCHAR2
)
AS
BEGIN
    
    UPDATE Book SET publisher_id = NULL WHERE publisher_id = p_publisher_id;

    DELETE FROM Publisher
    WHERE publisher_id = p_publisher_id;

  COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20002, 'Издатель не найден.');
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
END;
