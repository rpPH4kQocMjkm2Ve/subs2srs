# subs2srs

Fork of [erjiang/subs2srs](https://github.com/erjiang/subs2srs) — a tool that creates
[Anki](https://apps.ankiweb.net/) flashcards from movies and TV shows with subtitles,
for language learning.

## Credits

- [Christopher Brochtrup](https://sourceforge.net/projects/subs2srs/) — original author of subs2srs
- [erjiang](https://github.com/erjiang/subs2srs) — Linux/Mono port
- [nihil-admirari](https://github.com/nihil-admirari/subs2srs-net48-builds) — updated
  TagLibSharp, SourceGrid dependencies and SubsReTimer builds
- [Ren Tatsumoto](https://aur.archlinux.org/packages/subs2srs) — original AUR packaging
  (launcher script, desktop entries, fontconfig rule, icon extraction, system tool symlinks)

## Changes from upstream

- **Fix preview deadlock on Linux (wayland):** replaced `BackgroundWorker` + modal dialog
  with synchronous execution to avoid Mono WinForms permanently graying out the form.
- **Build with `mcs` directly** via Makefile instead of msbuild/xbuild.
- **No Microsoft fonts required:** fontconfig rule maps "Microsoft Sans Serif"
  to Noto Sans CJK JP.
- **Launcher script** that keeps config in `~/.config/subs2srs/`.
- **Bundled SubsReTimer** — a subtitle timing synchronization tool.
- **System tools via symlinks:** ffmpeg, mp3gain, mkvextract, mkvinfo are expected
  from the system, not bundled.

## Dependencies

- [mono](https://www.mono-project.com/)
- [ffmpeg](https://ffmpeg.org/)
- [mp3gain](https://mp3gain.sourceforge.net/)
- [mkvtoolnix](https://mkvtoolnix.download/) (mkvextract, mkvinfo)

Optional:
- [noto-fonts-cjk](https://github.com/notofonts/noto-cjk) — for Japanese/Chinese/Korean UI text

## Build

```sh
make build
```

## Install

### Arch Linux (AUR)

```sh
yay -S subs2srs-git
```

### Manual

```sh
git clone https://gitlab.com/fkzys/subs2srs.git
cd subs2srs
sudo make install
```

Installs to `/opt/subs2srs/`, launcher to `/usr/bin/subs2srs`.

## Configuration

On first run, `preferences.txt` is copied to `~/.config/subs2srs/`.
The application runs from that directory.
