-- for plsql
set serveroutput on;
--
--password123
--

select * from Author;


select * from "User";


delete from "User" where login = 'user_test';
commit;

SELECT role_id FROM "User" WHERE login = 'useryes12';

select name from Role where role_id = '467A4138494A377941736A675977494145717A3530673D3D';

SELECT * FROM "User";
select * from book;

--SELECT * FROM user_errors;

---- test 100k rows
DECLARE
  v_category_id NVARCHAR2(255);
  v_name NVARCHAR2(255);
BEGIN
  FOR i IN 1 .. 100000 LOOP
    v_name := 'Category ' || i;

    create_category(v_name);
  END LOOP;

  COMMIT;
END;

select * from TABLE(get_all_categories());

SELECT * FROM Category;

---- test create user ----
DECLARE
    v_user_id NVARCHAR2(255);
    v_role_id NVARCHAR2(255);
BEGIN
    create_user(
      p_login => N'MANAGER',  -- Имя пользователя
      p_password => N'password123', -- Пароль
      p_name => N'MANAGER',       -- Имя      
      p_user_id => v_user_id,
      p_role_id => v_role_id
    );
END;



---- test auth user ----
DECLARE
    l_is_authenticated BOOLEAN;
BEGIN
    authenticate_user('test3', '12345', l_is_authenticated);

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
    SELECT user_id INTO test_user_id FROM "User" WHERE login = 'test_user';

    update_user(test_user_id, p_email => 'da@example.com');
END;

---- test update password user ----
DECLARE
    test_user_id RAW(16);
BEGIN
    -- 2. Получаем ID тестового пользователя
    SELECT user_id INTO test_user_id FROM "User" WHERE username = 'test3';

    -- BEGIN
    --     change_password(test_user_id, p_old_password => 'ad12', p_new_password => '12345');
    --     DBMS_OUTPUT.PUT_LINE('Ошибка: изменение пароля с неверным старым паролем прошло успешно.');
    -- EXCEPTION
    --     WHEN OTHERS THEN
    --         DBMS_OUTPUT.PUT_LINE('Ожидаемая ошибка: ' || SQLERRM);
    -- END;

    -- 4. Смена пароля с верным старым паролем
    BEGIN
        change_password(test_user_id, p_old_password => 'admin1234', p_new_password => '12345');
        DBMS_OUTPUT.PUT_LINE('Пароль успешно изменен.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
    END;

END;

DECLARE
  v_book_id NVARCHAR2(255);
BEGIN

  -- 2. Создаем тестовую книгу
  create_book(
    p_title => 'Laladala',
    p_isbn => '978-24-224-22',
    p_copies => 10,
    p_publication_date => '02-MY-2005'
  );
  IF v_book_id IS NOT NULL THEN
    DBMS_OUTPUT.PUT_LINE('Тест создания книги пройден.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Тест создания книги не пройден.');
  END IF;

END;


DECLARE
  v_author_id NVARCHAR2(255);
BEGIN
  -- 1. Создаем тестового автора
  ADMIN_LIB_PDB.create_author('LUSI');

END;

select * from book;

DECLARE
  v_book_id NVARCHAR2(255);
  v_author_id NVARCHAR2(255);
  v_linked_count INTEGER;
BEGIN

  --  Получаем ID книги и автора
  SELECT book_id
  INTO v_book_id
  FROM Book
  WHERE title = 'BOOK YES';

  SELECT author_id
  INTO v_author_id
  FROM Author
  WHERE name = 'Lutik';

  --  Связываем книгу с автором
  link_book_author(v_book_id, v_author_id);

  --  Проверяем, что связь создана
  SELECT COUNT(*) INTO v_linked_count
  FROM Book_Author
  WHERE book_id = v_book_id AND author_id = v_author_id;

  IF v_linked_count = 1 THEN
    DBMS_OUTPUT.PUT_LINE('Тест связи книги с автором пройден.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Тест связи книги с автором не пройден.');
  END IF;

END;

SELECT * FROM book_author;


----create order ----

select * from Book;

BEGIN
  create_order_status(
    '467A4138494A373141736A675977494145717A3530673D3D', 
    '463373784D6A575441776A67597749414571795238413D3D', 
    0, -- Дата окончания через 14 дней
    0, -- Добавить 2 часа
    30, -- Добавить 30 минут
    'Выдан'
  );
END;

SELECT * FROM Status;

SELECT * FROM Book WHERE book_id = '46337449524A616541302F67597749414571784B75773D3D';

select * from Book;
SELECT * FROM "User";

BEGIN
  update_book(
    p_book_id => '467A712B66434D68416F33675977494145717A614D773D3D',
    p_title => 'New Book Title',
    p_description => 'New Book Description'
  );
END;

BEGIN
  delete_book_set_null(
    p_book_id => '467A712B66434E59416F33675977494145717A614D773D3D' );
END;


BEGIN
    update_book('463042435536754A417A2F675977494145717A5856413D3D', 'hello');
END;

select * from author;

SELECT * FROM TABLE(search_books('b'));
SELECT * FROM TABLE(get_book_by_id('467A712B66434E59416F33675977494145717A614D773D3D'));
SELECT * FROM TABLE(get_books_by_author('467A712B66434E61416F33675977494145717A614D773D3D', 1, 10));
SELECT * FROM TABLE(get_books_by_author('467A712B66434E61416F33675977494145717A614D773D3D', 1, 10));
SELECT * FROM TABLE(get_all_books());
SELECT * FROM TABLE(get_all_authors());
SELECT * FROM TABLE(get_orders_with_status());
SELECT * FROM TABLE(get_all_categories());
SELECT * FROM TABLE(delete_author_set_null('462B574D37637A4841303767597749414571775650673D3D'));
SELECT * FROM TABLE(get_favorite_books_by_user('47477575397A766A43427667597749414571795266673D3D'));




BEGIN
  delete_author_set_null('462B574D37637A4841303767597749414571775650673D3D');
END;

EXPLAIN PLAN FOR SELECT * FROM Category where name = 'Category 25100';

SELECT * FROM Category where name = 'Category 25100';

DELETE FROM category;
commit;
SELECT * FROM TABLE(DBMS_XPLAN.display);

--47477575397A766A43427667597749414571795266673D3D
-- BOOK 467A712B66434D68416F33675977494145717A614D773D3D
-- USER 467A4138494A373141736A675977494145717A3530673D3D