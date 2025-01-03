-- Business Request - 2 : Monthly City Level Trips Target Performance Report
/* Generate a report that evaluates the target performance for trips at the monthly and city level. 
For each city and month, compare the actual total trips with the target trips and categorise the performance as follows:
If actual trips are greater than target trips, mark it as "Above Target".
If actual trips are less than or equal to target trips, mark it as "Below Target".
Additionally calculate the precent difference between actual and target trips to quantify the performance gap.
Fields:
city_name, month_name, actual_trips, total_target_trips,
performance_status, percent_difference */

WITH actual_trips AS (
	SELECT 
		city_name, 
		monthname(date) as month_name, 
		count(trip_id) as actual_trips 
	FROM trips_db.fact_trips ft JOIN trips_db.dim_city dc on ft.city_id = dc.city_id
GROUP BY city_name, month_name
),

target_trips AS (
	SELECT 
    city_name,
    monthname(month) AS month_name, 
    total_target_trips AS target_trips
FROM targets_db.monthly_target_trips tr JOIN trips_db.dim_city dc on tr.city_id = dc.city_id
),

combined_table AS (
	SELECT
		act.city_name, act.month_name,
        actual_trips, target_trips,
        CASE
			WHEN  actual_trips > target_trips THEN  "Above Target"
            WHEN  actual_trips < target_trips THEN  "Below Target"
		END AS performance_status,
        ROUND((actual_trips-target_trips)*100/target_trips,2) AS percent_difference
	FROM actual_trips act JOIN target_trips trt 
    ON act.city_name = trt.city_name AND act.month_name = trt.month_name
)

SELECT * FROM combined_table
ORDER BY city_name,
case when month_name = "January" then 1
when month_name = "February" then 2
when month_name = "March" then 3
when month_name = "April" then 4
when month_name = "May" then 5
when month_name = "June" then 6
when month_name = "July" then 7
when month_name = "August" then 8
when month_name = "September" then 9
when month_name = "October" then 10
when month_name = "November" then 11
when month_name = "December" then 12 end;
