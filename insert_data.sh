#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
TRUNCATE=$($PSQL "TRUNCATE TABLE teams, games;")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOALS OGOALS
do
  
  if [[ $YEAR != "year" ]]
  then
    # Add unique team names to the teams table
    TEAM="$($PSQL "SELECT name FROM teams WHERE name = '$WINNER';")"
    if [[ $TEAM != $WINNER ]]
    then
      INSERT="$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER');")"
      echo $WINNER inserted into teams table
    fi
    TEAM="$($PSQL "SELECT name FROM teams WHERE name = '$OPPONENT';")"
    if [[ $TEAM != $OPPONENT ]]
    then
      INSERT="$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT');")"
      echo $OPPONENT inserted into teams table
    fi

    # Add all data from csv file to games table with team id's from teams table

    WINNERID="$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER';")"
    OPPID="$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT';")"
    INSERT="$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) 
      VALUES($YEAR, '$ROUND', $WINNERID, $OPPID, $WGOALS, $OGOALS);")"
  fi
done