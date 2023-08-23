/* Q1: Which year saw the highest and lowest no of
countries participating in olympics? */

WITH t1 AS
 (SELECT games, nr.region AS country_count
 FROM olympics_history oh
 JOIN olympics_history_noc_regions nr 
 ON nr.noc=oh.noc),
 
t2 AS
 (SELECT games, COUNT(DISTINCT country) AS country_count
 FROM t1
 GROUP BY 1)
 
 SELECT games, country_count
 FROM t2
 WHERE country = (SELECT MAX(country) FROM t2) 
 OR country = (SELECT MIN (country) FROM t2)
 
/*Q2: Which nation has participated in all of the olympic games? */

 SELECT nr.region AS country, COUNT(DISTINCT games) AS games_played
 FROM olympics_history oh
 JOIN olympics_history_noc_regions nr 
 ON nr.noc=oh.noc
 GROUP BY 1
 HAVING COUNT(DISTINCT games) = 
 (SELECT  COUNT(DISTINCT games)
 FROM olympics_history)
 
/*Q3: Fetch the top 5 athletes who have won the most medals (gold/silver/bronze) */ 

with t1 as
 (SELECT name, team AS country, COUNT(Medal) medal_count
 FROM olympics_history
 WHERE medal in ('Gold', 'Silver', 'Bronze')
 GROUP BY 1,2 
 ORDER BY 3 DESC),
 
 t2 as
 (SELECT *, DENSE_RANK() OVER (ORDER BY medal_count DESC) AS rank
  FROM t1)
  
 SELECT name, country, medal_count, rank
 FROM t2
 WHERE rank <= 5;
 
/*Q4: List down total gold, silver and bronze medals won by each country */
 WITH t1 AS
 (SELECT nr.region AS country, COUNT(medal) AS gold
 FROM olympics_history oh 
 JOIN olympics_history_noc_regions nr 
 ON nr.noc=oh.noc
 WHERE medal = 'Gold'
 GROUP BY 1
 ORDER BY 2 DESC),
 
 t2 AS
 (SELECT nr.region AS country, COUNT(medal) AS silver
 FROM olympics_history oh 
 JOIN olympics_history_noc_regions nr 
 ON nr.noc=oh.noc
 WHERE medal = 'Silver'
 GROUP BY 1
 ORDER BY 2 DESC),
 
 t3 AS
 (SELECT nr.region AS country, COUNT(medal) AS bronze
 FROM olympics_history oh 
 JOIN olympics_history_noc_regions nr 
 ON nr.noc=oh.noc
 WHERE medal = 'Bronze'
 GROUP BY 1
 ORDER BY 2 DESC)
 
 SELECT t1.country, gold, silver, bronze
 FROM t1
 JOIN t2 
 ON t1.country = t2.country 
 JOIN t3
 ON t1.country = t3.country 
 ORDER BY 2 DESC
 
 
 
