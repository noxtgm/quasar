# quasar

Personal dotfiles with an installer utility which installs all necessary packages, scripts, and configs on a new clean minimal Arch Linux installation.

## Installation

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/noxtgm/quasar/main/boot.sh)
```

## CLI

After installation, the `quasar` command is available in new terminal sessions.

```
quasar install [--packages|--configs|--shell]   Run installation (or specific phase)
quasar update                                   Pull latest changes and re-apply configs
quasar uninstall                                Remove all quasar configurations
quasar refresh [app|path]                       Reset config(s) to repo defaults
quasar toggle [feature]                         Toggle a feature on/off
quasar status                                   Show current installation status
quasar version                                  Show version
quasar log [--clear]                            View or clear the log file
quasar help                                     Show this help message
```

## Keybinds

### Applications

- `SUPER` Application launcher
- `SUPER` + `F` File manager
- `SUPER` + `SPACE` Terminal

### Window management

- `SUPER` + `Q` Kill active
- `SUPER` + `J` Toggle split
- `SUPER` + `V` Toggle floating
- `SUPER` + `P` Toggle pseudo

### Focus management

- `SUPER` + `LEFT` Move focus left
- `SUPER` + `RIGHT` Move focus right
- `SUPER` + `UP` Move focus up
- `SUPER` + `DOWN` Move focus down

### Workspace switching

- `SUPER` + `[1-0]` Switch to workspace 1-10
- `SUPER` + `SHIFT` + `[1-0]` Move window to workspace 1-10
- `SUPER` + `S` Switch to scratchpad workspace
- `SUPER` + `SHIFT` + `S` Move window to scratchpad workspace
- `SUPER` + `[MWHEEL_UP-MWHEEL_DOWN]` Switch to next/last workspace

## Shell commands

### List (eza)

- `ls` List files with icons
- `lsa` List files, including hidden, with icons
- `lsx` List files with permissions, size, date, and icons
- `lsxa` List files, including hidden, with extra info

### Tree (eza)

- `tree` Show directory tree 2 levels deep
- `treea` Show directory tree, including hidden, 2 levels deep
- `treex` Show directory tree with permissions, size, and date
- `treexa` Show directory tree, including hidden, with extra info

### Navigation (zoxide)

- `cd [path]` Change directory with smart matching
- `..` Go up one directory
- `...` Go up two directories
- `....` Go up three directories

### Search (fzf)

- `ff` Fuzzy find files

### Version control (git)

- `gaa` Stage all changes
- `gcm [message]` Commit with message
- `gca` Amend last commit
- `gcan` Amend last commit without editing message
- `gph` Push to remote
- `gpl` Pull from remote
- `gplr` Pull with rebase
- `gf` Fetch from remote
- `gr` Rebase

## License

[MIT License](https://choosealicense.com/licenses/mit/)

<br>

<a href="https://ko-fi.com/noxtgm" target="_blank" rel="noreferrer"><img src="https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExOG00a3RqYTBzcmo2a2UxZGZ6bXl2dDY5Z2w0YmQ0Y2RxMWd0aWM4OSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9cw/bZgsAwXUIVU2tcKn7s/giphy.gif" alt="Support me on Ko-fi" width="240" height="55"/></a>
