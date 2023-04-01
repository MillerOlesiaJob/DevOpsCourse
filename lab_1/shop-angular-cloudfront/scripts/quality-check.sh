#!/bin/bash

#!/bin/bash

cd ../

echo "Running linter..."
npm run lint

echo "Running unit tests..."
npm run test:nowatch

echo "Running npm audit..."
npm audit

echo "Checking for issues..."

if [[ $? -ne 0 ]]
then
  echo "Issues found, please check the above output."
  exit 1
else
  echo "No issues found."
fi
