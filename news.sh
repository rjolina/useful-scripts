#!/bin/bash

# Set the URL of the news feed
feed_url="https://news.google.com/rss?hl=pl&gl=PL&ceid=PL:pl"

# Use curl to download the news feed
feed=$(curl -s "$feed_url")

# Extract the titles of the top stories using sed
titles=$(echo "$feed" | xmlstarlet sel -t -v '//title/text()')


# Read the blacklist file
blacklist=$(cat blacklist.txt)

# Print the titles that do not contain words from the blacklist
echo "Top news from Poland:"
echo "$titles" | grep -vwE "$blacklist"


# Print the titles
#echo "Top news from Poland:"
#echo "$titles"

