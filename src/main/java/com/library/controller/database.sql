
CREATE DATABASE IF NOT EXISTS library_db;
USE library_db;


SET FOREIGN_KEY_CHECKS = 0;


DROP TABLE IF EXISTS room_booking;
DROP TABLE IF EXISTS borrow_records;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS room;
DROP TABLE IF EXISTS admins;
DROP TABLE IF EXISTS members;


CREATE TABLE admins (
                        id INT NOT NULL AUTO_INCREMENT,
                        username VARCHAR(50) NOT NULL,
                        password_hash VARCHAR(255) NOT NULL,
                        status VARCHAR(20) DEFAULT 'PENDING',
                        role VARCHAR(20) DEFAULT 'ADMIN',
                        PRIMARY KEY (id),
                        UNIQUE KEY username (username)
);

CREATE TABLE members (
                         member_id VARCHAR(50) NOT NULL,
                         full_name VARCHAR(100) NOT NULL,
                         email VARCHAR(100) NOT NULL,
                         password_hash VARCHAR(256) NOT NULL,
                         student_id VARCHAR(50) DEFAULT NULL,
                         role VARCHAR(20) DEFAULT 'STUDENT',
                         profile_image LONGBLOB,
                         created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
                         PRIMARY KEY (member_id),
                         UNIQUE KEY email (email)
);

CREATE TABLE books (
                       book_id INT NOT NULL AUTO_INCREMENT,
                       title VARCHAR(150) NOT NULL,
                       author VARCHAR(100) NOT NULL,
                       category VARCHAR(50) DEFAULT NULL,
                       status VARCHAR(20) DEFAULT 'AVAILABLE',
                       PRIMARY KEY (book_id)
);

CREATE TABLE room (
                      room_id INT AUTO_INCREMENT PRIMARY KEY,
                      room_name VARCHAR(50) NOT NULL,
                      capacity INT,
                      status VARCHAR(20) DEFAULT 'Available'
);

CREATE TABLE room_booking (
                              booking_id INT AUTO_INCREMENT PRIMARY KEY,
                              room_id INT NOT NULL,
                              member_id VARCHAR(50) NOT NULL,
                              booking_date DATE NOT NULL,
                              time_slot VARCHAR(50) NOT NULL,
                              status VARCHAR(20) DEFAULT 'Booked',

                              CONSTRAINT fk_room FOREIGN KEY (room_id) REFERENCES room(room_id) ON DELETE CASCADE,
                              CONSTRAINT fk_booking_member FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
                              CONSTRAINT uq_room_booking UNIQUE (room_id, booking_date, time_slot)
);


CREATE TABLE borrow_records (
                                record_id INT PRIMARY KEY AUTO_INCREMENT,
                                book_id INT NOT NULL,
                                member_id VARCHAR(50) NOT NULL,
                                borrow_date DATE NOT NULL,
                                due_date DATE NOT NULL,
                                return_date DATE DEFAULT NULL,
                                fine_amount DECIMAL(10, 2) DEFAULT 0.00,
                                status ENUM('Borrowed', 'Returned') DEFAULT 'Borrowed',

                                CONSTRAINT fk_book FOREIGN KEY (book_id) REFERENCES books(book_id),
                                CONSTRAINT fk_borrow_member FOREIGN KEY (member_id) REFERENCES members(member_id)
);




INSERT INTO admins (username, password_hash, status, role) VALUES
    ('admin', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'APPROVED', 'SUPER_ADMIN');


INSERT INTO members (member_id, full_name, email, password_hash, role, student_id)
VALUES ('s002', 'Kasun Perera', 'kasun@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'STUDENT', 's002');


INSERT INTO books (book_id, title, author, category, status) VALUES
                                                                 (1, 'Madol Doova', 'Martin Wickramasinghe', 'Novel', 'Borrowed'),
                                                                 (2, 'Gamperaliya', 'Martin Wickramasinghe', 'Novel', 'Available');

INSERT INTO room (room_id, room_name, capacity, status) VALUES
                                                            (1, 'Discussion Room A', 4, 'Available'),
                                                            (2, 'Quiet Room 1', 1, 'Available');


INSERT INTO borrow_records (member_id, book_id, borrow_date, due_date, status)
VALUES ('s002', 1, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY), 'Borrowed');

INSERT INTO borrow_records (member_id, book_id, borrow_date, due_date, return_date, status)
VALUES ('s002', 2, '2025-12-01', '2025-12-15', '2025-12-10', 'Returned');


INSERT INTO room_booking (member_id, room_id, booking_date, time_slot, status)
VALUES ('s002', 1, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '10:00 AM - 12:00 PM', 'Approved');

INSERT INTO room_booking (member_id, room_id, booking_date, time_slot, status)
VALUES ('s002', 2, DATE_SUB(CURDATE(), INTERVAL 7 DAY), '02:00 PM - 04:00 PM', 'Completed');


SET FOREIGN_KEY_CHECKS = 1;