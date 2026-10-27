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

**Install (patched, recommended):**

Stock wofi never marks result rows as hovered (GTK3 `GtkFlowBox` has no hover state), so `#entry:hover` in CSS does nothing.
`wofi/pkg/hover-state.patch` tracks the row under the pointer and gives it the `:hover` state. The package is `wofi-hover`; it replaces `wofi`.
```sh
mkdir -p ~/build/wofi-hover
cp wofi/pkg/PKGBUILD wofi/pkg/hover-state.patch ~/build/wofi-hover/
cd ~/build/wofi-hover
makepkg -si
```
> The `PKGBUILD` pins `pkgver=1.5.3` (same as Arch's official package). When Arch ships a newer wofi,
> bump `pkgver` and the tarball checksum, and re-check that `hover-state.patch` still applies.

Without the patch, plain `sudo pacman -S wofi` works too — everything except the hover highlight.

More info: https://hg.sr.ht/~scoopta/wofi

**Apply config:**
```sh
mkdir -p ~/.config/wofi
cp wofi/config ~/.config/wofi/config
cp wofi/style.css wofi/persona.css ~/.config/wofi/
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

Two themes — pick one with the `stylesheet=` line in `wofi/config`:
- `style.css` (default) — modern Spotlight-like card. Colors follow the KDE color scheme and accent color (System Settings → Colors & Themes): KDE exports the active scheme to `~/.config/gtk-3.0/colors.css` and the theme references those `@*_breeze` colors, so changing the scheme applies on the next wofi launch.
- `persona.css` — loud Persona-style menu: black panel with red stripes, slanted white/red bars, hard shadows, bold italic JetBrainsMono. Fixed red/black/white palette.

Copy both CSS files to `~/.config/wofi/` so switching is a one-line config change.
Hover highlight on result rows needs the patched `wofi-hover` package (see Install). The selected row has a slow light sweep (`shimmer` animation in `style.css`).
Closing: the toggle script (`pkill -x wofi || exec wofi`) opens on one press and closes on the next; `Escape` or clicking outside wofi (`close_on_focus_loss=true`) closes it too.

Search: `multi-contains` matching — space-separated words must all appear (`fire priv` → Firefox Private); app descriptions and categories are searched too (`browser` → Firefox).
Window shrinks to fit the results (`dynamic_lines`). Navigate with arrows or `Ctrl-j` / `Ctrl-k`.

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
