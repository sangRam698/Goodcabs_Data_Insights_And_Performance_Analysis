-- Business Reuest - 3 : City Level Repeat Passenger Trip Frequency Report
/* Generate a report that shows the percentage distribution of repeat passengers by the number of trips they have taken in each city. 
Calculate the percentage of repeat passengers who took 2 trips, 3 trips, and so on, up to 10 trips.
Each column should represent a trip count category, displaying the percentage of repeat passengers 
who fall into that category out of the total repeat passengers for that city.
This report will help identify cities with high repeat trip frequency, which can indicate strong customer loyalty or frequent usage patterns.
Fields:
city_name,
2-trips, 3-trips,... 10-trips */

WITH total_repeat_passengers AS (
	SELECT
		dc.city_name,
		SUM(repeat_passenger_count) AS total_repeat_passengers
	FROM dim_repeat_trip_distribution rtd
	JOIN dim_city dc ON rtd.city_id = dc.city_id
	GROUP BY dc.city_name
),

trip_count AS (
	SELECT
		dc.city_name, drtd.trip_count,
        SUM(repeat_passenger_count) AS repeat_passenger_count
	FROM dim_city dc JOIN dim_repeat_trip_distribution drtd on dc.city_id = drtd.city_id
    GROUP BY dc.city_name, drtd.trip_count
    ),
    
final_table AS (
	SELECT
		t.city_name, trip_count, repeat_passenger_count ,total_repeat_passengers
	FROM total_repeat_passengers t 
    JOIN trip_count tc ON t.city_name = tc.city_name
    )
 
 SELECT 
	city_name,
    ROUND((SUM((CASE WHEN trip_count = "2-Trips" THEN repeat_passenger_count ELSE 0 END))/total_repeat_passengers)*100,2) AS 2_Trips,
    ROUND((SUM((CASE WHEN trip_count = "3-Trips" THEN repeat_passenger_count ELSE 0 END))/total_repeat_passengers)*100,2) AS 3_Trips,
	ROUND((SUM((CASE WHEN trip_count = "4-Trips" THEN repeat_passenger_count ELSE 0 END))/total_repeat_passengers)*100,2) AS 4_Trips,
    ROUND((SUM((CASE WHEN trip_count = "5-Trips" THEN repeat_passenger_count ELSE 0 END))/total_repeat_passengers)*100,2) AS 5_Trips,
    ROUND((SUM((CASE WHEN trip_count = "6-Trips" THEN repeat_passenger_count ELSE 0 END))/total_repeat_passengers)*100,2) AS 6_Trips,
    ROUND((SUM((CASE WHEN trip_count = "7-Trips" THEN repeat_passenger_count ELSE 0 END))/total_repeat_passengers)*100,2) AS 7_Trips,
    ROUND((SUM((CASE WHEN trip_count = "8-Trips" THEN repeat_passenger_count ELSE 0 END))/total_repeat_passengers)*100,2) AS 8_Trips,
    ROUND((SUM((CASE WHEN trip_count = "9-Trips" THEN repeat_passenger_count ELSE 0 END))/total_repeat_passengers)*100,2) AS 9_Trips,
    ROUND((SUM((CASE WHEN trip_count = "10-Trips" THEN repeat_passenger_count ELSE 0 END))/total_repeat_passengers)*100,2) AS 10_Trips    
 FROM final_table
 GROUP BY city_name ORDER BY city_name;
    



