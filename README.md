# myconfigs installation:

- ```cd ~/.config/```
- ```git clone --no-checkout git@github.com:bnlrnz/myconfigs.git```
- ```cd myconfigs```
- ```git config core.worktree "../../"```
- ```git reset --hard origin/main```

### configs for:

- openbox
- obmenu-generator
- rofi
- vim
- picom
- polybar
- autorandr
- fish
- networkmanager-dmenu-git

- gnome, gnome-extensions

### needed for shutdown script:

- make it executable: ```chmod +x ~/.config/shutdown_dialog.sh```
- dependencies: jshon recode cowsay

## Gnome
save config: ```dconf dump / > dconf-settings.ini```
load config: ```cat dconf-settings.ini | dconf load /```

Configured extensions:
```
gnome-extensions list --enabled
arcmenu@arcmenu.com
appindicatorsupport@rgcjonas.gmail.com
dash-to-panel@jderose9.github.com
no-overview@fthx
Move_Clock@rmy.pobox.com
impatience@gfxmonk.net
```
