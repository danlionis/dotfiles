set -gx EDITOR /usr/bin/env nvim

fzf_key_bindings
set -gx FZF_DEFAULT_OPTS "--height 40%"
set -gx FZF_CTRL_T_OPTS "--border --preview 'bat --color=always {}'"
set -gx FZF_CTRL_R_OPTS "--border"

# set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
# set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND

source /home/dan/.config/fish/fish_greeting.fish

if type -q starship
    starship init fish | source
end

if type -q zoxide
    zoxide init fish | source
end

if type -q direnv
    direnv hook fish| source
end

# https://github.com/gokcehan/lf/blob/master/etc/lfcd.fish
# 
# Change working dir in fish to last dir in lf on exit (adapted from ranger).
#
# You may put this file to a directory in $fish_function_path variable:
#
#     mkdir -p ~/.config/fish/functions
#     ln -s "/path/to/lfcd.fish" ~/.config/fish/functions
#
# You may also like to assign a key (Ctrl-O) to this command:
#
#     bind \co 'set old_tty (stty -g); stty sane; lfcd; stty $old_tty; commandline -f repaint'
#
# You may put this in a function called fish_user_key_bindings.

function lf
    set tmp (mktemp)
    # `command` is needed in case `lfcd` is aliased to `lf`
    command lf -last-dir-path=$tmp $argv
    if test -f "$tmp"
        set dir (cat $tmp)
        rm -f $tmp
        if test -d "$dir"
            if test "$dir" != (pwd)
                cd $dir
            end
        end
    end
end
