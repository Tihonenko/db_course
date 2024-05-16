---- get categories
CREATE OR REPLACE FUNCTION get_all_categories
RETURN category_info_table
IS
  v_categories category_info_table := category_info_table();
BEGIN
  SELECT category_info_type(category_id, name)
  BULK COLLECT INTO v_categories
  FROM Category;

  RETURN v_categories;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN category_info_table();
  WHEN OTHERS THEN
    RAISE;
END;


---- get category by id
CREATE OR REPLACE FUNCTION get_category_by_id (
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
