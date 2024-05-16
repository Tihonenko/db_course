ALTER SESSION SET "_oracle_script" = TRUE


CREATE PLUGGABLE DATABASE pdb_lib
ADMIN USER admin_lib IDENTIFIED BY admin1234
FILE_NAME_CONVERT = ('opt/oracle/oradata/ORCL/pdbseed/', 'opt/oracle/oradata/ORCL/ORCLPDB1/pdbdata/');

ALTER PLUGGABLE DATABASE pdb_lib OPEN;

select * from V$PDBS;

CREATE ROLE conn_role;
GRANT CREATE SESSION TO conn_role;



---- DEFAULT ROLE ----
CREATE USER ADMIN_lib_pdb IDENTIFIED BY 1234;
ALTER USER ADMIN_lib_pdb ACCOUNT UNLOCK;

CREATE USER MANAGER_LIB_PDB IDENTIFIED BY 1234;
ALTER USER MANAGER_LIB_PDB ACCOUNT UNLOCK;
GRANT conn_role TO MANAGER_LIB_PDB;


CREATE USER USER_lib_pdb IDENTIFIED BY 1234;
ALTER USER USER_lib_pdb ACCOUNT UNLOCK;
GRANT conn_role TO USER_lib_pdb;


CREATE USER GUEST_lib_pdb IDENTIFIED BY 1234;
ALTER USER GUEST_lib_pdb ACCOUNT UNLOCK;
GRANT CREATE SESSION TO GUEST_lib_pdb;
GRANT conn_role TO GUEST_lib_pdb;

---- GRANT ADMIN ----
GRANT CREATE SESSION, DBA TO ADMIN_lib_pdb;
GRANT EXECUTE ON DBMS_CRYPTO TO ADMIN_lib_pdb;
GRANT EXECUTE ON SYS.DBMS_SYS_SQL TO ADMIN_lib_pdb;
GRANT EXECUTE ON SYS.utl_smtp to ADMIN_lib_pdb;

GRANT EXECUTE ON SYS.DBMS_SQL to ADMIN_LIB_PDB;
--MANAGER GRANT
GRANT EXECUTE ON create_book to MANAGER_LIB_PDB;
GRANT EXECUTE ON create_author to MANAGER_LIB_PDB;
GRANT EXECUTE ON create_category to MANAGER_LIB_PDB;
GRANT EXECUTE ON create_order_status to MANAGER_LIB_PDB;
GRANT EXECUTE ON create_publisher to MANAGER_LIB_PDB;
GRANT EXECUTE ON create_user to MANAGER_LIB_PDB;
GRANT EXECUTE ON change_password to MANAGER_LIB_PDB;
GRANT EXECUTE ON change_order_status to MANAGER_LIB_PDB;
GRANT EXECUTE ON update_author to MANAGER_LIB_PDB;
GRANT EXECUTE ON update_book to MANAGER_LIB_PDB;
GRANT EXECUTE ON update_category to MANAGER_LIB_PDB;
GRANT EXECUTE ON update_publisher to MANAGER_LIB_PDB;
GRANT EXECUTE ON update_user to MANAGER_LIB_PDB;
GRANT EXECUTE ON cancel_order to MANAGER_LIB_PDB;
GRANT EXECUTE ON get_all_authors to MANAGER_LIB_PDB;
GRANT EXECUTE ON get_all_books to MANAGER_LIB_PDB;
GRANT EXECUTE ON get_all_categories to MANAGER_LIB_PDB;
GRANT EXECUTE ON get_author_by_id to MANAGER_LIB_PDB;
GRANT EXECUTE ON get_book_by_id to MANAGER_LIB_PDB;
GRANT EXECUTE ON get_books_by_category to MANAGER_LIB_PDB;
GRANT EXECUTE ON get_books_by_author to MANAGER_LIB_PDB;
GRANT EXECUTE ON get_books_by_publisher to MANAGER_LIB_PDB;
GRANT EXECUTE ON get_category_by_id to MANAGER_LIB_PDB;
GRANT EXECUTE ON get_order_by_id to MANAGER_LIB_PDB;
GRANT EXECUTE ON get_orders_by_user_or_book to MANAGER_LIB_PDB;
GRANT EXECUTE ON get_orders_with_status to MANAGER_LIB_PDB;
GRANT EXECUTE ON get_user_by_id to MANAGER_LIB_PDB;
GRANT EXECUTE ON get_users_info to MANAGER_LIB_PDB;
GRANT EXECUTE ON search_books to MANAGER_LIB_PDB;



--USER GRANT
GRANT EXECUTE ON create_user to USER_LIB_PDB;
GRANT EXECUTE ON change_password to USER_LIB_PDB;
GRANT EXECUTE ON cancel_order to USER_LIB_PDB;
GRANT EXECUTE ON add_favorite_book to USER_LIB_PDB;
GRANT EXECUTE ON get_all_authors to USER_LIB_PDB;
GRANT EXECUTE ON get_all_books to USER_LIB_PDB;
GRANT EXECUTE ON get_all_categories to USER_LIB_PDB;
GRANT EXECUTE ON get_author_by_id to USER_LIB_PDB;
GRANT EXECUTE ON get_book_by_id to USER_LIB_PDB;
GRANT EXECUTE ON get_books_by_category to USER_LIB_PDB;
GRANT EXECUTE ON get_books_by_author to USER_LIB_PDB;
GRANT EXECUTE ON get_books_by_publisher to USER_LIB_PDB;
GRANT EXECUTE ON get_category_by_id to USER_LIB_PDB;
GRANT EXECUTE ON get_order_by_id to USER_LIB_PDB;
GRANT EXECUTE ON get_user_by_id to USER_LIB_PDB;
GRANT EXECUTE ON search_books to USER_LIB_PDB;

--GUEST GRANT
GRANT EXECUTE ON get_all_authors to GUEST_lib_pdb;
GRANT EXECUTE ON get_all_books to GUEST_lib_pdb;
GRANT EXECUTE ON get_all_categories to GUEST_lib_pdb;
GRANT EXECUTE ON get_author_by_id to GUEST_lib_pdb;
GRANT EXECUTE ON get_book_by_id to GUEST_lib_pdb;
GRANT EXECUTE ON get_books_by_category to GUEST_lib_pdb;
GRANT EXECUTE ON get_books_by_author to GUEST_lib_pdb;
GRANT EXECUTE ON get_books_by_publisher to GUEST_lib_pdb;
GRANT EXECUTE ON get_category_by_id to GUEST_lib_pdb;
GRANT EXECUTE ON search_books to GUEST_lib_pdb;
GRANT EXECUTE ON book_result_type TO GUEST_lib_pdb;
GRANT EXECUTE ON book_result_table TO GUEST_lib_pdb;
