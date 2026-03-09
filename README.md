# dotfiles

Personal dotfiles collection for Dylan's machines.

## Layout

- `config/` — XDG-style app config payloads that map into `~/.config/...`
  - includes `hypr`, `kitty`, `rofi`, `waybar`, `dunst`, `fastfetch`, `gtk-3.0`, `hyde`, `nvim`, `spicetify`, and `zsh-theme-powerlevel10k`
- `shell/` — shared Bash + Starship shell bundle
- `vps/` — Ubuntu VPS bootstrap, install, verify, and doctor scripts
- `zsh/` — legacy zsh/plugin payloads that still need their own cleanup pass

## VPS quick start

```bash
cd vps
./first-boot.sh all
```

## Notes

- `shell/.bashrc.d/local.sh` is intentionally local-only and ignored.
- `config/` is the normalized home for clean `.config/...` payloads; install/link tooling can map these into `~/.config/` directly.
- Generated editor undo/history and extracted app assets should not be committed.
- This repo is public — keep secrets, tokens, and machine-specific credentials out of it.
