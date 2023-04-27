#查询读者 Rose 借过的读书（包括已还和未还）的图书号、书名和借期
SELECT Borrow.book_ID, Book.name, Borrow.borrow_Date
FROM Borrow
JOIN Book ON Borrow.book_ID = Book.ID
JOIN reader ON borrow.reader_ID = reader.ID
WHERE reader.name = 'Rose';

#查询从没有借过图书也从没有预约过图书的读者号和读者姓名；
SELECT ID, name
FROM Reader
WHERE ID NOT IN (
    SELECT reader_ID
    FROM Borrow
    UNION
    SELECT reader_ID
    FROM Reserve
);

#查询被借阅次数最多的作者
SELECT author, SUM(borrow_Times) AS total_borrow_times
FROM Book
GROUP BY author
ORDER BY total_borrow_times DESC
LIMIT 1;

#查询目前借阅未还的书名中包含“MySQL”的的图书号和书名
SELECT Book.name,Borrow.book_ID
FROM Borrow
JOIN Book on borrow.book_ID = Book.ID
WHERE Borrow.return_Date IS NULL
AND Book.name like '%MySQL%';

#查询借阅图书数目超过 10 本的读者姓名
SELECT r.name
FROM borrow
JOIN reader r on borrow.reader_ID = r.ID
GROUP BY Borrow.reader_ID
HAVING COUNT(*) >10;

# 查询没有借阅过任何一本 John 所著的图书的读者号和姓名
SELECT ID, name
FROM Reader
WHERE ID NOT IN (
    SELECT Borrow.reader_ID
    FROM Borrow
    JOIN Book ON Borrow.book_ID = Book.ID
    WHERE Book.author = 'John'
);

#查询 2022 年借阅图书数目排名前 10 名的读者号、姓名以及借阅图书数
SELECT r.name,borrow.reader_ID,count(*) as sum
FROM borrow
JOIN reader r on borrow.reader_ID = r.ID
WHERE YEAR(borrow_Date)=2022
GROUP BY Borrow.reader_ID
ORDER BY sum DESC
LIMIT 10;

#创建一个读者借书信息的视图,该视图包含读者号、姓名、所借图书号、图书名和借期；并使用该视图查询最近一年所有读者的读者号以及所借阅的不同图书数;
CREATE VIEW ReaderBorrowInfo AS
SELECT Borrow.reader_ID, Reader.name, Borrow.book_ID, Book.name AS book_name, Borrow.borrow_Date
FROM Borrow
JOIN Reader ON Borrow.reader_ID = Reader.ID
JOIN Book ON Borrow.book_ID = Book.ID;
SELECT reader_ID, COUNT(DISTINCT book_ID) AS total_borrow_books
FROM ReaderBorrowInfo
WHERE borrow_Date >= date_sub(curdate(),interval 1 year )
GROUP BY reader_ID;
