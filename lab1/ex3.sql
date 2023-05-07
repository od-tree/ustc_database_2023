drop procedure if exists updateReaderID;

DELIMITER //
CREATE PROCEDURE updateReaderID(IN old_ID CHAR(8), IN new_ID CHAR(8))
BEGIN
    -- 检查新的读者号是否已经存在
    IF EXISTS(SELECT 1 FROM reader WHERE ID = new_ID) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'New reader ID already exists';
    END IF;
    SET FOREIGN_KEY_CHECKS = 0;
    UPDATE reader SET ID=new_ID WHERE ID=old_ID;

    UPDATE borrow SET reader_ID = new_ID WHERE reader_ID=old_ID;
    UPDATE reserve SET reader_ID =new_ID WHERE reader_ID=old_ID;

    SET FOREIGN_KEY_CHECKS = 1;

END //
DELIMITER ;
