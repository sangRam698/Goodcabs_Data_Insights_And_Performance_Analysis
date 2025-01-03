-- Business Request - 4 : Identify Cities With Highest and Lowest Total New
/* Generate a report that calculates the total new passengers for each city and ranks them based on this value. 
Identify the top 3 cities with the highest number of new passengers as well as the bottom 3 cities with the lowest number of new passengers, 
categorising them as "Top 3" or "Bottom 3" accordingly.
Fields:
city_name, total_new_passengers, city_category */

WITH ranking_table AS (
	SELECT 
	dc.city_name,
    SUM(new_passengers) AS total_new_passengers,
    ROW_NUMBER() OVER(ORDER BY SUM(new_passengers)) AS bottom_rank,
    ROW_NUMBER() OVER(ORDER BY SUM(new_passengers) DESC) AS top_rank
	FROM dim_city dc 
	JOIN fact_passenger_summary fps ON dc.city_id = fps.city_id
	GROUP BY dc.city_name
)

SELECT 
	city_name, total_new_passengers,
    CASE WHEN top_rank <= 3 THEN "Top 3"
		 WHEN bottom_rank <= 3 THEN "Bottom 3"
          ELSE NULL END AS city_category
 FROM ranking_table
 WHERE top_rank <= 3 OR bottom_rank <= 3
 ORDER BY total_new_passengers DESC;
    