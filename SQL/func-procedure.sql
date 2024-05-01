-- for plsql
set serveroutput on;
--find errors
SELECT * FROM user_errors;
--
-------------------------------
---- FAVORITE ----
-------------------------------

---- add favorite
CREATE OR REPLACE PROCEDURE add_favorite_book(
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

----delete favorites
CREATE OR REPLACE PROCEDURE delete_favorites(
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
/

----link category books ----
CREATE OR REPLACE PROCEDURE link_book_category (
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

---- link author book ----
CREATE OR REPLACE PROCEDURE link_book_author (
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


