#!/bin/bash

# Move inside the linux_exam folder
cd ~/catkin_ws/src/linux_exam

# Create folder structure this->is->my->linux->exam
mkdir -p this/is/my/linux/exam

# Create the file my_file.py inside the exam folder
touch this/is/my/linux/exam/my_file.py

# Print the completion message
echo "This bash script has finished!"

