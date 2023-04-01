#!/bin/bash

cd ..

echo "Installing dependencies..."

if [ -d "node_modules" ]; then
  read -p "node_modules directory already exists. Do you want to reinstall? [y/n] " answer
  if [[ $answer == "y" ]]; then
    echo "Reinstalling node_modules..."
    rm -rf node_modules
    npm install
    echo "node_modules have been reinstalled."
  else
    echo "Skipping node_modules installation."
  fi
else
  echo "node_modules directory not found. Installing..."
  npm install
  echo "node_modules have been installed."
fi


echo "Please enter the configuration you want to use (enter 'production' for production build or empty line for development build):"
read configuration

# Check if the configuration is empty
if [ -z "$configuration" ]; then
  configuration="development"
fi

echo "Start build..."
npm run build:$configuration

cd dist/
echo "The folder was changes to the dist/"

# Check if client-app.zip already exists and delete it if it does
if [ -f client-app.zip ]; then
  echo "client-app.zip is already exists. Remove old version"
  rm client-app.zip
fi

echo "Compressing build output into client-app.zip..."

# Check the operating system
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  zip -r client-app.zip .
elif [[ "$OSTYPE" == "msys"* ]]; then
  powershell Compress-Archive -Path . -DestinationPath client-app.zip
else
  echo "Unsupported operating system"
fi
cd ../..
