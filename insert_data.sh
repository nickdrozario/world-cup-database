#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

  """ You can add each not condition here like [[ $YEAR != year && $ROUND != round && $WINNER != wiiner ]]
  and so on, but you can also use only one not condition here because it will drop all the others
  when $YEAR is not equal to year variable.
  """
  if [[ $YEAR != year ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")

    if [[ -z $WINNER_ID ]]
    then
      INSERT_WINNER_RESULTS=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")

      """ You get the WINNER_ID again because the if statement checks if there is no WINNER_ID or 
      WINNNER already in the teams tabel. After it is inside of the if statement you get the 
      WINNER_ID again because you insert the WINNER into the teams table so now you can get the 
      WINNER_ID again because it exist.
      """
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    fi

    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

    if [[ -z $OPPONENT_ID ]]
    then
      INSERT_OPPONENT_RESULTS=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    fi

    INSERT_GAME_RESULTS=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")
  fi
done
