#!/usr/bin/env bash

src_dir="config"
dst_dir="$HOME/.config"

remove_existing() {
    local path="$1"

    if [[ -L "$path" ]]; then
        # If the path is a symlink, remove it
        rm "$path"
        echo "[remove] symlink: $path"
    elif [[ -d "$path" ]]; then
        # If the path is a directory, delete it recursively
        # rm -r "$path"
        mv "$path" "$path".old
        echo "[backup] $path -> $path.bak"
    else
        # If the path is neither a symlink nor a directory, display an error message
        echo "[error] $path is not a symlink or directory"
    fi
}

for file in "$src_dir"/*; do
    filename=$(basename "$file")
    dst_file="$dst_dir/$filename"
    remove_existing "$dst_file"
    ln -fs "$PWD/$file" "$dst_file"
    echo "[link] $file -> $dst_file"
done
