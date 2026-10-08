#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "truncate table games, teams")
cat games.csv | while IFS="," read YEAR ROUND WINNER_NAME OPPONENT_NAME WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then

  # check if team in teams table
  WINNER_ID=$($PSQL "select team_id from teams where name = '$WINNER_NAME'")
  # if winner_team not in teams, add it and store the id
  if [[ -z $WINNER_ID ]]
  then
    INSERT_WINNER_TEAM=$($PSQL "insert into teams(name) values('$WINNER_NAME')")
    WINNER_ID=$($PSQL "select team_id from teams where name = '$WINNER_NAME'")
  fi

  # ditto for opponent team
  OPPONENT_ID=$($PSQL "select team_id from teams where name = '$OPPONENT_NAME'")
  if [[ -z $OPPONENT_ID ]]
  then
    INSERT_OPPONENT_TEAM=$($PSQL "insert into teams(name) values('$OPPONENT_NAME')")
    OPPONENT_ID=$($PSQL "select team_id from teams where name = '$OPPONENT_NAME'")
  fi

  #add everything
  INSERT_GAME_RESULT=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  
  echo $INSERT_GAME_RESULT



  fi
done