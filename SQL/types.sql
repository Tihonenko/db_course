
---- type books
CREATE OR REPLACE TYPE book_result_type AS OBJECT (
  book_id NVARCHAR2(255),
  title NVARCHAR2(255),
  description NVARCHAR2(255),
  publication_date DATE,
  publisher_id RAW(16),
  isbn NVARCHAR2(255),
  tags NVARCHAR2(60),
  copies INTEGER,
  num_pages INTEGER,
  file_name NVARCHAR2(255),
  image_name NVARCHAR2(255),
  author_name NVARCHAR2(255),
  category_name NVARCHAR2(255)
);

CREATE OR REPLACE TYPE book_result_table AS TABLE OF book_result_type;


---- type order
CREATE OR REPLACE TYPE order_with_status_type AS OBJECT (
  order_id NVARCHAR2(255),
  user_id NVARCHAR2(255),
  book_id NVARCHAR2(255),
  order_date DATE,
  status_name NVARCHAR2(255),
  start_time DATE,
  end_time DATE
);


CREATE OR REPLACE TYPE order_with_status_table AS TABLE OF order_with_status_type;

---- type user
CREATE OR REPLACE TYPE user_info_type AS OBJECT (
  user_id NVARCHAR2(255),
  login NVARCHAR2(255),
  role_id NVARCHAR2(255),
  name NVARCHAR2(255),
  second_name NVARCHAR2(255),
  email NVARCHAR2(255),
  address NVARCHAR2(255)
);


CREATE OR REPLACE TYPE user_info_table AS TABLE OF user_info_type;

---- type author
CREATE OR REPLACE TYPE author_info_type AS OBJECT (
    author_id NVARCHAR2(255),
    name NVARCHAR2(255)
);

CREATE OR REPLACE TYPE author_info_table AS TABLE OF author_info_type;


---- type category

CREATE OR REPLACE TYPE category_info_type AS OBJECT (
    category_id NVARCHAR2(255),
    name NVARCHAR2(255)
);

CREATE OR REPLACE TYPE category_info_table AS TABLE OF category_info_type;
