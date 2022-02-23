#!/bin/bash

msg=$(wget "http://api.icndb.com/jokes/random" -qO- | jshon -e value -e joke -u | recode html)
cowsay_msg=$(echo "$msg" | cowsay -f $(ls /usr/share/cows/ | shuf -n1))
cowsay_msg_n=$(printf "$cowsay_msg\n.")
gxmessage "$cowsay_msg_n" -center -title "Shutdown" -font "monospace 10" -default "Cancel" -buttons "_Cancel":2,"_Logout":2,"_Reboot":3,"_Shutdown":4 >/dev/null

case $? in
  1)
     echo "Exit";;
  2)
     openbox --exit;;
  3)
     sudo shutdown -r now;;
  4)
     sudo shutdown -h now;;

esac
