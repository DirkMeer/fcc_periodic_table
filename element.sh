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

  #check if argument is an existing atomic number in DB
  if [[ ! -z $ATOMIC_NUMBER_RESULT ]]
  then
    #get and return information using atomic number
    DB_DATA=$($PSQL "SELECT (properties.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius) 
    FROM properties 
    FULL JOIN elements ON properties.atomic_number = elements.atomic_number 
    FULL JOIN types ON properties.type_id = types.type_id
    WHERE properties.atomic_number =$1")
    #the $ gets the value pasted on so we need an extra set of () directly after the = here otherwise it will not be defined as an array but rather a single string.
    RAY=($(echo $DB_DATA | sed 's/,/ /g' | sed 's/(//g' | sed 's/)//g'))
    #replace , with spaces and remove all parenthesis.
    echo "The element with atomic number ${RAY[0]} is ${RAY[1]} (${RAY[2]}). It's a ${RAY[3]}, with a mass of ${RAY[4]} amu. ${RAY[1]} has a melting point of ${RAY[5]} celsius and a boiling point of ${RAY[6]} celsius."

  #check if argument is a symbol in DB
  elif [[ ! -z $SYMBOL_RESULT ]]
    then
    #get and return information using symbol
    DB_DATA=$($PSQL "SELECT (properties.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius) 
    FROM properties 
    FULL JOIN elements ON properties.atomic_number = elements.atomic_number 
    FULL JOIN types ON properties.type_id = types.type_id
    WHERE symbol ='$1'")
    #see explanation above
    RAY=($(echo $DB_DATA | sed 's/,/ /g' | sed 's/(//g' | sed 's/)//g'))
    #replace , with spaces and remove all parenthesis.
    echo "The element with atomic number ${RAY[0]} is ${RAY[1]} (${RAY[2]}). It's a ${RAY[3]}, with a mass of ${RAY[4]} amu. ${RAY[1]} has a melting point of ${RAY[5]} celsius and a boiling point of ${RAY[6]} celsius."

  #check if argument is a name in DB
  elif [[ ! -z $NAME_RESULT ]]
    then
    #get and return information using name
    DB_DATA=$($PSQL "SELECT (properties.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius) 
    FROM properties 
    FULL JOIN elements ON properties.atomic_number = elements.atomic_number 
    FULL JOIN types ON properties.type_id = types.type_id
    WHERE name ='$1'")
    #see explanation above
    RAY=($(echo $DB_DATA | sed 's/,/ /g' | sed 's/(//g' | sed 's/)//g'))
    #replace , with spaces and remove all parenthesis.
    echo "The element with atomic number ${RAY[0]} is ${RAY[1]} (${RAY[2]}). It's a ${RAY[3]}, with a mass of ${RAY[4]} amu. ${RAY[1]} has a melting point of ${RAY[5]} celsius and a boiling point of ${RAY[6]} celsius."

  else
    echo "I could not find that element in the database."
  fi

else
  echo "Please provide an element as an argument."
fi