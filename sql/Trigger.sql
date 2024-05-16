CREATE OR REPLACE TRIGGER check_book_copies
    BEFORE UPDATE OR INSERT ON Book
    FOR EACH ROW
BEGIN
    IF :new.copies < 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Количество копий книги не может быть меньше или равно нулю.');
    END IF;
END;


CREATE OR REPLACE TRIGGER complete_orders_on_expiration
  AFTER UPDATE OF end_time ON Status
  FOR EACH ROW
DECLARE
  v_order_id "Order".order_id%TYPE;
BEGIN
  -- Получаем ID заказа по ID статуса
  SELECT order_id INTO v_order_id
  FROM "Order"
  WHERE status_id = :old.status_id;

  -- Проверяем, истекло ли время статуса
  IF :old.end_time < SYSDATE THEN
    -- Обновляем статус заказа на "Завершен"
    UPDATE "Order"
    SET status_id = (SELECT status_id FROM Status WHERE name = 'Завершен')
    WHERE order_id = v_order_id;

    -- Увеличиваем количество копий книги на 1
    UPDATE Book
    SET copies = copies + 1
    WHERE book_id = (SELECT book_id FROM "Order" WHERE order_id = v_order_id);
  END IF;
END;

CREATE OR REPLACE TRIGGER check_num_pages
BEFORE INSERT OR UPDATE ON Book
FOR EACH ROW
BEGIN
    IF :NEW.num_pages < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Количество страниц не может быть меньше 0');
    END IF;
END;

CREATE OR REPLACE TRIGGER check_title_length
BEFORE INSERT OR UPDATE ON Book
FOR EACH ROW
BEGIN
    IF LENGTH(:NEW.title) < 3 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Название должно быть больше 3ех символов');
    END IF;
END;

CREATE OR REPLACE TRIGGER check_end_time
BEFORE INSERT OR UPDATE ON Status
FOR EACH ROW
BEGIN
    IF :NEW.end_time < :NEW.start_time THEN
        RAISE_APPLICATION_ERROR(-20001, 'End time не можеть быть раньше start time');
    END IF;
END;

CREATE OR REPLACE TRIGGER check_login_length
BEFORE INSERT OR UPDATE ON "User"
FOR EACH ROW
BEGIN
    IF LENGTH(:NEW.login) < 4 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Логин не можеть быть меньше 4ех символов');
    END IF;
END;





