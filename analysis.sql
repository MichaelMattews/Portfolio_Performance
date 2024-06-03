WITH portfolio_agg AS (
  SELECT
    u.user_id,
    u.name AS user_name,
    p.portfolio_id,
    p.portfolio_name,
    p.value AS portfolio_value
  FROM
    users u
  LEFT JOIN
    portfolio p ON u.user_id = p.user_id
  ORDER BY
    u.user_id
),
investment_summary AS (
  SELECT
    portfolio_id,
    asset_name,
    SUM(quantity) AS total_quantity,
    AVG(current_price) AS current_price,
    AVG(purchase_price) AS purchase_price,
    SUM(quantity * current_price) AS investment_value,
    (AVG(current_price) - AVG(purchase_price)) / AVG(purchase_price) * 100 AS roi
  FROM
    investment
  GROUP BY
    portfolio_id, asset_name
)
SELECT
  p.user_id,
  p.user_name,
  p.portfolio_name,
  i.asset_name,
  SUM(i.investment_value) AS total_investment_value,
  SUM(i.investment_value) / MAX(p.portfolio_value) * 100 AS asset_allocation_percentage,
  AVG(i.roi) AS roi
FROM
  portfolio_agg p
LEFT JOIN
  investment_summary i ON p.portfolio_id = i.portfolio_id
GROUP BY
  p.user_id, p.user_name, p.portfolio_name, i.asset_name
ORDER BY
  p.user_id;