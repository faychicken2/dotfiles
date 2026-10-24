# Portable Linux dotfiles

A small Bash installer using standard GNU/Linux utilities. No root, package
installation, plugins, or network access is needed. Configurations are copied,
so the installed files remain usable without this checkout.

## First installation

The included configs are minimal starting points, **not copies of your current
setup**. Review and customize them first, especially `.bashrc`: replacing it can
remove distribution or work-specific initialization. Keep those settings in the
master if shared, or in `~/.bashrc.local` if private. Review existing Neovim files
before replacing the whole directory.

```bash
git clone git@github.com:faychicken2/dotfiles.git
cd dotfiles
./install.sh --dry-run
./install.sh
```

After Neovim itself and Git are installed on the machine, bootstrap the Neovim
plugins with one command:

```bash
./rc/nvim/setup.sh
```

This runs the safe installer and starts Neovim once in headless mode so the
declared plugins are downloaded. It does not install OS packages, language
servers, or Tree-sitter parsers; those vary between Fedora, Rocky, and other
Linux distributions and remain explicit choices.

Preview prints destinations and whether they need backup without writing files.
It validates paths and master types but does not predict disk space or write
permissions. Keep your current shell open while testing a new interactive shell.
Restart Neovim to load its configuration; in tmux use `tmux source-file
~/.tmux.conf` to reload. The installer never changes your running shell.

## What is managed

| Master | Installed destination |
| --- | --- |
| `rc/.bashrc` | `$HOME/.bashrc` |
| `rc/.tmux.conf` | `$HOME/.tmux.conf` |
| `rc/nvim/` | `$HOME/.config/nvim/` |
| `rc/i3/config` | `$HOME/.config/i3/config` |

Neovim keeps core settings and personal mappings in `rc/nvim/lua/config/`.
Plugin-specific setup lives in `rc/nvim/after/plugin/`, so each plugin has a
clear place for future changes.

Git is not deployed by the installer yet. To create a local Git configuration
from the safe template, run:

```bash
cp -n .gitconfig.template "$HOME/.gitconfig"
nvim "$HOME/.gitconfig"
```

The `-n` option leaves an existing `~/.gitconfig` untouched.
The template contains placeholders only. Keep credentials, signing keys, and
work-specific settings in your home directory rather than in this repository.

The explicit `CONFIGS` array in `install.sh` is the complete allowlist. Missing
masters are reported and skipped. Git configuration is deliberately not managed
yet. Local overrides are never deployed: `~/.bashrc.local`,
`~/.tmux.conf.local`, and `~/.config/nvim.local.lua`. Neovim uses the standard
`~/.config` location here; custom `XDG_CONFIG_HOME` setups need an adjusted mapping.

Each existing destination is copied with `cp -a` to a unique private directory:
`backups/<hostname>/<UTC-timestamp>.<random-suffix>/`, retaining its relative path.
Modes and symlinks are preserved. Backups of symlinks preserve the link itself,
not an independent copy of its external target; the installer never alters that
target. Master configurations must contain only regular files and directories.
Linked destination parent directories are rejected.

The installer stages a complete new configuration beside its destination,
finishes the backup, moves the original aside, then renames the new copy into
place. Directories are replaced as a whole, so obsolete managed files do not
linger; unrelated paths are untouched. Repeated installs are safe and create
fresh backups even if contents match. Backups are never automatically pruned.

A per-home lock prevents overlapping runs of this installer. Do not edit managed
files or run another deployment tool during installation. This is a per-entry
operation, not a transaction across all three configurations: earlier successful
entries remain installed if a later one fails. Errors return nonzero.

## Recovery

On a normal error or caught INT/TERM/HUP signal, the installer restores the moved
original if its destination is absent. It reports and retains staging directories
for inspection when interrupted; it never overwrites a destination to roll back.
If disk errors prevent restoration, the original remains in the reported
`.dotfiles-stage.*/previous` path and the completed snapshot remains available.

Power loss and `kill -9` cannot be trapped. Inspect `.dotfiles-stage.*` under
`$HOME` and `$HOME/.config`, plus the printed backup directory. If the managed
destination is absent, move the corresponding staging `previous` item back to
its original destination. If a destination exists, preserve it before restoring
anything. After verifying no installer is running and recovering interrupted
entries, remove the empty lock with:

```bash
rmdir "$HOME/.dotfiles-install.lock"
```

To restore a snapshot manually, first move the current configuration to a fresh,
unused recovery path, then copy the snapshot into its now-absent destination.
For example, after selecting the desired snapshot:

```bash
snapshot='/absolute/path/to/backups/host/timestamp.suffix'
recovery=$(mktemp -d "$HOME/dotfiles-recovery.XXXXXXXX")
# Run the copy only if preserving the current config succeeds.
mv -T -- "$HOME/.bashrc" "$recovery/.bashrc" &&
    cp -a -- "$snapshot/.bashrc" "$HOME/.bashrc"
```

For Neovim, use `.config/nvim` inside the snapshot and `$HOME/.config/nvim` as
the destination. If the destination is already absent, no move is necessary.
This is not a durable filesystem transaction or a replacement for off-machine
backups.

## Comparing and promoting changes

```bash
diff -u rc/.bashrc "$HOME/.bashrc"
diff -ru rc/nvim "$HOME/.config/nvim"
diff -u "$snapshot/.bashrc" "$HOME/.bashrc"
```

`diff` exits 1 for differences and 2 for errors. Review desired changes, copy them
into `rc/`, inspect `git diff`, then commit and push. Other machines pull and run
`./install.sh`. Standalone `backup.sh` and `diff.sh` are deferred; this MVP
backs up automatically during installation and uses standard `diff` directly.

Raw `backups/` and private `local/` contents are ignored. Only deliberately
sanitized history belongs in `history/`; see its README. Nothing automatically
commits or pushes data. `.gitignore` is not a security boundary: never force-add
raw backups. This directory was not initialized as a Git repository by the
installer implementation; initialize it and review staged files before your
first commit.

## Validation

```bash
bash -n install.sh tests/install.sh
bash tests/install.sh
```

Tests copy the project into a temporary directory and use a temporary `HOME`.
They cover preview, existing files/directories, modes, repeated installs,
missing masters, dangling destination links, unsafe parent/master links,
locking, and rollback after an injected rename failure. They do not alter your
actual dotfiles.
