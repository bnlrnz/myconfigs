if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Start Hyprland at login
if status --is-login
  if test -z "$DISPLAY" -a $XDG_VTNR = 1
    exec Hyprland
  end
end

export TERM=xterm-256color

alias vim="nvim" 

fish_ssh_agent
