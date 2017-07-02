#!/bin/bash
window=$(xdotool getwindowfocus getwindowname)
window=$(echo $window | tr '[:upper:]' '[:lower:]')

if [[ "$1" == "-v" ]]; then
  debug=true
else
  debug=false
fi

if [[ $debug == true ]]; then
  echo $window
fi

icon=" "

# Apps

case $window in
*"thinkpad"*)
  icon=" ";;

*"telegram"*)
  icon=" ";;

*"vim"* | *"atom"*)
  icon=" ";;

*);;
esac


# Web Search Engines

keyword=$(echo $window | awk -F"-" '{print $1}')
engine=$(echo $window | awk -F"-" '{print $2}')
browser=$(echo $window | awk -F"-" '{print $3}')

if [[ $debug == true ]]; then
  echo $keyword
  echo $engine
  echo $browser
fi

if [[ -z $browser ]]; then
  browser=$engine
  engine=$keyword
fi

case $browser in
*"google chrome"* | *"chromium"*)
  icon=" ";;

*"firefox"*)
  icon=" ";;

*);;
esac

case $keyword in
*"yahoo"*)
  icon=" ";;

*"imdb"*)
  icon=" ";;

*"stack overflow"*)
  icon=" ";;

*"facebook"*)
  icon="";;

*);;
esac

case $engine in
# Web Sites
*"github"*)
  icon=" ";;

*"reddit"*)
  icon=" ";;

*"amazon"*) 
  icon=" ";;

*"apple"*)
  icon=" ";;

*"mail"*)
  icon=" ";;

*"youtube"*)
  icon=" ";;

*"twitch"*)
  icon=" ";;

*"wikipedia"*)
  icon=" ";;

*"tumblr"*)
  icon="";;

*"tripadvisor"*)
  icon=" ";;

*"imdb"*) 
  icon=" ";;


# Search Engines
*"ecosia"*)
  icon=" ";;

*"google"*)
  icon=" ";;

*"yahoo"*)
  icon=" ";;

*);;
esac

echo $icon

exit 0
