# dotfiles

Personal dotfiles collection for Dylan's machines.

## Layout

- `config/` — XDG-style app config payloads that map into `~/.config/...`
  - includes `hypr`, `kitty`, `rofi`, `waybar`, `dunst`, `fastfetch`, `gtk-3.0`, `hyde`, `nvim`, `spicetify`, and `zsh-theme-powerlevel10k`
- `shell/` — shared Bash + Starship shell bundle
- `vps/` — Ubuntu VPS bootstrap, install, verify, and doctor scripts
- `zsh/` — zsh config and lightweight plugin payloads; the older vendored zinit layer has been removed

## VPS quick start

```bash
cd vps
./first-boot.sh all
```

## Submodules

Some config payloads are provided via git submodules — currently `config/spicetify/Themes` and `config/zsh-theme-powerlevel10k`.
After cloning (or after pulling submodule path changes), run:

```bash
git submodule update --init --recursive
```

If you skip this step, some linked config paths may exist without their contents.

## Notes

- `shell/.bashrc.d/local.sh` is intentionally local-only and ignored.
- `config/` is the normalized home for clean `.config/...` payloads; install/link tooling can map these into `~/.config/` directly.
- `zsh/.zshrc` now tolerates a missing powerlevel10k checkout, but you should still initialize submodules for the full setup.
- `zsh/` now assumes a simpler plugin story: current shell config + `.zsh/` plugin payloads, without the previously vendored `zsh/.zinit/` tree.
- Generated editor undo/history, backup files, and extracted app assets should not be committed.
- `config/nvim/init.lua.bak` was intentionally removed; keep editor backups local, not tracked.
- This repo is public — keep secrets, tokens, and machine-specific credentials out of it.
