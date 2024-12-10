/* Questions with thier respective SQL Query */

/* 1. What is the number of casualties on each day of the week? */

SELECT SUM(No_of_casualties), Day_of_week 
FROM UK_Accident; 

/* 2. On each day of the week, what is the maximum and minimum speed limit on the roads where the accidents
happened? */

SELECT day_of_week, max(speed_limit) AS "Maximum Speed", min(speed_limit) AS "Minimum Speed"
FROM uk_accident 
GROUP BY day_of_week;

/* 3. What is the importance of Light and Weather conditions in predicting accident severity? */

SELECT light_conditions, weather_conditions, COUNT(Accident_Severity)
FROM uk_accident
GROUP BY light_conditions, weather_conditions;

/*4.  What is the number of casualties on each type of road and the speed limit ofthe vehicle? */

SELECT sum(number_of_casualties), road_type, speed_limit
FROM uk_accident
GROUP BY road_type, speed_limit;

/* 5. Find out the total number of casualties caused in each year */

SELECT sum(number_of_casualties), year_of_accident
FROM uk_accident
GROUP BY year_of_accident;

/* 6. Find the number of vehicles involved when the number of casualties is the highest */

SELECT sum(number_of_casualties), number_of_vehicles
FROM uk_accident
GROUP BY number_of_vehicles;
