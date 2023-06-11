#!/bin/bash
###################################################################### 
#Copyright (C) 2023  Kris Occhipinti
#https://filmsbykris.com

#downloads url from clipboard 

#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.
###################################################################### 

[[ "$1" ]] && url="$1" || url="$(xclip -o)" 
file="$(basename "$url")"

function rename(){
  name="$(echo -e "$file\nRENAME"|fzf --prompt "Save file as $file or rename it? ")"
  [[ "$name" == "RENAME" ]] && read -p "Save As: " file
  echo "Downloading $url to $file"
}

[[ $url == "22" ]] && f="-f 22" && url="$(xclip -o)"
if [[ "$url" == *"youtu"* ]] || [[ "$url" == *"m3u"* ]];then
  [[ "$url" == *"m3u"* ]] && read -p "Enter Output Name: " output
  [[ $output ]] && cmd="youtube-dl '$url' -o '$output.mp4'" || cmd="youtube-dl $f '$url'"
  echo ": $(date +%s):0;$cmd" >> $HOME/.zsh_history
  eval $cmd
elif [[ "$url" == *"torrent"* ]] || [[ "$url" == *"magnet"* ]];then
  rename
  echo ": $(date +%s):0;aria2c '$url'" >> $HOME/.zsh_history
  aria2c "$url"
else
  rename
  echo ": $(date +%s):0;axel -n 10 '$url' -o '$file'" >> $HOME/.zsh_history
  axel -n 10 "$url" -o "$file"
fi
