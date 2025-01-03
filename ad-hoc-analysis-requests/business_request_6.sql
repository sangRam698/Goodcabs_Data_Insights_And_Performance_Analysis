-- Business Request - 6 : Repeat Passenger Rate Analysis
/* Generate a report that calculates two metrics:
1. Monthly Repeat Passenger Rate: Calculate the repeat passenger rate for each city and month 
by comparing the number of repeat passengers to the total passengers.
2. City-wide Repeat Passenger Rate: Calculate the overall repeat passenger rate for each city, 
considering all passengers across months.
These metrics will provide insights into monthly repeat trends as well as the overall repeat behaviour for each city.
Fields:
city_name, month, total_passengers, repeat_passengers,
monthly_repeat_passenger_rate, city_repeat_passenger_rate */

WITH monthly_repeat_cal AS (
	SELECT 
	dc.city_name, month,
    total_passengers,
    repeat_passengers,
    ROUND((repeat_passengers/total_passengers)*100,2) AS monthly_repeat_passenger_rate
FROM dim_city dc JOIN fact_passenger_summary fps
ON dc.city_id = fps.city_id
),
city_repeat_cal AS (
	SELECT
	dc.city_name,
    ROUND((SUM(repeat_passengers)/SUM(total_passengers))*100,2) AS city_repeat_passenger_rate
 FROM dim_city dc JOIN fact_passenger_summary fps
ON dc.city_id = fps.city_id
GROUP BY city_name
)
SELECT c.city_name, month, total_passengers, repeat_passengers,
	monthly_repeat_passenger_rate, city_repeat_passenger_rate
FROM city_repeat_cal c JOIN monthly_repeat_cal m ON c.city_name = m.city_name
ORDER BY city_repeat_passenger_rate DESC


   
    
    