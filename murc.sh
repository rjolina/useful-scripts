data=$(date +%Y-%m-%d)

mapka="rus_ukr_war_$data.png"

link=$(curl https://www.aljazeera.com/news/2022/2/28/russia-ukraine-crisis-in-maps-and-charts-live-news-interactive | grep -n 'INTERACTIVE-WHO-CONTROLS-WHAT-IN-UKRAINE' | grep -oP 'src="\K[^"]*' | sed 's/\.png.*//')

# Add "https://" to the beginning of the link
link="https://www.aljazeera.com/$link"

# Add "png" to the end of the link
link="$link.png"

wget -O /tmp/"$mapka" "$link"

# Check if the file already exists in the current directory
if [ -f "$mapka" ]; then
  # Compare the file to the one at the specified URL
  cmp --silent "$mapka" /tmp/"$mapka"
  # Check the exit status of cmp
  if [ $? -eq 0 ]; then
    # The files are identical, so don't download the file
    notify-send -t 6000 "Na froncie 🇷🇺🇺🇦 bez zmian...🪖☠️⚔️☠️🪖"
    mpv all_quiet.gif
  else
    # The files are different, so download the file
    mv /tmp/"$mapka" /home/zed/rss/"$mapka"
    sxiv /home/zed/rss/"$mapka"
  fi
else
  # The file doesn't exist, so download it
  mv /tmp/"$mapka" /home/zed/rss/"$mapka"
  sxiv /home/zed/rss/"$mapka"
fi
