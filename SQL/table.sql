
--CREATE TABLE


---- BOOK ----
CREATE TABLE Book (
    book_id NVARCHAR2(255) PRIMARY KEY,
    title NVARCHAR2(255) NOT NULL UNIQUE,
    description NVARCHAR2(255),
    publication_date DATE,
    publisher_id NVARCHAR2(255),
    isbn NVARCHAR2(255) NOT NULL UNIQUE,
    tags NVARCHAR2(60),
    copies INTEGER,
    num_pages INTEGER,
    file_name NVARCHAR2(255),
    image_name NVARCHAR2(255)
);

---- AUTHOR ----
CREATE TABLE Author (
    author_id NVARCHAR2(255) PRIMARY KEY,
    name NVARCHAR2(255) NOT NULL UNIQUE
);

---- BOOK_AUTHOR ----
CREATE TABLE Book_Author (
    book_id NVARCHAR2(255),
    author_id NVARCHAR2(255),
    PRIMARY KEY (book_id, author_id)
);

---- CATEGORY ----
CREATE TABLE Category (
    category_id NVARCHAR2(255) PRIMARY KEY,
    name NVARCHAR2(255) NOT NULL UNIQUE
);

---- CATEGORY_BOOK ----
CREATE TABLE Categories_Book (
    book_id NVARCHAR2(255),
    category_id NVARCHAR2(255),
    PRIMARY KEY (book_id, category_id)
);

---- PUBLISHER ----
CREATE TABLE Publisher (
    publisher_id NVARCHAR2(255) PRIMARY KEY,
    name NVARCHAR2(255) NOT NULL UNIQUE
);

---- USER ----
CREATE TABLE "User" (
    user_id NVARCHAR2(255) PRIMARY KEY,
    login NVARCHAR2(255) NOT NULL UNIQUE,
    password RAW(64) NOT NULL,
    role_id NVARCHAR2(255),
    name NVARCHAR2(255) NOT NULL,
    second_name NVARCHAR2(255),
    email NVARCHAR2(255),
    address NVARCHAR2(255)
);

---- FAVORITES ----
CREATE TABLE Favorites (
    user_id NVARCHAR2(255),
    book_id NVARCHAR2(255),
    PRIMARY KEY (user_id, book_id)
);

---- ORDER ----
CREATE TABLE "Order" (
    order_id NVARCHAR2(255) PRIMARY KEY,
    user_id NVARCHAR2(255),
    order_date DATE,
    status_id NVARCHAR2(255)
);

---- STATUS ----
CREATE TABLE Status (
    status_id NVARCHAR2(255) PRIMARY KEY,
    start_time DATE,
    end_time DATE
);

---- ROLE ----
CREATE TABLE Role (
    role_id NVARCHAR2(255) PRIMARY KEY,
    name NVARCHAR2(255) NOT NULL UNIQUE

);


---- KEY, CONSTRAINT ----

---- Book table ----
ALTER TABLE Book ADD CONSTRAINT fk_publisher FOREIGN KEY (publisher_id) REFERENCES Publisher(publisher_id);

---- Book_Author table ----
ALTER TABLE Book_Author ADD CONSTRAINT fk_book FOREIGN KEY (book_id) REFERENCES Book(book_id);
ALTER TABLE Book_Author ADD CONSTRAINT fk_author FOREIGN KEY (author_id) REFERENCES Author(author_id);

---- Categories_Book table ----
ALTER TABLE Categories_Book ADD CONSTRAINT fk_cat_book FOREIGN KEY (book_id) REFERENCES Book(book_id);
ALTER TABLE Categories_Book ADD CONSTRAINT fk_cat FOREIGN KEY (category_id) REFERENCES Category(category_id);

---- User table ----
ALTER TABLE "User" ADD CONSTRAINT fk_user_role FOREIGN KEY (role_id) REFERENCES Role(role_id);

---- Favorites table ---- 
ALTER TABLE Favorites ADD CONSTRAINT fk_fav_user FOREIGN KEY (user_id) REFERENCES "User"(user_id);
ALTER TABLE Favorites ADD CONSTRAINT fk_fav_book FOREIGN KEY (book_id) REFERENCES Book(book_id);

---- Order table ----
ALTER TABLE "Order" ADD CONSTRAINT fk_order_user FOREIGN KEY (user_id) REFERENCES "User"(user_id);
ALTER TABLE "Order" ADD CONSTRAINT fk_order_status FOREIGN KEY (status_id) REFERENCES Status(status_id); 
ALTER TABLE "Order" ADD CONSTRAINT fk_order_book FOREIGN KEY (book_id) REFERENCES Book(book_id);

---- STATUS ----
ALTER TABLE Status
ADD CONSTRAINT chk_status_name CHECK (name IN ('Выдан', 'Завершен', 'В процессе', 'Отменен'));