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

**Install toggle script** (bind this to a key in your compositor):
```sh
mkdir -p ~/.local/bin
cp wofi/toggle_wofi.sh ~/.local/bin/toggle_wofi.sh
chmod +x ~/.local/bin/toggle_wofi.sh
```

Style: matches Kitty — Snazzy colors, JetBrainsMono Nerd Font, blue (`#57C7FF`) accent border.
`close_on_focus_loss=false` is intentional — closing is handled by the toggle script via PID file.

---

## tuigreet (login screen)

**Install greetd + tuigreet:**
```sh
sudo pacman -S greetd tuigreet
sudo systemctl enable greetd
```
More info: https://github.com/apognu/tuigreet

**Apply config:**
```sh
sudo cp tuigreet/config.toml /etc/greetd/config.toml
```

> Lives in `/etc/greetd/` — requires sudo.

---

## Notes

- **NVM** is referenced in `.zshrc`. Install: https://github.com/nvm-sh/nvm
- **Go** PATH extension in `.zshrc` expects Go installed at standard location (`sudo pacman -S go`)
- **`gitpush` function** creates branches named `LEAD-OFFICE-<id>` — tweak the prefix to match your project
- **`~/.local/bin`** is already in PATH via `.zshrc`, so the wofi toggle script will be available everywhere
