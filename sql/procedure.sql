--------------------------------------------------------
--  DDL for Procedure ADD_FAVORITE_BOOK
--------------------------------------------------------

CREATE OR REPLACE PROCEDURE "ADD_FAVORITE_BOOK" (
    p_book_id IN NVARCHAR2,
    p_user_id IN NVARCHAR2
)
AS
BEGIN
    INSERT INTO Favorites (user_id, book_id)
    VALUES (p_user_id, p_book_id);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
--------------------------------------------------------
--  DDL for Procedure AUTHENTICATE_USER
--------------------------------------------------------
  CREATE OR REPLACE PROCEDURE "AUTHENTICATE_USER" (
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
--------------------------------------------------------
--  DDL for Procedure CANCEL_ORDER
--------------------------------------------------------

CREATE OR REPLACE PROCEDURE "CANCEL_ORDER" (
  p_order_id IN NVARCHAR2
)
AS
  v_book_id NVARCHAR2(255);
  v_status_id NVARCHAR2(255);
  v_status_count NUMBER;
BEGIN

  SELECT book_id, status_id INTO v_book_id, v_status_id
  FROM "Order"
  WHERE order_id = p_order_id;


  SELECT COUNT(*)
  INTO v_status_count
  FROM Status
  WHERE status_id = v_status_id
  AND name IN ('Выдан', 'В процессе');

  IF v_status_count = 0 THEN
    RAISE_APPLICATION_ERROR(-20007, 'Заказ нельзя отменить, так как он уже завершен или отменен.');
  END IF;


  UPDATE "Order"
  SET status_id = (SELECT status_id FROM Status WHERE name = 'Отменен')
  WHERE order_id = p_order_id;


  UPDATE Book
  SET copies = copies + 1
  WHERE book_id = v_book_id;

  COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20006, 'Заказ не найден.');
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
END;
--------------------------------------------------------
--  DDL for Procedure CHANGE_ORDER_STATUS
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CHANGE_ORDER_STATUS" (
    p_order_id IN NVARCHAR2,
    p_new_status_name IN NVARCHAR2
)
AS
  v_order_count NUMBER;
  v_status_id NVARCHAR2(255);
BEGIN

  SELECT COUNT(*)
  INTO v_order_count
  FROM "Order"
  WHERE order_id = p_order_id;

  IF v_order_count = 0 THEN
    RAISE_APPLICATION_ERROR(-20006, 'Заказ не найден.');
  END IF;

  SELECT status_id INTO v_status_id 
  FROM "Order"
  WHERE order_id = p_order_id;


  UPDATE Status
  SET name = p_new_status_name
  WHERE status_id = v_status_id;

  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
END;
--------------------------------------------------------
--  DDL for Procedure CHANGE_PASSWORD
--------------------------------------------------------

CREATE OR REPLACE PROCEDURE "CHANGE_PASSWORD" (
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
--------------------------------------------------------
--  DDL for Procedure CREATE_AUTHOR
--------------------------------------------------------

CREATE OR REPLACE PROCEDURE "CREATE_AUTHOR" (
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
--------------------------------------------------------
--  DDL for Procedure CREATE_BOOK
--------------------------------------------------------


  CREATE OR REPLACE  PROCEDURE "CREATE_BOOK" (
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
    i_copies INTEGER;
    i_num_pages INTEGER;
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
--------------------------------------------------------
--  DDL for Procedure CREATE_CATEGORY
--------------------------------------------------------


  CREATE OR REPLACE  PROCEDURE "CREATE_CATEGORY" (
    p_name IN NVARCHAR2
)
AS
    p_category_id NVARCHAR2(255);
BEGIN
    p_category_id := UTL_ENCODE.base64_encode(SYS_GUID());
    INSERT INTO Category (category_id, name)
    VALUES (p_category_id, p_name);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
--------------------------------------------------------
--  DDL for Procedure CREATE_ORDER_STATUS
--------------------------------------------------------


  CREATE OR REPLACE  PROCEDURE "CREATE_ORDER_STATUS" (
    p_user_id IN NVARCHAR2,
    p_book_id IN NVARCHAR2,
    p_days IN INTEGER DEFAULT 0,
    p_hours IN INTEGER DEFAULT 0, -- Добавление часов
    p_minutes IN INTEGER DEFAULT 15, -- Добавление минут
    p_status_name NVARCHAR2
)
AS
    v_date DATE;
    v_status_id NVARCHAR2(255);
    v_order_id NVARCHAR2(255);
    v_copies INTEGER;
    v_final_end_time DATE;
BEGIN
    v_date := SYSDATE;

    v_final_end_time := SYSDATE + p_days + p_hours/24 + p_minutes/(24*60);

    IF v_final_end_time < v_date THEN
        RAISE_APPLICATION_ERROR(-20001, 'Дата окончания статуса не может быть раньше текущей даты.');
    END IF;

    SELECT copies INTO v_copies
    FROM Book
    WHERE book_id = p_book_id;

    IF v_copies IS NULL THEN
        RAISE_APPLICATION_ERROR(-20005, 'Информация о книге не найдена.');
    END IF;

    IF v_copies <= 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Книг в наличии нету');
    END IF;

    UPDATE Book
    SET copies = copies - 1
    WHERE book_id = p_book_id;

    v_order_id := UTL_ENCODE.base64_encode(SYS_GUID());
    v_status_id := UTL_ENCODE.base64_encode(SYS_GUID());

    INSERT INTO Status (status_id, start_time, end_time, name)
    VALUES (v_status_id, v_date, v_final_end_time, p_status_name); -- Используем v_final_end_time

    INSERT INTO "Order" (order_id, user_id, order_date, status_id, book_id)
    VALUES (v_order_id, p_user_id, v_date, v_status_id, p_book_id);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
--------------------------------------------------------
--  DDL for Procedure CREATE_PUBLISHER
--------------------------------------------------------


  CREATE OR REPLACE  PROCEDURE "CREATE_PUBLISHER" (
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
--------------------------------------------------------
--  DDL for Procedure CREATE_USER
--------------------------------------------------------


  CREATE OR REPLACE  PROCEDURE "CREATE_USER" (
    p_login IN NVARCHAR2,
    p_password IN NVARCHAR2,
    p_name IN NVARCHAR2,
    p_second_name IN NVARCHAR2 DEFAULT NULL,
    p_email IN NVARCHAR2 DEFAULT NULL,
    p_address IN NVARCHAR2 DEFAULT NULL,
    p_user_id OUT NVARCHAR2,
    p_role_id OUT NVARCHAR2
)
AS

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
--------------------------------------------------------
--  DDL for Procedure DELETE_AUTHOR_SET_NULL
--------------------------------------------------------


  CREATE OR REPLACE  PROCEDURE "DELETE_AUTHOR_SET_NULL" (
  p_author_id IN NVARCHAR2
)
AS
BEGIN

    DELETE FROM BOOK_AUTHOR WHERE author_id = p_author_id;

    DELETE FROM Author WHERE author_id = p_author_id;

    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'Автор не найден.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
--------------------------------------------------------
--  DDL for Procedure DELETE_BOOK_SET_NULL
--------------------------------------------------------


  CREATE OR REPLACE  PROCEDURE "DELETE_BOOK_SET_NULL" (
  p_book_id IN NVARCHAR2
)
AS
BEGIN
    UPDATE "Order" SET book_id = NULL WHERE book_id = p_book_id;
    UPDATE Favorites SET book_id = NULL WHERE book_id = p_book_id;

    DELETE FROM Book_Author WHERE book_id = p_book_id;

    DELETE FROM Categories_Book WHERE book_id = p_book_id;
    
    DELETE FROM Book WHERE book_id = p_book_id;

    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'Книга не найден.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
--------------------------------------------------------
--  DDL for Procedure DELETE_CATEGORY_SET_NULL
--------------------------------------------------------


  CREATE OR REPLACE  PROCEDURE "DELETE_CATEGORY_SET_NULL" (
  p_category_id IN NVARCHAR2
)
AS
BEGIN

    DELETE FROM Categories_Book WHERE category_id = p_category_id;
    
    DELETE FROM Category WHERE category_id = p_category_id;

    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'Категория не найден.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
--------------------------------------------------------
--  DDL for Procedure DELETE_FAVORITES
--------------------------------------------------------


  CREATE OR REPLACE  PROCEDURE "DELETE_FAVORITES" (
  p_book_id IN NVARCHAR2,
  p_user_id IN NVARCHAR2
)
AS
BEGIN
      DELETE FROM Favorites
      WHERE book_id = p_book_id AND user_id = p_user_id;

      DELETE FROM Favorites
      WHERE book_id IS NULL AND user_id = p_user_id;

      COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20002, 'Запись в избранном не найдена.');
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
END;
--------------------------------------------------------
--  DDL for Procedure DELETE_PUBLISHER
--------------------------------------------------------


  CREATE OR REPLACE  PROCEDURE "DELETE_PUBLISHER" (
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
--------------------------------------------------------
--  DDL for Procedure LINK_BOOK_AUTHOR
--------------------------------------------------------


  CREATE OR REPLACE  PROCEDURE "LINK_BOOK_AUTHOR" (
    p_book_id IN NVARCHAR2,
    p_author_id IN NVARCHAR2
)
AS
BEGIN
    INSERT INTO Book_Author (book_id, author_id)
    VALUES (p_book_id, p_author_id);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
--------------------------------------------------------
--  DDL for Procedure LINK_BOOK_CATEGORY
--------------------------------------------------------


  CREATE OR REPLACE  PROCEDURE "LINK_BOOK_CATEGORY" (
    p_book_id IN NVARCHAR2,
    p_category_id IN NVARCHAR2
)
AS
BEGIN
    INSERT INTO Categories_Book (book_id, category_id)
    VALUES (p_book_id, p_category_id);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
--------------------------------------------------------
--  DDL for Procedure UPDATE_AUTHOR
--------------------------------------------------------


  CREATE OR REPLACE  PROCEDURE "UPDATE_AUTHOR" (
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
--------------------------------------------------------
--  DDL for Procedure UPDATE_BOOK
--------------------------------------------------------


  CREATE OR REPLACE  PROCEDURE "UPDATE_BOOK" (
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

    IF p_title IS NOT NULL THEN 
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
--------------------------------------------------------
--  DDL for Procedure UPDATE_CATEGORY
--------------------------------------------------------


  CREATE OR REPLACE  PROCEDURE "UPDATE_CATEGORY" (
    p_category_id IN NVARCHAR2,
    p_name IN NVARCHAR2
)
AS
BEGIN
    UPDATE Category
    SET 
        name = COALESCE(p_name, name)
    WHERE category_id = p_category_id;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
--------------------------------------------------------
--  DDL for Procedure UPDATE_PUBLISHER
--------------------------------------------------------


  CREATE OR REPLACE  PROCEDURE "UPDATE_PUBLISHER" (
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
--------------------------------------------------------
--  DDL for Procedure UPDATE_USER
--------------------------------------------------------


  CREATE OR REPLACE  PROCEDURE "UPDATE_USER" (
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
