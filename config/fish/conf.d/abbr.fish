# remove all abbreviations
for a in (abbr --list)
    abbr --erase $a
end

# ls
if command -v eza > /dev/null
    abbr -a l "eza"
    abbr -a ls "eza"
    abbr -a ll "eza -l"
    abbr -a lll "eza -la"
    abbr -a la "eza -la"
    abbr -a lt "eza -laT -I '.git|target|node_modules'"
else
    abbr -a ll "ls -l"
    abbr -a lll "ls -la"
end

# editor
abbr -a e "nvim"
abbr -a vi "nvim"
abbr -a vim "nvim"
abbr -a eixt "exit"
abbr -a cat "bat"
abbr -a o "xdg-open"

if command -v lazygit > /dev/null
    abbr -a lg "lazygit"
end

# cargo
if command -v cargo > /dev/null
    abbr -a cr "cargo run"
    abbr -a crr "cargo run --release"
    abbr -a ct "cargo test"
    abbr -a cb "cargo build"
    abbr -a cbr "cargo build --release"
end

abbr -a 2fa "ykman oath accounts code"

abbr kssh "kitty +kitten ssh"

alias pandoc 'docker run --rm -v "$(pwd):/data" -u $(id -u):$(id -g) pandoc/latex'
alias latexmk 'docker run --rm --workdir /data -v "$(pwd):/data" -u $(id -u):$(id -g) texlive/texlive latexmk'
alias bashly 'docker run --rm -it --user $(id -u):$(id -g) --volume "$PWD:/app" dannyben/bashly'
alias icat 'kitty +kitten icat'

alias + steam-run
