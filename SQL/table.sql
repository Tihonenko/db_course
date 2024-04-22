
--CREATE TABLE

---- BOOK ----
CREATE TABLE Book (
    book_id RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    title NVARCHAR2(255) NOT NULL,
    description NCLOB,
    publication_date DATE,
    publisher_id RAW(16) 
);

---- AUTHOR ----
CREATE TABLE Author (
    author_id RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    name NVARCHAR2(255) NOT NULL
);

---- BOOK_AUTHOR ----
CREATE TABLE Book_Author (
    book_id RAW(16),
    author_id RAW(16),
    PRIMARY KEY (book_id, author_id)
);

---- CATEGORY ----
CREATE TABLE Category (
    category_id RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    name NVARCHAR2(255) NOT NULL
);

---- CATEGORY_BOOK ----
CREATE TABLE Categories_Book (
    book_id RAW(16),
    category_id RAW(16),
    PRIMARY KEY (book_id, category_id)
);

---- PUBLISHER ----
CREATE TABLE Publisher (
    publisher_id RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    name NVARCHAR2(255) NOT NULL
);

---- USER ----
CREATE TABLE "User" (
    user_id RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    username NVARCHAR2(255) NOT NULL UNIQUE,
    password RAW(64) NOT NULL,
    name NVARCHAR2(255) NOT NULL;
    role_id RAW(16) 
);

---- FAVORITES ----
CREATE TABLE Favorites (
    user_id RAW(16),
    book_id RAW(16),
    PRIMARY KEY (user_id, book_id)
);

---- ORDER ----
CREATE TABLE "Order" (
    order_id RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    user_id RAW(16),
    order_date DATE,
    status_id RAW(16)
);

---- STATUS ----
CREATE TABLE Status (
    status_id RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    name NVARCHAR2(255) NOT NULL
);

---- ROLE ----
CREATE TABLE Role (
    role_id RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    name NVARCHAR2(255) NOT NULL
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

---- ADD MORE ----

---- "User" ----
ALTER TABLE "User" ADD email NVARCHAR2(255);
ALTER TABLE "User" ADD address NVARCHAR2(255);
ALTER TABLE "User" ADD (name NVARCHAR2(255) NOT NULL);
ALTER TABLE "User" ADD second_name NVARCHAR2(255);

---- BOOK ----
ALTER TABLE BOOK ADD (isbn NVARCHAR2(255) NOT NULL);
ALTER TABLE BOOK ADD tags NVARCHAR2(60);
ALTER TABLE BOOK ADD num_pages INTEGER; 

---- STATUS ----
ALTER TABLE Status ADD (start_time DATE NOT NULL);
ALTER TABLE Status ADD (end_time DATE NOT NULL); 
