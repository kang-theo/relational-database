#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

$($PSQL "TRUNCATE TABLE games, teams")

FILE="games.csv"
LINES=$(wc -l "$FILE" | awk '{print $1}')
echo $LINES

# read from the second line, and there are 33 line totally
for(( i=2; i<$LINES+2; i++ ))
do
  # return value of awk is set to ',', and when assign them to variables, take the separator ',' instead of ' '. 
  # so "a b" can be assign to one variable correctly.
  # echo $(awk -F', ' -v OFS=',' -v i="$i" 'NR==i {print $1,$2,$3,$4,$5,$6}' $FILE)
  #  echo $(awk -F', ' -v OFS=',' -v i="$i" 'NR==i {printf "%s,%s,%s,%s,%s,%s", $1,$2,$3,$4,$5,$6}' $FILE) | sed 's/,*$//'
  IFS=',' read -r YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS <<< $(awk -F', ' -v OFS=',' -v i="$i" 'NR==i {print $1,$2,$3,$4,$5,$6}' $FILE | sed 's/,*$//') 
  # echo $YEAR $ROUND $WINNER $OPPONENT $W_GOALS $O_GOALS

  # just to execute sql query
  $PSQL "insert into teams(name) values('$WINNER'),('$OPPONENT') on conflict do nothing"
  # echo $WINNER $OPPONENT

  # need to capture the output of the sql query, use $()
  WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
  # echo $WINNER_ID
  OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
  # echo $OPPONENT_ID

  # echo $YEAR $ROUND $WINNER_ID $OPPONENT_ID $W_GOALS $O_GOALS (winner_id and opponnet_id are both associated with team_id, so we need to get the id first as above)
  $PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) values($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $W_GOALS, $O_GOALS)"
done

# echo $YEAR $ROUND $WINNER_ID $OPPONENT_ID $W_GOALS $O_GOALS