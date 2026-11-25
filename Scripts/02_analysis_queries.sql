-- Percentages for every question
SELECT section, question, response, frequency,
       ROUND(100.0 * frequency / SUM(frequency) OVER (PARTITION BY question), 1) AS pct
FROM frequency_tables
ORDER BY section, question, frequency DESC;

-- KPI cards
SELECT
    SUM(CASE WHEN question = 'Support for subsidy removal' THEN frequency ELSE 0 END) AS households,
    ROUND(100.0 * SUM(CASE WHEN question = 'Cost of living increased' AND response = 'Yes' THEN frequency ELSE 0 END)
       / SUM(CASE WHEN question = 'Cost of living increased' THEN frequency ELSE 0 END), 1) AS pct_cost_of_living_up,
    ROUND(100.0 * SUM(CASE WHEN question = 'Overall financial burden increased' AND response = 'Yes' THEN frequency ELSE 0 END)
       / SUM(CASE WHEN question = 'Overall financial burden increased' THEN frequency ELSE 0 END), 1) AS pct_heavier_burden,
    ROUND(100.0 * SUM(CASE WHEN question = 'Support for subsidy removal' AND response = 'Do not support' THEN frequency ELSE 0 END)
       / SUM(CASE WHEN question = 'Support for subsidy removal' THEN frequency ELSE 0 END), 1) AS pct_oppose,
    ROUND(100.0 * SUM(CASE WHEN question = 'Confidence in government''s ability to manage it' AND response = 'No' THEN frequency ELSE 0 END)
       / SUM(CASE WHEN question = 'Confidence in government''s ability to manage it' THEN frequency ELSE 0 END), 1) AS pct_doubt_government
FROM frequency_tables;

-- spending lines that went up (% of households saying yes)
SELECT question, ROUND(100.0 * SUM(CASE WHEN response = 'Yes' THEN frequency ELSE 0 END) / SUM(frequency), 1) AS pct_yes
FROM frequency_tables
WHERE section IN ('Cost of living', 'Coping strategies')
GROUP BY question
ORDER BY pct_yes DESC;
