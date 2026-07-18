# AGENTS.md

Personal dotfiles, primarily managed by **Nix + Home Manager** (flake). The
repo lives at `~/dotfiles` and that exact path is hardcoded in symlinks (see
`home.nix` `link`), so do not assume it can move.

## Apply changes

Editing `.nix` files does nothing until you rebuild. Use the alias or the raw
command:

```sh
hms                                          # alias: home-manager switch --flake ~/dotfiles#<host>
home-manager switch --flake ~/dotfiles#home  # explicit host
```

Hosts are defined in `flake.nix` (`hosts`): `home` and `server`. `#home` has
notes-related config; `#server` is leaner.

There is no test suite, linter, or CI. Before activating any changes with `hms` or `switch`, always validate them by running `nix flake check` and then `home-manager build --flake ~/dotfiles#home` to ensure the configuration compiles cleanly. Only run the switch/activation step once these checks pass.

## Two config mechanisms (important distinction)

1. **Home Manager store-managed** — most programs are configured declaratively
   in `home.nix` / `nix/**/*.nix`. Editing these requires `hms` to take effect.
2. **Out-of-store symlinks** — `home.nix` uses `link` (and a few `home.file`
   entries) to symlink dirs like `kitty/`, `niri/`, `yazi/`, `kanshi/`,
   `nushell/scripts.nu` straight back to `~/dotfiles/...`. Edits to those files
   apply immediately, no rebuild needed.

When changing a program's config, first check whether it's set in nix or is a
linked raw file — they are edited and applied very differently.

## Layout

- `flake.nix` — flake inputs (nixpkgs unstable, home-manager, nixvim) and
  host definitions. Entrypoint.
- `home.nix` — main Home Manager module; packages, shells (zsh/nushell),
  git/delta/lazygit, and the `xdg.configFile` out-of-store symlinks.
- `nix/*.nix` — feature modules imported by `home.nix` (`starship`, `tmux`,
  `beancount`) and `nix/nixvim.nix`.
- `nix/nixvim.nix` + `nix/nixvim/*.nix` — Neovim config via **nixvim** (declared
  in Nix, not lua dotfiles). Lua helpers live in `nix/utils.lua` and
  `nix/snippets.lua`, referenced via `extraFiles`.
- `archlinux.sh`, `manjaro.sh`, `notes.sh` — executable *notes*, run line by
  line by hand; not scripts to invoke wholesale.

## Legacy installer (do not use for current setup)

`Makefile` and `setup.py` are the pre-Nix dotfile installer (oh-my-zsh clone,
vim/vimpire, terminator, buildout). They are stale relative to the Nix setup —
don't run them to provision the current machine.

## Conventions

- Nix files: 2-space indent.
- `.editorconfig` covers only py/js (4 sp), html/scss/lua (2 sp).
- Secrets load from `~/.env` at runtime: zsh `envExtra` exports it, and Neovim
  calls `require("utils").dotenv()` (`nix/nixvim.nix`). Never commit secrets; do
  not hardcode API keys (e.g. `GEMINI_API_KEY` is read from env).
- Theme is tokyonight across bat/delta/nixvim/opencode — match it if adding
  themed tools.
- `.gitignore` excludes generated plugin dirs and the `dms/` quickshell config
  (managed elsewhere); don't try to commit those.

## New-machine bootstrap

See `notes.sh` (bottom): install Determinate Nix, clone repo, then
`nix run home-manager/master -- switch --flake dotfiles#<host>`.
