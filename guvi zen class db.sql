create database zen_admin;
use zen_admin;
CREATE TABLE users (user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('student', 'mentor') NOT NULL,
    join_date DATE,
    mentor_id INT,
    FOREIGN KEY (mentor_id) REFERENCES users(user_id) ON DELETE SET NULL
);
select * from users;
CREATE TABLE codekata (
    codekata_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    problem_id INT,
    solved_at DATETIME,
    score INT,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);
CREATE TABLE attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    date DATE NOT NULL,
    status ENUM('present', 'absent', 'late', 'excused') NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);
CREATE TABLE tasks (
    task_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    task_name VARCHAR(255) NOT NULL,
    description TEXT,
    due_date DATE,
    status ENUM('not started', 'in progress', 'completed', 'overdue') DEFAULT 'not started',
    assigned_at DATETIME,
    completed_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);
CREATE TABLE company_drives (
    drive_id INT AUTO_INCREMENT PRIMARY KEY,
    company_name VARCHAR(255) NOT NULL,
    drive_date DATE NOT NULL,
    location VARCHAR(255),
    eligibility_criteria TEXT,
    drive_status ENUM('upcoming', 'ongoing', 'completed') DEFAULT 'upcoming'
);
CREATE TABLE mentors (
    mentor_id INT,
    mentee_id INT,
    PRIMARY KEY (mentor_id, mentee_id),
    FOREIGN KEY (mentor_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (mentee_id) REFERENCES users(user_id) ON DELETE CASCADE
);
INSERT INTO users (name, email, password, role, join_date) VALUES
('Alice', 'alice@example.com', 'password123', 'student', '2024-01-15'),
('Bob', 'bob@example.com', 'password123', 'student', '2024-01-20'),
('Charlie', 'charlie@example.com', 'password123', 'mentor', '2023-12-10'),
('David', 'david@example.com', 'password123', 'student', '2024-01-22'),
('Eve', 'eve@example.com', 'password123', 'student', '2024-01-25'),
('Frank', 'frank@example.com', 'password123', 'student', '2024-01-28'),
('Grace', 'grace@example.com', 'password123', 'mentor', '2023-11-05'),
('Hank', 'hank@example.com', 'password123', 'student', '2024-02-01');
select * from users;

UPDATE users AS s
JOIN (SELECT user_id FROM users WHERE name = 'Charlie') AS m
SET s.mentor_id = m.user_id
WHERE s.name IN ('Bob', 'David');

UPDATE users AS s
JOIN (SELECT user_id FROM users WHERE name = 'Grace') AS m
SET s.mentor_id = m.user_id
WHERE s.name IN ('Eve', 'Frank', 'Hank','Alice');

INSERT INTO codekata (user_id, problem_id, solved_at, score) VALUES
(1, 101, '2024-02-01 14:30:00', 100),
(2, 102, '2024-02-01 15:00:00', 95),
(4, 103, '2024-02-02 16:00:00', 80),
(5, 104, '2024-02-03 17:30:00', 85),
(6, 105, '2024-02-04 18:45:00', 90),
(8, 106, '2024-02-05 19:00:00', 88),
(2, 107, '2024-02-06 20:15:00', 92);

INSERT INTO attendance (user_id, date, status) VALUES
(1, '2024-02-01', 'present'),
(2, '2024-02-01', 'absent'),
(4, '2024-02-01', 'present'),
(5, '2024-02-02', 'late'),
(6, '2024-02-02', 'present'),
(8, '2024-02-03', 'present'),
(1, '2024-02-03', 'present'),
(2, '2024-02-04', 'excused'),
(5, '2024-02-04', 'present');

INSERT INTO tasks (user_id, task_name, description, due_date, status, assigned_at) VALUES
(1, 'Build a Portfolio', 'Create a portfolio website using React', '2024-03-01', 'in progress', '2024-02-01 10:00:00'),
(2, 'Complete Codekata 100', 'Solve 100 CodeKata problems', '2024-03-05', 'not started', '2024-02-01 11:00:00'),
(4, 'Design a Blog', 'Design and implement a blog using Next.js', '2024-03-10', 'in progress', '2024-02-02 09:30:00'),
(5, 'API Integration', 'Integrate third-party APIs into the project', '2024-03-15', 'not started', '2024-02-02 12:00:00'),
(6, 'Test Automation', 'Write test cases for automation testing', '2024-03-20', 'not started', '2024-02-03 14:00:00'),
(8, 'Database Optimization', 'Optimize database queries for performance', '2024-03-25', 'in progress', '2024-02-04 16:30:00');


INSERT INTO company_drives (company_name, drive_date, location, eligibility_criteria) VALUES
('TechCorp', '2024-04-15', 'Bangalore', 'B.Tech with 70%+ in aggregate'),
('Innovatech', '2024-05-10', 'Hyderabad', 'Any degree with 60%+ in aggregate'),
('AlphaTech', '2024-05-25', 'Pune', 'B.Tech/M.Tech with 75%+ in aggregate'),
('BetaSoft', '2024-06-05', 'Chennai', 'Any degree with 65%+ in aggregate'),
('GammaSolutions', '2024-06-15', 'Delhi', 'B.Sc/BCA with 70%+ in aggregate'),
('DeltaCorp', '2024-07-01', 'Mumbai', 'MBA with 65%+ in aggregate');

INSERT INTO mentors (mentor_id, mentee_id) VALUES
((SELECT user_id FROM users WHERE name = 'Charlie'), (SELECT user_id FROM users WHERE name = 'Bob')),
((SELECT user_id FROM users WHERE name = 'Charlie'), (SELECT user_id FROM users WHERE name = 'David')),
((SELECT user_id FROM users WHERE name = 'Grace'), (SELECT user_id FROM users WHERE name = 'Alice')),
((SELECT user_id FROM users WHERE name = 'Grace'), (SELECT user_id FROM users WHERE name = 'Eve')),
((SELECT user_id FROM users WHERE name = 'Grace'), (SELECT user_id FROM users WHERE name = 'Frank')),
((SELECT user_id FROM users WHERE name = 'Grace'), (SELECT user_id FROM users WHERE name = 'Hank'));
select * from mentors;

SELECT * FROM users WHERE role = 'student';
SELECT * FROM company_drives WHERE drive_date > '2024-04-01';
select s.name as student_name, m.name as mentor_name from users s left join users m on s.mentor_id = m.user_id 
where s.role = 'student';
SELECT u.name, a.date, a.status
FROM users u
JOIN attendance a ON u.user_id = a.user_id
WHERE a.date = '2024-02-01' AND u.role = 'student';
SELECT m.name AS mentor_name, COUNT(s.user_id) AS student_count
FROM users s
JOIN users m ON s.mentor_id = m.user_id
WHERE s.role = 'student'
GROUP BY m.name;
SELECT u.name, AVG(c.score) AS average_score
FROM users u
JOIN codekata c ON u.user_id = c.user_id
WHERE u.role = 'student'
GROUP BY u.name;

select u.name, t.task_name, t.completed_at, t.due_date from users u join tasks t on u.user_id = t.user_id 
where t.status = 'in progress';
UPDATE tasks set status = 'completed', completed_at = NOW() where task_id=1;
select * from tasks;
delete from attendance where date < date_sub(curdate(), INTERVAL 1 YEAR);
SELECT u.name
FROM users u
LEFT JOIN codekata c ON u.user_id = c.user_id
WHERE c.codekata_id IS NULL;
SELECT u.name, cd.company_name
FROM users u
JOIN company_drives cd ON cd.drive_id IN (
    SELECT drive_id FROM attendance a WHERE a.user_id = u.user_id AND a.status = 'present'
)
WHERE u.role = 'student';
