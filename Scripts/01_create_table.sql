-- One long table holding every frequency table from the study report
-- (load Data/frequency_tables.csv into it)
DROP TABLE IF EXISTS frequency_tables;

CREATE TABLE frequency_tables (
    section   TEXT,
    question  TEXT,
    response  TEXT,
    frequency INTEGER
);
