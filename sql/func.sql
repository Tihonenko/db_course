--------------------------------------------------------
--  DDL for Function GET_ALL_AUTHORS
--------------------------------------------------------

  CREATE OR REPLACE  FUNCTION "GET_ALL_AUTHORS" 
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
--------------------------------------------------------
--  DDL for Function GET_ALL_BOOKS
--------------------------------------------------------

  CREATE OR REPLACE  FUNCTION "GET_ALL_BOOKS" (
  p_page_number IN NUMBER DEFAULT 1,
  p_page_size IN NUMBER DEFAULT 10
)
RETURN book_result_table
IS
  v_books book_result_table := book_result_table();
  v_start_row NUMBER;
  v_end_row NUMBER;
BEGIN
  v_start_row := (p_page_number - 1) * p_page_size + 1;
  v_end_row := p_page_number * p_page_size;

  SELECT book_result_type(
    b.book_id,
    b.title,
    b.description,
    b.publication_date,
    b.publisher_id,
    b.isbn,
    b.tags,
    b.copies,
    b.num_pages,
    b.file_name,
    b.image_name,
    a.name,
    c.name
  )
  BULK COLLECT INTO v_books
  FROM Book b
  LEFT JOIN Book_Author ba ON b.book_id = ba.book_id
  LEFT JOIN Author a ON ba.author_id = a.author_id
  LEFT JOIN Categories_Book cb ON b.book_id = cb.book_id
  LEFT JOIN Category c ON cb.category_id = c.category_id
  ORDER BY b.title
  OFFSET v_start_row - 1 ROWS FETCH NEXT p_page_size ROWS ONLY;

  RETURN v_books;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN book_result_table();
  WHEN OTHERS THEN
    RAISE;
END;
--------------------------------------------------------
--  DDL for Function GET_ALL_CATEGORIES
--------------------------------------------------------

  CREATE OR REPLACE  FUNCTION "GET_ALL_CATEGORIES" 
RETURN category_info_table
IS
  v_categories category_info_table := category_info_table();
BEGIN
  SELECT category_info_type(category_id, name)
  BULK COLLECT INTO v_categories
  FROM Category 
  FETCH FIRST 100 ROWS ONLY;

  RETURN v_categories;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN category_info_table();
  WHEN OTHERS THEN
    RAISE;
END;
--------------------------------------------------------
--  DDL for Function GET_ALL_USERS_INFO_VIEW
--------------------------------------------------------

  CREATE OR REPLACE  FUNCTION "GET_ALL_USERS_INFO_VIEW" 
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
--------------------------------------------------------
--  DDL for Function GET_AUTHOR_BY_ID
--------------------------------------------------------

  CREATE OR REPLACE  FUNCTION "GET_AUTHOR_BY_ID" (
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
--------------------------------------------------------
--  DDL for Function GET_BOOK_BY_ID
--------------------------------------------------------

  CREATE OR REPLACE  FUNCTION "GET_BOOK_BY_ID" (
  p_book_id IN NVARCHAR2
)
RETURN book_result_table
IS
  v_books book_result_table := book_result_table();
BEGIN
  SELECT book_result_type(
    b.book_id,
    b.title,
    b.description,
    b.publication_date,
    b.publisher_id,
    b.isbn,
    b.tags,
    b.copies,
    b.num_pages,
    b.file_name,
    b.image_name,
    a.name,
    c.name
  )
  BULK COLLECT INTO v_books
  FROM Book b
  LEFT JOIN Book_Author ba ON b.book_id = ba.book_id
  LEFT JOIN Author a ON ba.author_id = a.author_id
  LEFT JOIN Categories_Book cb ON b.book_id = cb.book_id
  LEFT JOIN Category c ON cb.category_id = c.category_id
  WHERE b.book_id = p_book_id;

  RETURN v_books;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN book_result_table(); -- Возвращаем пустую таблицу
  WHEN OTHERS THEN
    RAISE;
END;
--------------------------------------------------------
--  DDL for Function GET_BOOKS_BY_AUTHOR
--------------------------------------------------------

  CREATE OR REPLACE  FUNCTION "GET_BOOKS_BY_AUTHOR" (
  p_author_id IN NVARCHAR2,
  p_page_number IN INTEGER DEFAULT 1,
  p_page_size IN INTEGER DEFAULT 10
)
RETURN book_result_table
IS
  v_books book_result_table := book_result_table();
  v_start_row INTEGER;
  v_end_row INTEGER;
BEGIN
  v_start_row := (p_page_number - 1) * p_page_size + 1;
  v_end_row := p_page_number * p_page_size;

  SELECT book_result_type(
    b.book_id,
    b.title,
    b.description,
    b.publication_date,
    b.publisher_id,
    b.isbn,
    b.tags,
    b.copies,
    b.num_pages,
    b.file_name,
    b.image_name,
    a.name,
    c.name
  )
  BULK COLLECT INTO v_books
  FROM Book b
  JOIN Book_Author ba ON b.book_id = ba.book_id
  LEFT JOIN Author a ON ba.author_id = a.author_id
  LEFT JOIN Categories_Book cb ON b.book_id = cb.book_id
  LEFT JOIN Category c ON cb.category_id = c.category_id
  WHERE ba.author_id = p_author_id
  ORDER BY b.title
  OFFSET v_start_row - 1 ROWS FETCH NEXT p_page_size ROWS ONLY;

  RETURN v_books;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN book_result_table(); -- Возвращаем пустую таблицу
  WHEN OTHERS THEN
    RAISE;
END;
--------------------------------------------------------
--  DDL for Function GET_BOOKS_BY_CATEGORY
--------------------------------------------------------

  CREATE OR REPLACE  FUNCTION "GET_BOOKS_BY_CATEGORY" (
  p_category_id IN NVARCHAR2,
  p_page_number IN INTEGER DEFAULT 1,
  p_page_size IN INTEGER DEFAULT 10
)
RETURN book_result_table
IS
  v_books book_result_table := book_result_table();
  v_start_row INTEGER;
  v_end_row INTEGER;
BEGIN
  v_start_row := (p_page_number - 1) * p_page_size + 1;
  v_end_row := p_page_number * p_page_size;

  SELECT book_result_type(
    b.book_id,
    b.title,
    b.description,
    b.publication_date,
    b.publisher_id,
    b.isbn,
    b.tags,
    b.copies,
    b.num_pages,
    b.file_name,
    b.image_name,
    a.name,
    c.name 
  )
  BULK COLLECT INTO v_books
  FROM Book b
  JOIN Categories_Book cb ON b.book_id = cb.book_id
  LEFT JOIN Book_Author ba ON b.book_id = ba.book_id
  LEFT JOIN Author a ON ba.author_id = a.author_id
  LEFT JOIN Category c ON cb.category_id = c.category_id
  WHERE cb.category_id = p_category_id
  ORDER BY b.title
  OFFSET v_start_row - 1 ROWS FETCH NEXT p_page_size ROWS ONLY;

  RETURN v_books;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN book_result_table();
  WHEN OTHERS THEN
    RAISE;
END;
--------------------------------------------------------
--  DDL for Function GET_BOOKS_BY_PUBLISHER
--------------------------------------------------------

  CREATE OR REPLACE  FUNCTION "GET_BOOKS_BY_PUBLISHER" (
  p_publisher_id IN NVARCHAR2,
  p_page_number IN INTEGER DEFAULT 1,
  p_page_size IN INTEGER DEFAULT 10
)
RETURN book_result_table
IS
  v_books book_result_table := book_result_table();
  v_start_row INTEGER;
  v_end_row INTEGER;
BEGIN
  v_start_row := (p_page_number - 1) * p_page_size + 1;
  v_end_row := p_page_number * p_page_size;

  SELECT book_result_type(
    b.book_id,
    b.title,
    b.description,
    b.publication_date,
    b.publisher_id,
    b.isbn,
    b.tags,
    b.copies,
    b.num_pages,
    b.file_name,
    b.image_name,
    a.name,
    c.name
  )
  BULK COLLECT INTO v_books
  FROM Book b
  LEFT JOIN Book_Author ba ON b.book_id = ba.book_id
  LEFT JOIN Author a ON ba.author_id = a.author_id
  LEFT JOIN Categories_Book cb ON b.book_id = cb.book_id
  LEFT JOIN Category c ON cb.category_id = c.category_id
  WHERE b.publisher_id = p_publisher_id
  ORDER BY b.title
  OFFSET v_start_row - 1 ROWS FETCH NEXT p_page_size ROWS ONLY;

  RETURN v_books;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN book_result_table();
  WHEN OTHERS THEN
    RAISE;
END;
--------------------------------------------------------
--  DDL for Function GET_CATEGORY_BY_ID
--------------------------------------------------------

  CREATE OR REPLACE  FUNCTION "GET_CATEGORY_BY_ID" (
  p_category_id IN NVARCHAR2
)
RETURN category_info_type
IS
  v_category category_info_type;
BEGIN
  SELECT category_info_type(category_id, name)
  INTO v_category
  FROM Category
  WHERE category_id = p_category_id;

  RETURN v_category;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN NULL;
  WHEN OTHERS THEN
    RAISE;
END;
--------------------------------------------------------
--  DDL for Function GET_FAVORITE_BOOKS_BY_USER
--------------------------------------------------------

  CREATE OR REPLACE  FUNCTION "GET_FAVORITE_BOOKS_BY_USER" (
  p_user_id IN NVARCHAR2
)
RETURN book_result_table
IS
  v_books book_result_table := book_result_table();
BEGIN
  SELECT book_result_type(
    b.book_id,
    b.title,
    b.description,
    b.publication_date,
    b.publisher_id,
    b.isbn,
    b.tags,
    b.copies,
    b.num_pages,
    b.file_name,
    b.image_name,
    a.name,
    c.name
  )
  BULK COLLECT INTO v_books
  FROM Book b
  JOIN Favorites f ON b.book_id = f.book_id
  LEFT JOIN Book_Author ba ON b.book_id = ba.book_id
  LEFT JOIN Author a ON ba.author_id = a.author_id
  LEFT JOIN Categories_Book cb ON b.book_id = cb.book_id
  LEFT JOIN Category c ON cb.category_id = c.category_id
  WHERE f.user_id = p_user_id;

  RETURN v_books;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN book_result_table();
  WHEN OTHERS THEN
    RAISE;
END;
--------------------------------------------------------
--  DDL for Function GET_ORDER_BY_ID
--------------------------------------------------------

  CREATE OR REPLACE  FUNCTION "GET_ORDER_BY_ID" (
  p_order_id IN NVARCHAR2
)
RETURN order_with_status_type
IS
  v_order order_with_status_type;
BEGIN
  SELECT order_with_status_type(
    o.order_id,
    o.user_id,
    o.book_id,
    o.order_date,
    s.name,
    s.start_time,
    s.end_time
  )
  INTO v_order
  FROM "Order" o
  JOIN Status s ON o.status_id = s.status_id
  WHERE o.order_id = p_order_id;

  RETURN v_order;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN NULL;
  WHEN OTHERS THEN
    RAISE;
END;
--------------------------------------------------------
--  DDL for Function GET_ORDERS_BY_USER_OR_BOOK
--------------------------------------------------------

  CREATE OR REPLACE  FUNCTION "GET_ORDERS_BY_USER_OR_BOOK" (
  p_user_id IN NVARCHAR2 DEFAULT NULL,
  p_book_id IN NVARCHAR2 DEFAULT NULL
)
RETURN order_with_status_table
IS
  v_orders order_with_status_table := order_with_status_table();
BEGIN
  SELECT order_with_status_type(
    o.order_id,
    o.user_id,
    o.book_id,
    o.order_date,
    s.name,
    s.start_time,
    s.end_time
  )
  BULK COLLECT INTO v_orders
  FROM "Order" o
  JOIN Status s ON o.status_id = s.status_id
  WHERE (p_user_id IS NULL OR o.user_id = p_user_id)
  AND (p_book_id IS NULL OR o.book_id = p_book_id);

  RETURN v_orders;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN order_with_status_table(); -- Возвращаем пустую таблицу
  WHEN OTHERS THEN
    RAISE;
END;
--------------------------------------------------------
--  DDL for Function GET_ORDERS_WITH_STATUS
--------------------------------------------------------

  CREATE OR REPLACE  FUNCTION "GET_ORDERS_WITH_STATUS" 
RETURN order_with_status_table
IS
  v_orders order_with_status_table := order_with_status_table();
BEGIN
  SELECT order_with_status_type(
    o.order_id,
    o.user_id,
    o.book_id,
    o.order_date,
    s.name,
    s.start_time,
    s.end_time
  )
  BULK COLLECT INTO v_orders
  FROM "Order" o
  JOIN Status s ON o.status_id = s.status_id;

  RETURN v_orders;
END;
--------------------------------------------------------
--  DDL for Function GET_USER_BY_ID
--------------------------------------------------------

  CREATE OR REPLACE  FUNCTION "GET_USER_BY_ID" (
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
--------------------------------------------------------
--  DDL for Function GET_USERS_INFO
--------------------------------------------------------

  CREATE OR REPLACE  FUNCTION "GET_USERS_INFO" 
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
--------------------------------------------------------
--  DDL for Function HASH_PASSWORD
--------------------------------------------------------

  CREATE OR REPLACE  FUNCTION "HASH_PASSWORD" (
    p_password IN NVARCHAR2
) RETURN NVARCHAR2
AS
    p_hash_raw RAW(32);
    p_hash_hex NVARCHAR2(255);
BEGIN
    p_hash_raw := DBMS_CRYPTO.HASH(UTL_I18N.STRING_TO_RAW(p_password, 'AL32UTF8'), DBMS_CRYPTO.HASH_SH256);
    p_hash_hex := UTL_ENCODE.base64_encode(p_hash_raw);
    RETURN p_hash_hex;
END;
--------------------------------------------------------
--  DDL for Function SEARCH_BOOKS
--------------------------------------------------------

  CREATE OR REPLACE  FUNCTION "SEARCH_BOOKS" (
    p_search_term IN NVARCHAR2
)
RETURN book_result_table
IS
  v_results book_result_table := book_result_table();
BEGIN
  SELECT book_result_type(
    b.book_id,
    b.title,
    b.description,
    b.publication_date,
    b.publisher_id,
    b.isbn,
    b.tags,
    b.copies,
    b.num_pages,
    b.file_name,
    b.image_name,
    a.name,
    c.name 
  )
  BULK COLLECT INTO v_results
  FROM Book b
  LEFT JOIN Book_Author ba ON b.book_id = ba.book_id
  LEFT JOIN Author a ON ba.author_id = a.author_id
  LEFT JOIN Categories_Book cb ON b.book_id = cb.book_id  
  LEFT JOIN Category c ON cb.category_id = c.category_id 
  WHERE UPPER(b.title) LIKE '%' || UPPER(p_search_term) || '%' OR UPPER(a.name) LIKE '%' || UPPER(p_search_term) || '%'
  AND ROWNUM <= 100;

  RETURN v_results;
END;
--------------------------------------------------------
--  DDL for Function VALIDATE_PASSWORD
--------------------------------------------------------

  CREATE OR REPLACE  FUNCTION "VALIDATE_PASSWORD" (
    p_password IN NVARCHAR2,
    p_hashed_password IN NVARCHAR2  
) RETURN BOOLEAN
AS
    l_hash RAW(32);
    l_hash_hex NVARCHAR2(255);
BEGIN
    l_hash := DBMS_CRYPTO.HASH(
        UTL_I18N.STRING_TO_RAW(p_password, 'AL32UTF8'),
        DBMS_CRYPTO.HASH_SH256
    );
    l_hash_hex := UTL_ENCODE.base64_encode(l_hash);

    RETURN l_hash_hex = p_hashed_password;
END;
