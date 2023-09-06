#!/bin/bash

# Input date
date="2020-01-30"

# Array of following day offsets
getFollowing=(1 2 3 4 7 9 10)

# Initialize an empty array to store the following dates
followingDates=()

# Loop through the following day offsets and calculate the dates
for offset in "${getFollowing[@]}"; do
  next_date=$(date -j -v+"$offset"d -f "%Y-%m-%d" "$date" +%Y-%m-%d)
  followingDates+=("$next_date")
done

# Print the list of following dates
echo "Input date: $date"
echo "Following dates:"
for date in "${followingDates[@]}"; do
  echo "$date"
done