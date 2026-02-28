# arch-personality

My personal Arch Linux setup — kitty, zsh + oh-my-zsh, wofi, and tuigreet.

---

## Kitty (terminal)

**Install:**
```sh
sudo pacman -S kitty
```
More info: https://sw.kovidgoyal.net/kitty/

**Font — JetBrainsMono Nerd Font:**
```sh
sudo pacman -S ttf-jetbrains-mono-nerd
```

**Apply config:**
```sh
mkdir -p ~/.config/kitty
cp kitty/kitty.conf ~/.config/kitty/kitty.conf
cp kitty/Snazzy.conf ~/.config/kitty/Snazzy.conf
```

Theme: **Snazzy** — dark background (`#282a36`), vivid colors.
Colors are already embedded in `kitty.conf`. `Snazzy.conf` is kept as a standalone reference.
Based on [hyper-snazzy](https://github.com/sindresorhus/hyper-snazzy).

---

## Zsh + Oh My Zsh

**Install zsh:**
```sh
sudo pacman -S zsh
chsh -s $(which zsh)
```
> Log out and back in after `chsh` — the shell change only takes effect on next login.

**Install Oh My Zsh:** https://ohmyzsh.sh
```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

**Install catimg** (required by the `catimg` OMZ plugin):
```sh
sudo pacman -S catimg
```

**Apply config** (after OMZ is installed and you've logged into zsh):
```sh
cp zsh/.zshrc ~/.zshrc
exec zsh
```

Theme: **gnzh** (built into OMZ, no extra install needed).

Plugins: `git`, `catimg`, `colored-man-pages`, `docker`, `docker-compose`, `ssh-agent`, `sudo`

---

## Wofi (app launcher)

**Install:**
```sh
sudo pacman -S wofi
```
More info: https://hg.sr.ht/~scoopta/wofi

**Apply config:**
```sh
mkdir -p ~/.config/wofi
cp wofi/config ~/.config/wofi/config
cp wofi/style.css ~/.config/wofi/style.css
```

**Install toggle script:**
```sh
mkdir -p ~/.local/bin
cp wofi/toggle_wofi.sh ~/.local/bin/toggle_wofi.sh
chmod +x ~/.local/bin/toggle_wofi.sh
```

**Add `~/.local/bin` to PATH for KDE** (KDE shortcuts don't use `.zshrc` — they need this separately):
```sh
mkdir -p ~/.config/environment.d
echo 'PATH="$HOME/.local/bin:$PATH"' >> ~/.config/environment.d/local_bin.conf
```
> Log out and back in after this step.

**Add a keyboard shortcut in KDE:**

Go to: **System Settings → Keyboard → Shortcuts → Add New → Command or Script**

Set the command to:
```
toggle_wofi.sh
```
Then assign your preferred key combination (e.g. `Meta`).

Style: matches Kitty — Snazzy colors, JetBrainsMono Nerd Font, blue (`#57C7FF`) accent border.
`close_on_focus_loss=false` is intentional — closing is handled by the toggle script via PID file.

---

## tuigreet (login screen)

**Install greetd + tuigreet:**
```sh
sudo pacman -S greetd greetd-tuigreet kwallet-pam
```
More info: https://github.com/apognu/tuigreet

**Enable greetd as the display manager:**

Systemd only allows one display manager at a time. This snippet auto-detects and disables the current one (if any), then enables greetd:
```sh
current_dm=$(readlink /etc/systemd/system/display-manager.service 2>/dev/null)
[ -n "$current_dm" ] && sudo systemctl disable "$(basename "$current_dm" .service)"
sudo systemctl enable greetd
```

**Apply config:**
```sh
sudo cp tuigreet/config.toml /etc/greetd/config.toml
sudo cp tuigreet/pam.greetd /etc/pam.d/greetd
```

> Both files live in system directories — require sudo.

---

## Notes

- **NVM** is referenced in `.zshrc`. Install: https://github.com/nvm-sh/nvm
- **Go** PATH extension in `.zshrc` expects Go installed at standard location (`sudo pacman -S go`)
- **`gitpush` function** creates branches named `LEAD-OFFICE-<id>` — tweak the prefix to match your project
- **`~/.local/bin`** is in PATH via `.zshrc` (for terminals) and `~/.config/environment.d/local_bin.conf` (for KDE shortcuts)
