#!/bin/bash

typeset fileName=users.db
typeset fileDir=../data
typeset filePath=$fileDir/$fileName
inverseParam="$2"

backup_file="$fileDir/$(date +"%Y-%m-%d")-users.db.backup"

pattern="^[a-zA-Z]+$"

if [ ! -f $filePath ]; then
  read -p "users.db file does not exist. Do you want to create one? (y/n)" confirm_create
  if [ "$confirm_create" == "y" ]; then
    touch $filePath
    echo "users.db created."
  else
    echo "Exiting without creating users.db."
    exit 1
  fi
fi

if [[ $# -eq 0 || $1 == "help" ]]; then
  echo "Manages users in db. It accepts a single parameter with a command name."
  echo
  echo "Syntax: db.sh [command]"
  echo
  echo "List of available commands:"
  echo
  echo "add       Adds a new line to the users.db. Script must prompt user to type a
                  username of new entity. After entering username, user must be prompted to
                  type a role."
  echo "backup    Creates a new file, named" $filePath".backup which is a copy of
                  current" $fileName
  echo "find      Prompts user to type a username, then prints username and role if such
                  exists in users.db. If there is no user with selected username, script must print:
                  “User not found”. If there is more than one user with such username, print all
                  found entries."
  echo "list      Prints contents of users.db in format: N. username, role
                  where N – a line number of an actual record
                  Accepts an additional optional parameter inverse which allows to get
                  result in an opposite order – from bottom to top"
  exit 0
fi

# rest of the script


if [ "$1" = "add" ]; then
  echo "Enter the username:"
  read username
  if [[ ! $username =~ $pattern ]]; then
    echo "Error: username must contain only latin letters"
    exit 1
  fi

  echo "Enter role:"
  read role
  if [[ ! $role =~ $pattern ]]; then
    echo "Error: role must contain only latin letters"
    exit 1
  fi

  echo "$username,$role" >> $filePath
  echo "User added successfully"

elif [ "$1" == "backup" ]; then
  cp "$filePath" "$backup_file"
  echo "Created a backup of $fileName named $backup_file"

elif [ "$1" == "restore" ]; then
  latestBackupFile=$(ls $fileDir/*-$fileName.backup | tail -n 1)

  if [[ ! -f $latestBackupFile ]]
  then
    echo "No backup file found."
    exit 1
  fi

  cat $latestBackupFile > $filePath

  echo "Backup is restored."

elif [ "$1" == "find" ]; then
  read -p "Enter username to search: " username
  awk -F, -v x=$username '$1 ~ x' ../data/users.db
  if [[ "$?" == 1 ]]
  then
    echo "User not found."
    exit 1
  fi

elif [ "$1" == "list" ]; then
  if [[ $inverseParam == "inverse" ]]; then
    cat --number $filePath | tac
  else
    cat --number $filePath
  fi
fi
