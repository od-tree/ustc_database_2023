# drop trigger if exists reserve_book;
# drop trigger if exists returnUpdate;


CREATE TRIGGER reserve_book
AFTER INSERT ON Reserve
FOR EACH ROW
BEGIN
    UPDATE Book SET status = IF(Book.status=1, 1, 2), reserve_Times = reserve_Times + 1 WHERE Book.ID = NEW.book_ID;
END;

CREATE TRIGGER returnUpdate
AFTER DELETE ON Reserve
FOR EACH ROW
BEGIN
    UPDATE Book SET reserve_Times = reserve_Times - 1 WHERE Book.ID = OLD.book_ID;
    UPDATE Book SET status=IF(Book.status=2 and Book.reserve_Times=0,0,Book.status) WHERE Book.ID = OLD.book_ID;
END;

