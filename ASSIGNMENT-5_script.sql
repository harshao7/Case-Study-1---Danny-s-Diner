

-- 1. Check the entire dataset
select * from spotify;

-- 2. Number of songs on Spotify for each artist

select distinct artist_name, count(track_id) no_of_songs from spotify
group by artist_name
order by no_of_songs desc;

-- 3. Top 10 songs based on popularity
select  artist_name, track_name, album from spotify
order by artist_popularity
limit 10;

-- 4. Total number of songs on spotify based on year
select year, count(track_name) no_of_songs_per_year from spotify
group by year;

-- 5. Top song for each year (2000-2022) based on popularity


SELECT YEAR,TRACK_NAME,
MAX(TRACK_POPULARITY) AS TOP_SONG_OF_THE_YEAR
FROM spotify
WHERE YEAR BETWEEN 2000 AND 2022
GROUP BY 1
ORDER BY 1, 3 DESC;

SELECT track_name, track_popularity, year
FROM spotify where year = 2000;
 
-- Analysis based on Tempo : tempo > 121.08 -> 'Above Average Tempo' tempo = 121.08 -> 'Average Tempo' tempo < 121.08 -> 'Below Average Tempo'

SELECT track_name, artist_name, tempo,
CASE WHEN tempo > 121.08 THEN 'Above Average Tempo'
WHEN tempo = 121.08 THEN 'Average Tempo'
ELSE 'Below Average Tempo'
END AS tempo_class
FROM spotify;

-- Songs with Highest Tempo

SELECT track_name, artist_name, tempo
FROM spotify
ORDER BY tempo DESC
LIMIT 10;

-- Number of Songs for different Tempo Range : track_name, energy
-- Modern_Music -> tempo BETWEEN 60.00 AND 100.00
-- Classical_Music -> tempo BETWEEN 100.001 AND 120.00
-- Dance_Music -> tempo BETWEEN 120.001 AND 150.01
-- HighTempo_Music -> tempo > 150.01



SELECT track_name, energy,
CASE 
    WHEN tempo BETWEEN 60.00 AND 100.00 THEN 'Modern_Music'
    WHEN tempo BETWEEN 100.001 AND 120.00 THEN 'Classical_Music'
    WHEN tempo BETWEEN 120.001 AND 150.01 THEN 'Dance_Music'
    ELSE 'HighTempo_Music'
END AS tempo_range,
COUNT(*) AS num_songs
FROM spotify
GROUP BY  track_name, energy, tempo_range
ORDER BY num_songs desc;

-- Energy Analysis : TOP 10 track_name, danceability, track_popularity
-- energy > 0.64 -> 'Above Average Energy
-- energy = 0.64 -> 'Average Energy’
-- energy < 0.64 -> 'Below Average Energy’
-- energy BETWEEN 0.1 AND 0.3 -> 'Calm Music'
-- energy BETWEEN 0.3 AND 0.6 -> 'Moderate Music'
-- Energy >0.6 -> ‘Energetic Music'

select track_name, danceability, track_popularity,
	CASE 
		WHEN energy > 0.64 THEN 'Above Average Energy'
        WHEN energy = 0.64 THEN 'Average Energy'
        WHEN energy < 0.64 THEN 'Below Average Energy'
        WHEN energy BETWEEN 0.1 AND 0.3 THEN 'Calm Music'
		WHEN energy BETWEEN 0.3 AND 0.6 THEN 'Moderate Music'
		ELSE 'Energetic Music' 
	END AS energy_level
FROM spotify
ORDER BY energy_level, danceability DESC, track_popularity DESC
LIMIT 10;
        
-- 10. Number of Songs for different energy ranges

select energy_level, count(track_name) no_of_songs from (select track_name, danceability, track_popularity,
	CASE 
		WHEN energy > 0.64 THEN 'Above Average Energy'
        WHEN energy = 0.64 THEN 'Average Energy'
        WHEN energy < 0.64 THEN 'Below Average Energy'
        WHEN energy BETWEEN 0.1 AND 0.3 THEN 'Calm Music'
		WHEN energy BETWEEN 0.3 AND 0.6 THEN 'Moderate Music'
		ELSE 'Energetic Music' 
	END AS energy_level
FROM spotify
ORDER BY energy_level, danceability DESC, track_popularity DESC) energy_range
group by energy_level;

-- What are the top 20 songs on Spotify based on danceability, grouped by danceability level?
-- Low Danceability: Danceability between 0.69 and 0.79 or between 0.79 and 0.89
-- Moderate Danceability: Danceability between 0.49 and 0.68 or between 0.89 and 0.99
-- High Danceability: Danceability between 0.39 and 0.49 or between 0.99 and 1.00
-- Can't Dance on This One: Danceability less than 0.39 or greater than 1.00

SELECT track_name, danceability,
CASE 
	WHEN danceability BETWEEN 0.69 AND 0.79 THEN 'Low Danceability'
	WHEN danceability BETWEEN 0.49 AND 0.68 OR danceability BETWEEN 0.79 AND 0.89 THEN 'Moderate Danceability'
	WHEN danceability BETWEEN 0.39 AND 0.49 OR danceability BETWEEN 0.89 AND 0.99 THEN 'High Danceability'
ELSE "Can't Dance on This One" END AS danceability_level
FROM spotify
ORDER BY danceability desc
LIMIT 20;

-- 12. Number of Songs for different danceability ranges

SELECT danceability_range, COUNT(*) AS num_songs
FROM (
  SELECT track_name, danceability,
    CASE WHEN danceability BETWEEN 0.69 AND 0.79 THEN 'Low Danceability'
    WHEN danceability BETWEEN 0.49 AND 0.68 OR danceability BETWEEN 0.79 AND 0.89 THEN 'Moderate Danceability'
    WHEN danceability BETWEEN 0.39 AND 0.49 OR danceability BETWEEN 0.89 AND 0.99 THEN 'High Danceability'
    ELSE "Can't Dance on This One" END AS danceability_range
  FROM spotify
) AS danceability_ranges
GROUP BY danceability_range
ORDER BY danceability_range desc;



-- Loudness Analysis : Top 20 track_name, loudness,
-- loudness BETWEEN -23.00 AND -15.00 ->'Low Loudness'
-- loudness BETWEEN -14.99 AND -6.00 -> 'Below Average Loudness'
-- loudness BETWEEN -5.99 AND -2.90 -> 'Above Average Loudness'
-- loudness BETWEEN -2.89 AND -1.00 -> 'Peak Loudness'

SELECT track_name, loudness,
CASE 
	WHEN loudness BETWEEN -23.00 AND -15.00 THEN 'Low Loudness'
	WHEN loudness BETWEEN -14.99 AND -6.00 THEN 'Below Average Loudness'
	WHEN loudness BETWEEN -5.99 AND -2.90 THEN 'Above Average Loudness'
	WHEN loudness BETWEEN -2.89 AND -1.00 THEN 'Peak Loudness'
ELSE 'Not Sepcified'
END AS loudness_range
FROM spotify
ORDER BY loudness DESC
LIMIT 20;

-- 14. Number of Songs for different loudness ranges.

SELECT loudness_range, COUNT(*) AS num_songs
FROM ( SELECT track_name, loudness,
CASE 
	WHEN loudness BETWEEN -23.00 AND -15.00 THEN 'Low Loudness'
	WHEN loudness BETWEEN -14.99 AND -6.00 THEN 'Below Average Loudness'
	WHEN loudness BETWEEN -5.99 AND -2.90 THEN 'Above Average Loudness'
	WHEN loudness BETWEEN -2.89 AND -1.00 THEN 'Peak Loudness'
ELSE 'Not Sepcified'
END AS loudness_range
FROM spotify)  AS loudness_ranges
GROUP BY loudness_range
ORDER BY loudness_range;

-- 15. Valence Analysis : Top 20 track_name, valence, track_popularity,
-- valence > 0.535 -> Above Avg Valence
-- valence = 0.535 -> Avg Valence
-- valence < 0.535 -> Below Average'

SELECT track_name, valence, track_popularity,
CASE WHEN valence > 0.535 THEN 'Above Average Valence'
WHEN valence = 0.535 THEN 'Average Valence'
WHEN valence < 0.535 THEN 'Below Average Valence'
END AS valence_range
FROM spotify
ORDER BY valence DESC
LIMIT 20;

-- 16. Number of Songs for different valence ranges.

SELECT valence_range, COUNT(*) AS num_songs
FROM (
  SELECT track_name, valence,
    CASE WHEN valence > 0.535 THEN 'Above Average Valence'
    WHEN valence = 0.535 THEN 'Average Valence'
    WHEN valence < 0.535 THEN 'Below Average Valence'
    END AS valence_range
  FROM spotify
) AS valence_ranges
GROUP BY valence_range
ORDER BY num_songs desc;

-- 17. Speechiness Analsis : Top 20 track_name, speechiness, tempo,
 -- speechiness > 0.081-> Above Avg Speechiness
 -- speechiness = 0.081-> Avg Speechiness
 -- speechiness < 0.081-> Below Speechiness
 
 SELECT track_name, speechiness, tempo,
	CASE
		WHEN speechiness > 0.081 THEN "Above Avg Speechiness"
        WHEN speechiness = 0.081 THEN "Avg Speechiness"
        WHEN speechiness < 0.081 THEN "Below Speechiness"
	ELSE "Not Specified"
    END AS speechiness_range
 from spotify
 ORDER BY speechiness DESC
 LIMIT 20;
 
 SELECT speechiness_range, COUNT(*) AS num_songs
FROM (
  SELECT track_name, speechiness,
    CASE WHEN speechiness > 0.081 THEN 'Above Average Speechiness'
    WHEN speechiness = 0.081 THEN 'Average Speechiness'
    WHEN speechiness < 0.081 THEN 'Below Average Speechiness'
    END AS speechiness_range
  FROM spotify
) AS speechiness_ranges
GROUP BY speechiness_range
ORDER BY num_songs DESC;

 /* 18. Acoustic Analysis : DISTINCT TOP 25 track_name, album, artist_name, acousticness
 (acousticness BETWEEN 0 AND 0.40000 -> 'Not Acoustic'
 (acousticness BETWEEN 0.40001 AND 0.80000) ->'Acoustic'
 (acousticness BETWEEN 0.80001 AND 1) ->'Highly Acoustic' */
 
 
 SELECT DISTINCT track_name, album, artist_name, acousticness,
	CASE
		WHEN acousticness BETWEEN 0 AND 0.40000 THEN 'Not Acoustic'
		WHEN acousticness BETWEEN 0.40001 AND 0.80000 THEN 'Acoustic'
        ELSE 'Highly Acoustic' 
    END AS acousticness_range
FROM spotify
ORDER BY acousticness DESC
LIMIT 25;

