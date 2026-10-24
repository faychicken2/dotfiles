#!/usr/bin/env bash
# Copy whole configurations; never merge directory trees.
set -Eeuo pipefail
umask 077
REPO=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
CONFIGS=( '.bashrc|.bashrc' '.tmux.conf|.tmux.conf' 'nvim|.config/nvim' 'i3/config|.config/i3/config' )
dry_run=false
case ${1:-} in
    --dry-run) dry_run=true ;;
    --help|-h) echo "Usage: $0 [--dry-run]"; exit 0 ;;
    '') ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
esac
[[ $# -le 1 ]] || { echo 'Too many arguments' >&2; exit 2; }
fail() { echo "ERROR: $*" >&2; exit 1; }
exists() { [[ -e $1 || -L $1 ]]; }
[[ ${HOME:-} == /* && -d $HOME && $HOME != / ]] || fail 'HOME must be an existing absolute directory other than /'
TARGET_HOME=$(cd -- "$HOME" && pwd -P)
[[ $REPO != "$TARGET_HOME" ]] || fail 'Repository must not be HOME itself'
# Refuse linked parent directories so deployment cannot escape the intended home.
for entry in "${CONFIGS[@]}"; do
    rel=${entry#*|}
    dest="$TARGET_HOME/$rel"
    [[ $REPO != "$dest" && $REPO != "$dest/"* ]] || fail "Repository is inside managed destination: $dest"
    parent=$(dirname -- "$dest")
    [[ ! -L $parent ]] || fail "Symlinked destination parent: $parent"
    [[ ! -e $parent || -d $parent ]] || fail "Destination parent is not a directory: $parent"
done
snapshot=''
stage=''
dest=''
locked=false
cleanup() {
    status=$?
    if (( status != 0 )); then echo "FAILED: installation stopped (exit $status); completed entries remain installed." >&2; fi
    trap - EXIT INT TERM HUP
    if [[ -n $stage && -d $stage ]]; then
        if exists "$stage/previous"; then
            if ! exists "$dest"; then
                if mv -T -- "$stage/previous" "$dest"; then
                    echo "RESTORE: $dest" >&2
                else
                    echo "RECOVERY REQUIRED: original remains in $stage/previous" >&2
                    status=1
                fi
            else
                echo "RECOVERY: original retained in $stage/previous" >&2
            fi
        fi
        # On failure retain staging contents for manual inspection/recovery.
        echo "STAGING: $stage" >&2
    fi
    if $locked; then rmdir -- "$TARGET_HOME/.dotfiles-install.lock" || true; fi
    exit "$status"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
trap 'exit 129' HUP
if ! $dry_run; then
    mkdir -- "$TARGET_HOME/.dotfiles-install.lock" || fail 'Installer lock exists; see README recovery instructions'
    locked=true
fi
for entry in "${CONFIGS[@]}"; do
    name=${entry%%|*}
    rel=${entry#*|}
    src="$REPO/rc/$name"
    dest="$TARGET_HOME/$rel"
    if ! exists "$src"; then echo "SKIP: $name (missing master)"; continue; fi
    # Copies must be independent of the checkout, including nested files.
    [[ -f $src || -d $src ]] || fail "Unsupported master type: $src"
    unsupported=$(find "$src" ! -type f ! -type d -print -quit)
    [[ -z $unsupported ]] || fail "Master contains a symlink or special file: $src"
    if $dry_run; then
        if exists "$dest"; then echo "WOULD BACKUP: $dest"; fi
        echo "WOULD INSTALL: $src -> $dest"
        continue
    fi
    parent=$(dirname -- "$dest")
    mkdir -p -- "$parent"
    stage=$(mktemp -d "$parent/.dotfiles-stage.XXXXXXXX")
    cp -a -- "$src" "$stage/new"
    if exists "$dest"; then
        if [[ -z $snapshot ]]; then
            # Disallow linked backup roots to avoid redirecting private snapshots.
            [[ ! -L $REPO/backups ]] || fail 'backups must not be a symlink'
            host=$(hostname -s)
            host=${host//[^a-zA-Z0-9_.-]/_}
            [[ -n $host && $host != . && $host != .. ]] || host=unknown
            root="$REPO/backups/$host"
            [[ ! -L $root ]] || fail 'Host backup directory must not be a symlink'
            mkdir -p -- "$root"
            snapshot=$(mktemp -d "$root/$(date -u +%Y-%m-%d_%H%M%S).XXXXXXXX")
            echo "SNAPSHOT: $snapshot"
        fi
        backup="$snapshot/$rel"
        mkdir -p -- "$(dirname -- "$backup")"
        cp -a -- "$dest" "$backup"
        echo "BACKUP: $dest -> $backup"
        # Same-filesystem renames allow rollback without copying a partial tree.
        mv -T -- "$dest" "$stage/previous"
    fi
    mv -T -- "$stage/new" "$dest"
    echo "INSTALL: $dest"
    # The original is now safely stored in the completed snapshot.
    rm -rf -- "$stage"
    stage=''
done
if $dry_run; then echo 'Dry run complete; no files changed.'; else echo 'Installation complete.'; fi
