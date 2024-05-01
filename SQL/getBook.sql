
---- search
CREATE OR REPLACE FUNCTION search_books (
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


----get books by id
CREATE OR REPLACE FUNCTION get_book_by_id (
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
    RETURN book_result_table();
  WHEN OTHERS THEN
    RAISE;
END;


---- get books by author
CREATE OR REPLACE FUNCTION get_books_by_author (
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

---- get books by category
CREATE OR REPLACE FUNCTION get_books_by_category (
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


----get books by publisher
CREATE OR REPLACE FUNCTION get_books_by_publisher (
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


----get all books
CREATE OR REPLACE FUNCTION get_all_books (
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
  AND ROWNUM <= 100;

  RETURN v_books;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN book_result_table();
  WHEN OTHERS THEN
    RAISE;
END;
