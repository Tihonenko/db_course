CREATE OR REPLACE TRIGGER check_book_copies
    BEFORE UPDATE OR INSERT ON Book
    FOR EACH ROW
BEGIN
    IF :new.copies < 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Количество копий книги не может быть меньше или равно нулю.');
    END IF;
END;

