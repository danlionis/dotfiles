# NixOS install

```sh
sudo nix --extra-experimental-features "nix-command flakes" run 'github:nix-community/disko#disko-install' -- --flake 'github:danlionis/dotfiles#dan-pc' --disk main /dev/<disk>
```
