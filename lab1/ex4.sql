drop procedure if exists borrowBook;
DELIMITER //

CREATE PROCEDURE borrowBook(
    IN p_bookID CHAR(8),
    IN p_readerID CHAR(8)
#     OUT state int
)
BEGIN
    DECLARE curDate DATE;
    DECLARE bookStatus INT;
    DECLARE bookReserve INT;
    DECLARE readerBorrow INT;
    DECLARE readerReserve INT;
    DECLARE canBorrow BOOL DEFAULT TRUE;

    -- 获取当前日期
    SET curDate = CURRENT_DATE();

    -- 获取图书状态和预约人数
    SELECT status, reserve_Times INTO bookStatus, bookReserve
    FROM Book
    WHERE ID = p_bookID;

    -- 判断是否可以借阅
    IF NOT EXISTS(SELECT 1 FROM reader WHERE ID = p_readerID) THEN
        SET canBorrow = FALSE;
#         SET state = 1;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'reader ID not exists';
    ELSEIF NOT EXISTS(SELECT 1 FROM Book WHERE ID = p_bookID) THEN
        SET canBorrow = FALSE;
#         SET state = 1;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'book ID not exists';

    ELSEIF bookStatus = 1 THEN
        SET canBorrow = FALSE;
#         SET state = 1;
    ELSEIF bookReserve > 0 THEN
        -- 如果有预约记录，判断当前借阅者是否已经预约了该图书
        SELECT COUNT(*) INTO readerReserve
        FROM Reserve
        WHERE book_ID = p_bookID AND reader_ID = p_readerID;

        IF readerReserve = 0 THEN
            SET canBorrow = FALSE;
#             SET state = 2;
        END IF;
    END IF;

    -- 如果可以借阅，则继续判断读者是否已经借阅了3本图书
    IF canBorrow THEN
        SELECT COUNT(*) INTO readerBorrow
        FROM Borrow
        WHERE reader_ID = p_readerID AND return_Date IS NULL;

        IF readerBorrow >= 3 THEN
            SET canBorrow = FALSE;
#             SET state = 0;
        END IF;

        SELECT COUNT(*) INTO readerBorrow
        FROM Borrow
        WHERE reader_ID = p_readerID AND book_ID=p_bookID AND borrow_Date=curDate;

        IF readerBorrow != 0 THEN
            SET canBorrow = FALSE;
#             SET state = 0;
        END IF;
    END IF;

    -- 如果可以借阅，则插入借阅记录并更新图书表和预约表
    IF canBorrow THEN
        INSERT INTO Borrow VALUES (p_bookID, p_readerID, curDate,NULL);

        UPDATE Book
        SET status = 1, borrow_Times = borrow_Times + 1
        WHERE ID = p_bookID;

        DELETE FROM Reserve
        WHERE book_ID = p_bookID AND reader_ID = p_readerID;

        SELECT '借书成功';
    ELSE
        SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'can not borrow';
    END IF;

END //

DELIMITER ;
