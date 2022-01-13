USE sounders;

/* 1. Show all of the midfield players last names and their goals and assists for the year 2020. 
Sort by the number of goals in descending order.*/
SELECT CONCAT(first_name, ' ', last_name) AS name, goals, assists
FROM player p
	JOIN stat_line sl
    ON p.player_id = sl.player_id
WHERE p.position = 'M' AND season_year = 2020
ORDER BY goals DESC;

/* 2. Show the number of goals, number of games, and the goals per game by dividing the number of goals 
by the number of games in 2019.*/
SELECT SUM(goals) AS num_goals, num_games, (SUM(goals) / num_games) AS goals_per_game
FROM stat_line sl
	JOIN season s
    ON s.season_year = sl.season_year
WHERE s.season_year = 2019;

/* 3. Show the last names of players who had more yellow cards than the average number of yellow cards in 2019. 
Also provide the number of yellows for that person and the fouls committed and against. Sort by number of yellows 
in descending order.*/
SELECT last_name, yellow_cards, fouls, fouls_against
FROM stat_line sl
	JOIN player p
    On sl.player_id = p.player_id
WHERE season_year = 2019 AND yellow_cards > 
	(SELECT AVG(yellow_cards)
    FROM stat_line
    WHERE season_year = 2019)
ORDER BY yellow_cards DESC;

/* 4.Display the goal per shot ratio rounded to two decimals for the past three seasons. This will illustrate the
pattern over the years on the rate of a goal. Also include the year, total goals, and total shots.*/
	SELECT season_year, SUM(goals), SUM(shots), ROUND((SUM(goals)/SUM(shots)),2) AS "Goals Per Shot"
	FROM stat_line
	WHERE season_year = 2018
UNION
	SELECT season_year, SUM(goals), SUM(shots), ROUND((SUM(goals)/SUM(shots)),2) AS "Goals Per Shot"
	FROM stat_line
	WHERE season_year = 2019
UNION
	SELECT season_year, SUM(goals), SUM(shots), ROUND((SUM(goals)/SUM(shots)),2) AS "Goals Per Shot"
	FROM stat_line
	WHERE season_year = 2020;
    
/*5. Display the top 5 players who have the most offsides over the 2018. 
Show last name, games played (subs and starts), number of offsides, and offsides per game.
Sort by offsides per game in descending order.*/
SELECT last_name, (num_start + num_sub) AS games_played, offsides, (offsides / (num_start + num_sub)) AS offsides_per_game
FROM player p
	JOIN stat_line sl
    ON p.player_id = sl.player_id
WHERE season_year = 2018
ORDER BY (offsides / (num_start + num_sub)) DESC
LIMIT 5;

/*6. Show all the midfielders and their full name, shots, shots on target, and their shots on target per
shot to show their accuracy on goal in 2020.*/
SELECT CONCAT(last_name, ', ', first_name) AS full_name, shots, shots_on_target, ROUND((shots_on_target / shots),2) AS accuracy
FROM stat_line sl
	JOIN player p 
    ON sl.player_id = p.player_id
WHERE position = 'M' AND season_year = 2020
ORDER BY ROUND((shots_on_target / shots),2) DESC;

/* 7.  Show the ratio for each player in 2019 for fouls committed vs. fouls against them. 
Display each persons full name, fouls, fouls against, and the ratio*/
SELECT CONCAT(first_name, ' ', last_name) as full_name, fouls, fouls_against, 
	IF(fouls > fouls_against, CONCAT(ROUND(fouls / fouls_against), ':', 1), CONCAT(1,':',ROUND(fouls_against / fouls)
    )) AS "fouls : fouls against"
FROM player p
	JOIN stat_line sl
    ON p.player_id = sl.player_id
WHERE season_year = 2019;

/* 8. Compare the number of goals to the overall records of each year. 
Display the season year, number of wins, losses, draws, win percentage, total goals, and goals per game for each year.*/
	SELECT s.season_year, CONCAT(num_win,'/',num_loss,'/',num_draw) AS "W/L/T", 
		ROUND((num_win / num_games), 2) AS win_percentage, SUM(goals), ROUND((SUM(goals) / num_games),2) AS goals_per_game
	FROM season s
		JOIN stat_line sl
		ON s.season_year = sl.season_year
	WHERE s.season_year = 2018
UNION
	SELECT s.season_year, CONCAT(num_win,'/',num_loss,'/',num_draw) AS "W/L/T", 
		ROUND((num_win / num_games), 2) AS win_percentage, SUM(goals),ROUND((SUM(goals) / num_games),2) AS goals_per_game
	FROM season s
		JOIN stat_line sl
		ON s.season_year = sl.season_year
	WHERE s.season_year = 2019
UNION
	SELECT s.season_year, CONCAT(num_win,'/',num_loss,'/',num_draw) AS "W/L/T", 
		ROUND((num_win / num_games), 2) AS win_percentage, SUM(goals),ROUND((SUM(goals) / num_games),2) AS goals_per_game
	FROM season s
		JOIN stat_line sl
		ON s.season_year = sl.season_year
	WHERE s.season_year = 2020;

/*9. Display all of the players who have either a first or last name that starts with the letter 'r' in 2020. Show
both names, jersey number, position, age, height and weight of the player. Order by jersey number.*/
SELECT first_name, last_name, jersey_num, position, age, height, weight
FROM player p
	JOIN stat_line sl
    ON sl.player_id = p.player_id
WHERE season_year = 2020 AND (first_name REGEXP '^r' OR last_name REGEXP '^r')
ORDER BY jersey_num;

/*10. Display the total number of cards (red and yellow) given each year over the past three seasons for the whole
team. Show the total number and season year, while ordering by season year.*/
	SELECT season_year, SUM(yellow_cards + red_cards) AS total_cards
	FROM stat_line
	WHERE season_year = 2018
UNION
	SELECT season_year, SUM(yellow_cards + red_cards) AS total_cards
	FROM stat_line
	WHERE season_year = 2019
UNION
	SELECT season_year, SUM(yellow_cards + red_cards) AS total_cards
	FROM stat_line
	WHERE season_year = 2020
	ORDER BY season_year;
 
