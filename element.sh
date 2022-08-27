#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]
then

  if [[ $1 =~ ^[0-9]+$ ]]
  then #only if $1 is a digit should it try to fetch atomic numbers
    ATOMIC_NUMBER_RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
  fi #put separately to avoid using strings to search for numbers in the database and returning errors in the terminal.

  #try to fetch the other two possibilities. This db is extremely small so this is not expensive at all, just check and set first.
  SYMBOL_RESULT=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$1'")
  NAME_RESULT=$($PSQL "SELECT name FROM elements WHERE name = '$1'")

  #check if argument is an atomic number in DB
  if [[ ! -z $ATOMIC_NUMBER_RESULT ]]
  then
    #get and return information using atomic number
    echo "atomic number: $ATOMIC_NUMBER_RESULT"
  #check if argument is a symbol in DB
  elif [[ ! -z $SYMBOL_RESULT ]]
    then
    #get and return information using symbol
    echo "symbol: $SYMBOL_RESULT"
  #check if argument is a name in DB
  elif [[ ! -z $NAME_RESULT ]]
    then
    #get and return information using name
    echo "name: $NAME_RESULT"
  else
    echo "I could not find that element in the database."
  fi

else
  echo "Please provide an element as an argument."
fi