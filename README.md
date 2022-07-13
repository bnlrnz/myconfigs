# myconfigs installation:

- ```cd ~/.config/```
- ```git clone --no-checkout git@github.com:bnlrnz/myconfigs.git``` 
- ```git config core.worktree "../../"```
- ```git reset --hard origin/main```

### configs for:

- openbox
- rofi
- alfred
- vim
- picom
- tint2 (now polybar)

### needed for shutdown script:

- make it executable: ```chmod +x ~/.config/shutdown_dialog.sh```
- dependencies: jshon recode cowsay
