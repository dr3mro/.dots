# ~/.zprofile
# sourced by zsh when used as a login shell
# automatically run startx when logging in on tty1
[[ ! $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx -- vt1

