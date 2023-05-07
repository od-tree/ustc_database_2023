drop procedure if exists returnBook;

DELIMITER //

CREATE PROCEDURE returnBook(IN bookID CHAR(8), IN readerID CHAR(8))
BEGIN
    -- 检查该读者是否借阅了该图书
    IF NOT EXISTS (SELECT * FROM borrow WHERE book_ID = bookID AND reader_ID = readerID AND return_date IS NULL) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '该读者未借阅该图书或者已归还';
    ELSE
    -- 更新借阅记录表中的归还日期

        UPDATE Borrow
        SET return_date = DATE(NOW())
        WHERE book_ID = bookID AND reader_ID = readerID AND return_date IS NULL;

    -- 更新借阅记录中对应图书的状态
        UPDATE Book
        SET status = IF(Book.reserve_Times=0, 0, 2)
        WHERE ID = bookID;

#     -- 返回成功信息
        SELECT '还书成功';
    END IF;
END //

DELIMITER ;
