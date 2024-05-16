-------------------------------
---- AUTHOR ----
-------------------------------


---- create author ----
CREATE OR REPLACE PROCEDURE create_author (
    p_name IN NVARCHAR2
)
AS
    p_author_id NVARCHAR2(255);
BEGIN
    p_author_id := UTL_ENCODE.base64_encode(SYS_GUID());
    INSERT INTO Author (author_id, name)
    VALUES (p_author_id, p_name);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;


---- update author
CREATE OR REPLACE PROCEDURE update_author(
    p_author_id IN NVARCHAR2,
    p_name IN NVARCHAR2
)
AS
BEGIN
    UPDATE Author
    SET 
        name = COALESCE(p_name, name)
    WHERE author_id = p_author_id;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;


----delete author and set null
CREATE OR REPLACE PROCEDURE delete_author_set_null(
  p_author_id IN NVARCHAR2
)
AS
BEGIN
    
    UPDATE Book_Author SET author_id = NULL WHERE author_id = p_author_id;

    DELETE FROM Author WHERE author_id = p_author_id;

    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'Автор не найден.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;


----get authors
CREATE OR REPLACE FUNCTION get_all_authors
RETURN author_info_table
IS
  v_authors author_info_table := author_info_table();
BEGIN
  SELECT author_info_type(author_id, name)
  BULK COLLECT INTO v_authors
  FROM Author;

  RETURN v_authors;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN author_info_table();
  WHEN OTHERS THEN
    RAISE;
END;

----get author by id
CREATE OR REPLACE FUNCTION get_author_by_id (
  p_author_id IN NVARCHAR2
)
RETURN author_info_type
IS
  v_author author_info_type;
BEGIN
  SELECT author_info_type(author_id, name)
  INTO v_author
  FROM Author
  WHERE author_id = p_author_id;

  RETURN v_author;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN NULL;
  WHEN OTHERS THEN
    RAISE;
END;
