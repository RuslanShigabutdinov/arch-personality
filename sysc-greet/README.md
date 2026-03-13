# sysc-greet (login screen)

Replaces tuigreet. Full-screen ASCII art background with the login form on top.
Uses greetd + sway (as a temporary greeter compositor) + kitty + sysc-greet.
After login, sway exits and KDE Plasma takes over normally.

More info: https://github.com/Nomadcxx/sysc-greet

---

## Install

sysc-greet is patched to add a **Static Art** background type — your own ASCII art
rendered full-screen behind the login form. The patch is `static-art-background.patch`.

```sh
# Required system packages
sudo pacman -S greetd sway kitty kwallet-pam go
```

**Build and install the patched version:**
```sh
mkdir -p ~/build/sysc-greet-sway
cp sysc-greet/PKGBUILD ~/build/sysc-greet-sway/
cp sysc-greet/static-art-background.patch ~/build/sysc-greet-sway/
cp sysc-greet/sysc-greet-sway.install ~/build/sysc-greet-sway/

cd ~/build/sysc-greet-sway
makepkg -si
```

The install script automatically:
- Creates the `greeter` user with correct groups
- Sets up `/var/cache/sysc-greet` and `/var/lib/greeter` permissions
- Writes `/etc/greetd/config.toml`
- Enables `greetd.service`

---

## Apply config

```sh
sudo cp sysc-greet/pam.greetd /etc/pam.d/greetd
sudo cp sysc-greet/sway-greeter-config /etc/greetd/sway-greeter-config
```

> `sway-greeter-config` is the same as the default but adds `--remember-username`.
> `pam.greetd` enables KWallet auto-unlock — not installed by default.

---

## Custom ASCII art — full-screen background

The patched build adds a **Static Art** background. It reads your art from:
```
/usr/share/sysc-greet/static-art.txt
```

The art is centered on screen and the login form floats on top of it.

```sh
sudo cp art.txt /usr/share/sysc-greet/static-art.txt
sudo chown greeter:greeter /usr/share/sysc-greet/static-art.txt
```

Then enable it at the login screen: **F1 → Backgrounds → Static Art**.
It will be saved and active on every boot.

---

## KWallet auto-unlock

The `pam.greetd` file handles kwallet auto-unlock via PAM.
For it to work, **the KWallet password must match your login password**.

If kwallet still doesn't auto-unlock, check:

1. Open KWallet Manager → make sure the default wallet uses **Blowfish** encryption,
   not GPG. GPG wallets cannot be auto-unlocked via PAM.

2. If you're on KDE 6 and `kwallet-pam` doesn't work, try:
   ```sh
   sudo pacman -S kwallet-pam
   # pam_kwallet5.so is the correct module name even on KDE 6 on Arch
   ```

3. Check PAM is actually being called:
   ```sh
   journalctl -u greetd -b | grep -i kwallet
   ```

4. Make sure the wallet file exists at `~/.local/share/kwalletd/kdewallet.kwl`
   (or the legacy path `~/.kde/share/apps/kwallet/kdewallet.kwl`).
   If it doesn't exist, open KWallet Manager and create it with Blowfish encryption
   and your login password.

---

## Interface

| Key | Action |
|---|---|
| Tab | Switch between username/password fields |
| Enter | Submit |
| F1 | Settings (themes, borders, backgrounds) |
| F2 | Session selection |
| F4 | Power menu (reboot/shutdown) |
| Page Up / Page Down | Cycle ASCII art variants |

Settings (theme, border style, etc.) are saved interactively via F1 — no static config file.

---

## Keyboard layout

If you use a non-US layout, edit `/etc/greetd/sway-greeter-config` and change:
```
xkb_layout "us"
```
to your layout code (e.g. `"gb"`, `"de"`, `"pl"`).

---

## Test without rebooting

```sh
sysc-greet --test
# or with debug log:
sysc-greet --test --debug
# log at: /tmp/sysc-greet-debug.log
```

---

## Logs

```sh
journalctl -u greetd -b          # greetd service log
cat /tmp/sysc-greet-debug.log    # app log (needs --debug flag)
cat /tmp/sysc-greet-wallpaper.log # wallpaper daemon log
```
