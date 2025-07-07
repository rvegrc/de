-- Active: 1748279811501@@localhost@5432@dbpg
-- clickhouse create user
create user user IDENTIFIED with sha256_password '12345';

-- create test table in pg
create table teacher (
    teacher_id serial
    ,first_name varchar
    ,last_name varchar
    ,birthday date
    ,phone varchar
    ,title varchar
);



alter table teacher
    add column  middle_name varchar;

alter table teacher
    drop column middle_name;

alter table teacher
    rename birthday to birth_date;

alter table teacher
    alter column phone type varchar(32);

drop table if exists exam;

create table exam (
    exam_id serial PRIMARY KEY
    ,exam_name varchar(256) UNIQUE
    ,exam_date date
    ,created_at timestamp DEFAULT CURRENT_TIMESTAMP
    ,updated_at timestamp DEFAULT CURRENT_TIMESTAMP  
);

insert into exam (exam_id, exam_name, exam_date) VALUES
    (1, 'Math Exam', '2023-10-01'),
    (2, 'Science Exam', '2023-10-02'),
    (3, 'History Exam', '2023-10-03');

-- insert to exam with autogeneration of exam_id
insert into exam (exam_id,exam_name, exam_date) VALUES
    (4,'English Exam', '2023-10-04'),
    (5,'Geography Exam', '2023-10-05');

insert into exam (exam_id,exam_name, exam_date) VALUES
    (6,'English Exam', '2023-10-04'),
    (7,'Geography Exam', '2023-10-05');

TRUNCATE TABLE exam RESTART IDENTITY;
