#!/bin/bash

# Check the parameter passed and run the corresponding ROS command
if [ "$1" == "small_square" ]; then
    rosrun linux_exam small_square.py
elif [ "$1" == "medium_square" ]; then
    rosrun linux_exam medium_square.py
elif [ "$1" == "big_square" ]; then
    rosrun linux_exam big_square.py
else
    echo "Invalid parameter. Use small_square, medium_square, or big_square."
fi
