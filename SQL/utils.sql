---- hash password ----
CREATE OR REPLACE FUNCTION hash_password (
    p_password IN NVARCHAR2
) RETURN NVARCHAR2
AS
    p_hash_raw RAW(32);
    p_hash_hex NVARCHAR2(255);
BEGIN
    p_hash_raw := DBMS_CRYPTO.HASH(UTL_I18N.STRING_TO_RAW(p_password, 'AL32UTF8'), DBMS_CRYPTO.HASH_SH256);
    p_hash_hex := UTL_ENCODE.base64_encode(p_hash_raw);
    RETURN p_hash_hex;
END;

---- check password ----
CREATE OR REPLACE FUNCTION validate_password (
    p_password IN NVARCHAR2,
    p_hashed_password IN NVARCHAR2  -- Stored Base64-encoded password
) RETURN BOOLEAN
AS
    l_hash RAW(32);
    l_hash_hex NVARCHAR2(255);
BEGIN
    l_hash := DBMS_CRYPTO.HASH(
        UTL_I18N.STRING_TO_RAW(p_password, 'AL32UTF8'),
        DBMS_CRYPTO.HASH_SH256
    );
    l_hash_hex := UTL_ENCODE.base64_encode(l_hash);

    RETURN l_hash_hex = p_hashed_password; 
END;
