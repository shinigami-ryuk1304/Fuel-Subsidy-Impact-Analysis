-- Query to calculate the percentage for every answer and group similar answers together

SELECT
    DENSE_RANK() OVER (ORDER BY section, question) AS QuestionID,  -- Links each row to dim_questions
    LTRIM(RTRIM(response)) AS Response,  -- The answer option
    frequency AS Frequency,  -- How many people gave this answer
    ROUND(100.0 * frequency / SUM(frequency) OVER (PARTITION BY question), 1) AS Percentage,  -- Share of people who gave this answer
    CASE  -- Groups answers that mean the same thing, so the charts are easier to read
        WHEN response IN ('Deteriorated', 'Significantly deteriorated') THEN 'Worse'
        WHEN response IN ('Do not support') THEN 'Oppose'
        WHEN response IN ('Do not believe') THEN 'Do not believe'
        ELSE response
    END AS ResponseGroup
FROM
    dbo.frequency_tables;
