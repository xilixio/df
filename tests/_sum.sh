#!/bin/bash

# Check if exactly two arguments are passed
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 number1 number2"
    exit 1
fi

# Add the two numbers
result=$(( $1 + $2 ))

# Print the result
echo $result