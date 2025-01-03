-- Business Request - 1 : City Level Fare and Trip Summary Report 
/* Generate a report that displays the total trips, average fare per km, average fare per trip and 
the percentage contribution of each city's trips to the overall trips. 
This report will help in assessing trip volume, pricing efficiency and each city's contribution to 
the overall trip count. 
Fields:
city_name, total_trips, average_fare_per_km,
average_fare_per_trip, percent_contribution_to_total_trips */

SELECT 
      c.city_name, 
      COUNT(trip_id) AS total_trips, 
      ROUND((SUM(fare_amount)/SUM(distance_travelled_km)),2) AS Avg_fare_per_km,
      ROUND((SUM(fare_amount)/COUNT(trip_id)),2) AS Avg_fare_per_trip,
      ROUND(Count(trip_id)*100/(select count(trip_id) from fact_trips),2) 
	  AS total_trips_cont_percentage 
FROM fact_trips t
JOIN dim_city c
     ON  c.city_id = t.city_id
GROUP BY t.city_id
ORDER BY total_trips_cont_percentage DESC;




