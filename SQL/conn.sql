ALTER SESSION SET "_oracle_script" = TRUE


CREATE PLUGGABLE DATABASE pdb_lib
ADMIN USER admin_lib IDENTIFIED BY admin1234
FILE_NAME_CONVERT = ('opt/oracle/oradata/ORCL/pdbseed/', 'opt/oracle/oradata/ORCL/ORCLPDB1/pdbdata/');

ALTER PLUGGABLE DATABASE pdb_lib OPEN;

select * from V$PDBS;


---- DEFAULT ROLE ----
CREATE USER ADMIN_lib_pdb IDENTIFIED BY 1234;
ALTER USER ADMIN_lib_pdb ACCOUNT UNLOCK;


---- GRANT ADMIN ----
GRANT CREATE SESSION, DBA TO ADMIN_lib_pdb;
GRANT EXECUTE ON DBMS_CRYPTO TO ADMIN_lib_pdb;
GRANT EXECUTE ON SYS.DBMS_SYS_SQL TO ADMIN_lib_pdb;
GRANT EXECUTE ON SYS.RAWTOHEX TO ADMIN_lib_pdb;
