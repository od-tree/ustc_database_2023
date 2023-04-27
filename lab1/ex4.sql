DELIMITER //

CREATE PROCEDURE borrowBook(
    IN p_bookID CHAR(8),
    IN p_readerID CHAR(8),
    OUT state int
)
BEGIN
    DECLARE curDate DATE;
    DECLARE bookStatus INT;
    DECLARE bookReserve INT;
    SET curDate = CURRENT_DATE();
    SELECT status, reserve_Times INTO bookStatus,bookReserve
    FROM book
    WHERE ID = p_bookID;
END //

DELIMITER ;
