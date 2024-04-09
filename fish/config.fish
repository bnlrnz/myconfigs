if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Start Hyprland at login
if status --is-login
  if test -z "$DISPLAY" -a $XDG_VTNR = 1
	  #exec Hyprland
  end
end

export TERM=xterm-256color
export EDITOR=nvim

alias vi="nvim"
alias vim="nvim" 
alias ll="eza --icons -l -b -o -g -M"
alias l="eza --icons -l -a -b -o -g -M"
alias du="dust"
alias cat="bat -p --paging=never"
alias less="bat --paging=always"
alias x11="env -u WAYLAND_DISPLAY"

fish_ssh_agent
