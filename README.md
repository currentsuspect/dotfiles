# dotfiles

Personal dotfiles collection for Dylan's machines.

## Layout

- `hypr/`, `kitty/`, `rofi/`, `waybar/`, `dunst/`, `fastfetch/`, `zsh/` — Arch desktop config
- `nvim/` — Neovim config
- `shell/` — shared Bash + Starship shell bundle
- `vps/` — Ubuntu VPS bootstrap, install, verify, and doctor scripts

## VPS quick start

```bash
cd vps
./first-boot.sh all
```

## Notes

- `shell/.bashrc.d/local.sh` is intentionally local-only and ignored.
- Generated editor undo/history and extracted app assets should not be committed.
- This repo is public — keep secrets, tokens, and machine-specific credentials out of it.
