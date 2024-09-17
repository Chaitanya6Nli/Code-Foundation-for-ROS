#!/bin/bash

# Go to the exam folder created in Task 1
cd ~/catkin_ws/src/linux_exam/this/is/my/linux/exam

# Remove any existing files
rm -f *

# Create new files exam1.py, exam2.py, and exam3.py
touch exam1.py exam2.py exam3.py

# Set permissions for exam1.py
chmod 754 exam1.py  # Owner: rwx, Group: r-x, Others: r--

# Set permissions for exam2.py
chmod 501 exam2.py  # Owner: r-x, Group: none, Others: --x

# Set permissions for exam3.py
chmod 241 exam3.py  # Owner: -w-, Group: r--, Others: --x
