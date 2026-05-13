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
quasar update [--force]                         Pull latest changes and re-apply configs
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

- `SUPER` + `ENTER` Terminal
- `SUPER` + `SPACE` Application launcher
- `SUPER` + `E` File manager

### Window management

- `SUPER` + `Q` Close window
- `SUPER` + `J` Toggle split
- `SUPER` + `T` Toggle floating
- `SUPER` + `F` Fullscreen
- `SUPER` + `ALT` + `F` Maximize
- `SUPER` + `P` Pseudo tile

### Focus

- `SUPER` + `ARROWS` Move focus
- `SUPER` + `SHIFT` + `ARROWS` Swap windows
- `ALT` + `TAB` Cycle windows
- `ALT` + `SHIFT` + `TAB` Cycle windows backward

### Workspaces

- `SUPER` + `[1-0]` Switch to workspace 1-10
- `SUPER` + `SHIFT` + `[1-0]` Move window to workspace 1-10
- `SUPER` + `TAB` Next workspace
- `SUPER` + `SHIFT` + `TAB` Previous workspace
- `SUPER` + `S` Toggle scratchpad
- `SUPER` + `SHIFT` + `S` Move to scratchpad

### Mouse

- `SUPER` + `LMB` Move window
- `SUPER` + `RMB` Resize window
- `SUPER` + `SCROLL` Cycle workspaces

### Terminal (ghostty)

- `ALT` + `F4` Close window
- `CTRL` + `SHIFT` + `T` New tab
- `CTRL` + `SHIFT` + `W` Close tab
- `CTRL` + `SHIFT` + `TAB` Previous tab
- `CTRL` + `TAB` Next tab
- `ALT` + `[1-9]` Go to tab 1-9
- `CTRL` + `ALT` + `ARROWS` New split
- `ALT` + `ARROWS` Focus split
- `CTRL` + `SUPER` + `SHIFT` + `ARROWS` Resize split
- `CTRL` + `SHIFT` + `C` Copy
- `CTRL` + `SHIFT` + `V` Paste
- `SHIFT` + `INSERT` Paste selection
- `SHIFT` + `HOME` / `END` Scroll to top / bottom
- `SHIFT` + `PAGE UP` / `PAGE DOWN` Scroll page
- `CTRL` + `SHIFT` + `PAGE UP` / `PAGE DOWN` Jump to prompt
- `CTRL` + `=` / `-` Increase / decrease font size
- `CTRL` + `0` Reset font size
- `CTRL` + `SHIFT` + `P` Command palette

## Shell commands

### List (eza)

- `ls` List files with date and icons
- `lsa` List files, including hidden, with date and icons
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

- `ff` Fuzzy find files and open in neovim
- `fg` Fuzzy grep content and open in neovim

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
