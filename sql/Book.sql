----------------------------------------
---- BOOK ----
----------------------------------------

---- create book ----
CREATE OR REPLACE PROCEDURE create_book (
    p_title IN NVARCHAR2,
    p_description IN NVARCHAR2 DEFAULT NULL,
    p_publication_date IN NVARCHAR2 DEFAULT NULL,
    p_publisher_name IN NVARCHAR2 DEFAULT NULL,
    p_isbn IN NVARCHAR2,
    p_tags IN NVARCHAR2 DEFAULT NULL,
    p_num_pages IN INTEGER DEFAULT NULL,
    p_copies IN INTEGER DEFAULT NULL,
    p_file_name IN NVARCHAR2 DEFAULT NULL,
    p_image_name IN NVARCHAR2 DEFAULT NULL
)
AS
    l_publisher_id NVARCHAR2(255) DEFAULT NULL;
    l_publication_date DATE;
    l_book_id NVARCHAR2(255);
BEGIN

    IF p_publisher_name IS NOT NULL THEN
    SELECT publisher_id INTO l_publisher_id 
        FROM Publisher WHERE name = p_publisher_name;
    ELSE 
        l_publisher_id := NULL;
    END IF;

    IF p_publication_date IS NOT NULL THEN
        l_publication_date := TO_DATE(p_publication_date, 'DD-MON-YYYY');
    ELSE
        l_publication_date := NULL;
    END IF;
    
    l_book_id := UTL_ENCODE.base64_encode(SYS_GUID());

    INSERT INTO Book (book_id, title, description, publication_date, publisher_id, isbn, tags, num_pages, copies, file_name, image_name)
    VALUES (l_book_id, p_title, p_description, p_publication_date, l_publisher_id, p_isbn, p_tags, p_num_pages, p_copies, p_file_name, p_image_name);
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(-20001, 'Издатель с таким именем уже существует.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;

---- update book
CREATE OR REPLACE PROCEDURE update_book (
    p_book_id IN NVARCHAR2,
    p_title IN NVARCHAR2 DEFAULT NULL,
    p_description IN NVARCHAR2 DEFAULT NULL,
    p_publication_date IN DATE DEFAULT NULL,
    p_publisher_id IN NVARCHAR2 DEFAULT NULL,
    p_isbn IN NVARCHAR2 DEFAULT NULL,
    p_tags IN NVARCHAR2 DEFAULT NULL,
    p_copies IN INTEGER DEFAULT NULL,
    p_num_pages IN INTEGER DEFAULT NULL,
    p_file_name IN NVARCHAR2 DEFAULT NULL,
    p_image_name IN NVARCHAR2 DEFAULT NULL
)
AS
    l_count INTEGER;
BEGIN

    IF p_title IS NOT NULL THEN -- Проверяем только если title передано для обновления
      SELECT COUNT(*) INTO l_count
      FROM Book
      WHERE title = p_title
      AND book_id != p_book_id; 

      IF l_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Название книги уже занято.');
      END IF;
    END IF;


    UPDATE Book
    SET 
        title = COALESCE(p_title, title),
        description = COALESCE(p_description, description),
        publication_date = COALESCE(p_publication_date, publication_date),
        publisher_id = COALESCE(p_publisher_id, publisher_id),
        isbn = COALESCE(p_isbn, isbn),
        tags = COALESCE(p_tags, tags),
        copies = COALESCE(p_copies, copies),
        num_pages = COALESCE(p_num_pages, num_pages),
        file_name = COALESCE(p_file_name, file_name),
        image_name = COALESCE(p_image_name, image_name)
    WHERE book_id = p_book_id;

    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'Книга не найден.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;


---- delete book and set null other tables
CREATE OR REPLACE PROCEDURE delete_book_set_null(
  p_book_id IN NVARCHAR2
)
AS
BEGIN
    UPDATE "Order" SET book_id = NULL WHERE book_id = p_book_id;
    UPDATE Favorites SET book_id = NULL WHERE book_id = p_book_id;
    UPDATE Book_Author SET book_id = NULL WHERE book_id = p_book_id;
    UPDATE Categories_Book SET book_id = NULL WHERE book_id = p_book_id;


    DELETE FROM Book WHERE book_id = p_book_id;

    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'Книга не найден.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;


