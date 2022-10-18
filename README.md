# myconfigs installation:

- ```cd ~/.config/```
- ```git clone --no-checkout git@github.com:bnlrnz/myconfigs.git``` 
- ```git config core.worktree "../../"```
- ```git reset --hard origin/main```

### configs for:

- openbox
- obmenu-generator
- rofi
- vim
- picom
- polyba

### needed for shutdown script:

- make it executable: ```chmod +x ~/.config/shutdown_dialog.sh```
- dependencies: jshon recode cowsay
