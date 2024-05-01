---- create order and status
CREATE OR REPLACE PROCEDURE create_order_status (
    p_user_id IN NVARCHAR2,
    p_book_id IN NVARCHAR2,
    p_days IN INTEGER DEFAULT 0,
    p_hours IN INTEGER DEFAULT 0, 
    p_minutes IN INTEGER DEFAULT 0,
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

---- update status
CREATE OR REPLACE PROCEDURE change_order_status (
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



---- cansel_order
CREATE OR REPLACE PROCEDURE cancel_order (
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

----get order
CREATE OR REPLACE FUNCTION get_orders_with_status
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


----get order by id user or book
CREATE OR REPLACE FUNCTION get_orders_by_user_or_book (
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


----get order by id
CREATE OR REPLACE FUNCTION get_order_by_id (
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
