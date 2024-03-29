#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT SUM(winner_goals)+SUM(opponent_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals)::numeric, 2) FROM games")"

echo -e "\nAverage number of goals in all games from both teams:"
echo "$($PSQL "SELECT AVG(winner_goals+opponent_goals) FROM (SELECT winner_goals, opponent_goals FROM games) AS subquery")"

echo -e "\nMost goals scored in a single game by one team:"
echo "$($PSQL "SELECT MAX(winner_goals) FROM games")"

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo "$($PSQL "SELECT count(*) FROM  games WHERE winner_goals>2")"

echo -e "\nWinner of the 2018 tournament team name:"
# 1. JOIN(default: INNER JOIN): If you use a LEFT JOIN, it will include all rows from the teams table regardless of whether there is a matching row in the games table. This means that teams that haven't played any games will also appear in the result set, with a total goals count of 0.
#          You can use a JOIN in this scenario when you're only interested in teams that have participated in at least one game. Using a regular JOIN (or INNER JOIN) ensures that only teams with corresponding records in the games table are included in the result set. If a team hasn't played any games, it won't be included in the final output.
# 2. Inner JOIN vs Full JOIN
# In this scenario, an inner join (INNER JOIN) is being used. It returns only the rows that have matching records in both tables. INNER JOIN is one of the most common types of joins, and it only returns the rows that match the join condition between the two tables.
# A full join (FULL JOIN), would return all rows from both the left and right tables, merging them together. 
# 3. GROUP BY: The GROUP BY clause in SQL is used to group rows that have the same values into summary rows, like "total" or "count" rows. It's often used with aggregate functions like SUM(), COUNT(), AVG(), etc., to perform calculations on these grouped rows.
# 4. Order BY: Including the toal_winner_goals in the ressult
#              SELECT teams.name, SUM(games.winner_goals) AS total_winner_goals FROM teams JOIN games ON teams.team_id = games.winner_id GROUP BY teams.name ORDER BY total_winner_goals DESC LIMIT 1;
#              If you just need to get the name
#              SELECT teams.name FROM teams JOIN games ON teams.team_id = games.winner_id GROUP BY teams.name ORDER BY SUM(games.winner_goals) DESC LIMIT 1;
echo "$($PSQL "SELECT teams.name FROM teams JOIN games ON teams.team_id = games.winner_id GROUP BY teams.name ORDER BY SUM(games.winner_goals) DESC LIMIT 1")"

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
# Wrong: SELECT DISTINCT teams.name FROM teams JOIN games ON teams.team_id = games.winner_id OR teams.team_id = games.opponent_id WHERE games.round = 'Eighth-Final';
echo "$($PSQL "SELECT DISTINCT teams.name FROM teams JOIN games ON (teams.team_id = games.winner_id OR teams.team_id = games.opponent_id) AND games.round = 'Eighth-Final' AND games.year = 2014 ORDER BY teams.name")"

echo -e "\nList of unique winning team names in the whole data set:"
echo "$($PSQL "SELECT DISTINCT teams.name FROM teams JOIN games ON teams.team_id = games.winner_id ORDER BY teams.name")"

echo -e "\nYear and team name of all the champions:"
echo "$($PSQL "SELECT games.year, teams.name FROM teams JOIN games ON games.round = 'Final' AND games.winner_id = teams.team_id ORDER BY games.year")"

echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "SELECT teams.name from teams WHERE teams.name LIKE 'Co%'")"
