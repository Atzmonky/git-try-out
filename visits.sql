WITH visits_seq AS (
  SELECT
    client_id,
    start_date,
    end_date,
    datediff,
    LAG(end_date) OVER (PARTITION BY client_id ORDER BY start_date) AS previous_end_date
  FROM
    visits
)

SELECT
  client_id,
  start_date,
  datediff,
  end_date,
  COALESCE(
    SUM(CASE WHEN start_date <= DATEADD(day, 7, previous_end_date) THEN 0 ELSE 1 END)
    OVER (PARTITION BY client_id ORDER BY start_date ROWS UNBOUNDED PRECEDING), 0
          ) AS traject_id
FROM
  visits_seq;
