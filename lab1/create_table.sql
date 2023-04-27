-- 创建图书表
use lab1;
CREATE TABLE Book (
    ID CHAR(8) PRIMARY KEY,
    name VARCHAR(10) NOT NULL,
    author VARCHAR(10),
    price FLOAT,
    status INT DEFAULT 0,
    borrow_Times INT DEFAULT 0,
    reserve_Times INT DEFAULT 0,
    CHECK  ( status IN (0,1,2) )
);

-- 创建读者表
CREATE TABLE Reader (
    ID CHAR(8) PRIMARY KEY,
    name VARCHAR(10),
    age INT,
    address VARCHAR(20)
);

-- 创建借阅表
CREATE TABLE Borrow (
    book_ID CHAR(8),
    reader_ID CHAR(8),
    borrow_Date DATE,
    return_Date DATE,
    PRIMARY KEY (book_ID, reader_ID, borrow_Date),
    FOREIGN KEY (book_ID) REFERENCES Book(ID),
    FOREIGN KEY (reader_ID) REFERENCES Reader(ID)
);

-- 创建预约表
CREATE TABLE Reserve (
    book_ID CHAR(8),
    reader_ID CHAR(8),
    reserve_Date  date not null DEFAULT (NOW()),
    take_Date DATE,
    PRIMARY KEY (book_ID, reader_ID, reserve_Date),
    FOREIGN KEY (book_ID) REFERENCES Book(ID),
    FOREIGN KEY (reader_ID) REFERENCES Reader(ID),
    CHECK (take_Date > reserve_Date)
);
