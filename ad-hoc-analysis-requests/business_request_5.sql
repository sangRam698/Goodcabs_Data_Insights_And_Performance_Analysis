-- BUsiness Request - 5 : Identify Month With Highest Revenue for Each City
/* Generate a report that identifies the month with the highest revenue for each city. 
For each city, display the month name, the revenue amount for that month, and the percentage contribution of that month's revenue to the city's total revenue.
Fields:
city_name, highest_revenue_month, 
revenue, percent_contribution_to_city's_total_revenue */

WITH city_monthly_revenue_table AS ( 
 SELECT 
	dc.city_name,
    MONTHNAME(date) AS month_name,
    SUM(fare_amount) AS revenue,
    ROW_NUMBER() OVER(PARTITION BY dc.city_name ORDER BY SUM(fare_amount) DESC ) AS ranking
FROM dim_city dc JOIN fact_trips ft ON dc.city_id = ft.city_id
GROUP BY dc.city_name,month_name
),

city_revenue_table AS (
	SELECT city_name, SUM(revenue) AS city_revenue
	FROM city_monthly_revenue_table
	GROUP BY city_name
)

SELECT 
	r.city_name, month_name as highest_revenue_month,
    revenue,
    ROUND((revenue/city_revenue)*100,2) AS percentage_contribution
FROM city_monthly_revenue_table r JOIN  city_revenue_table cr ON  cr.city_name =r.city_name
WHERE ranking = 1 

    