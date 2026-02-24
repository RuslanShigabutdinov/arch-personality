# arch-personality

My personal Arch Linux setup. Configs for kitty, zsh + oh-my-zsh, and tuigreet.

---

## Kitty (terminal)

**Install:** https://sw.kovidgoyal.net/kitty/binary/

```sh
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
```

Or via pacman:
```sh
sudo pacman -S kitty
```

**Apply config:**
```sh
mkdir -p ~/.config/kitty
cp kitty/kitty.conf ~/.config/kitty/kitty.conf
cp kitty/Snazzy.conf ~/.config/kitty/Snazzy.conf
```

Theme used: **Snazzy** — dark background (`#282a36`), vivid colors.
Based on [hyper-snazzy](https://github.com/sindresorhus/hyper-snazzy).

Font: **JetBrainsMono Nerd Font** — install from https://www.nerdfonts.com/

---

## Zsh + Oh My Zsh

**Install zsh:**
```sh
sudo pacman -S zsh
chsh -s $(which zsh)
```

**Install Oh My Zsh:** https://ohmyzsh.sh
```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

**Apply config** (after OMZ is installed):
```sh
cp zsh/.zshrc ~/.zshrc
source ~/.zshrc
```

Theme used: **gnzh** (built into OMZ, no extra install needed).

Plugins enabled: `git`, `catimg`, `colored-man-pages`, `docker`, `docker-compose`, `ssh`, `sudo`

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

> Note: greetd config lives in `/etc/greetd/` and requires sudo.

---

## Notes

- NVM (Node Version Manager) is referenced in `.zshrc`. Install it from https://github.com/nvm-sh/nvm
- Go is expected at standard GOPATH for the PATH extension in `.zshrc`
- `gitpush` is a custom function for branch-based workflows — tweak `LEAD-OFFICE-` prefix to your project
