#!/bin/bash

msg=$(curl -H "Accept: text/plain" https://icanhazdadjoke.com/; echo)

if [ -z "$msg" ]
    then
    msg="You seem to be offline..."
fi

cowsay_msg=$(echo "$msg" | cowsay -f $(ls /usr/share/cows/ | shuf -n1))
cowsay_msg_n=$(printf "$cowsay_msg\n.")
gxmessage "$cowsay_msg_n" -center -title "Shutdown" -font "monospace 10" -default "Cancel" -buttons "_Cancel":1,"_Logout":2,"_Reboot":3,"_Shutdown":4 >/dev/null

case $? in
  1)
     echo "Exit";;
  2)
     openbox --exit;;
  3)
     shutdown -r now;;
  4)
     shutdown -h now;;

esac
