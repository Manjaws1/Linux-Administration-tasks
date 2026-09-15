#! /bin/bash

# Prompts the user for a directory name and then creates it with mkdir.
echo "Give a directory name to create:"
read NEW_DIR

ORIG_DIR = $(pwd)
[[-d $NEW_DIR ]] && echo $NEW_DIR already exists, aborting && exit
mkdir $NEW_DIR
# Changes to the new directory and prints out where it is using pwd.
cd $name && pwd

# Using touch, creates several empty files and runs ls on them to verify th
for n in 1 2 3 4
do 
  touch file$n
done

ls file?

# Puts some content in them using echo and redirection.
for names in file?
do
    echo This file is named $names > $names
done

# Displays their content using cat.
cat file?

# Says goodbye to the user and cleans up after itself.
rm -rf $NEW_DIR
echo "Goodbye My Friend!"

