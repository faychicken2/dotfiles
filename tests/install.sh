#!/usr/bin/env bash
set -euo pipefail
REPO=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
test_root=$(mktemp -d)
trap 'rm -rf -- "$test_root"' EXIT
mkdir -p "$test_root/repo" "$test_root/home/.config/nvim" "$test_root/bin"
cp -a "$REPO/install.sh" "$REPO/rc" "$test_root/repo/"
export HOME="$test_root/home"
installer="$test_root/repo/install.sh"
printf 'old bash\n' > "$HOME/.bashrc"
printf 'old nvim\n' > "$HOME/.config/nvim/old.lua"
printf 'unrelated\n' > "$HOME/.config/unrelated"
chmod 640 "$HOME/.bashrc"
"$installer" --dry-run
[[ ! -e "$test_root/repo/backups" && ! -e "$HOME/.dotfiles-install.lock" ]]
[[ $(cat "$HOME/.bashrc") == 'old bash' ]]
(cd /tmp && "$installer")
backup=$(find "$test_root/repo/backups" -name .bashrc -print -quit)
[[ $(cat "$backup") == 'old bash' && $(stat -c %a "$backup") == 640 ]]
[[ ! -e "$HOME/.config/nvim/old.lua" && -f "$HOME/.config/unrelated" ]]
cmp "$HOME/.bashrc" "$test_root/repo/rc/.bashrc"
"$installer"
[[ $(find "$test_root/repo/backups" -name .bashrc | wc -l) == 2 ]]
# Inject a deployment rename failure after the original has been moved aside.
cat > "$test_root/bin/mv" <<'WRAPPER'
#!/usr/bin/env bash
for arg in "$@"; do
    if [[ $arg == */.dotfiles-stage.*/new ]]; then exit 1; fi
done
exec /usr/bin/mv "$@"
WRAPPER
chmod +x "$test_root/bin/mv"
printf 'rollback original\n' > "$HOME/.bashrc"
if PATH="$test_root/bin:$PATH" "$installer"; then echo 'Expected rename failure' >&2; exit 1; fi
[[ $(cat "$HOME/.bashrc") == 'rollback original' ]]
[[ ! -e "$HOME/.dotfiles-install.lock" ]]
# Dangling destination links must be backed up as links and replaced safely.
rm "$HOME/.bashrc"
ln -s "$test_root/missing" "$HOME/.bashrc"
"$installer"
[[ ! -L "$HOME/.bashrc" ]]
[[ -n $(find "$test_root/repo/backups" -name .bashrc -type l -print) ]]
# Linked destination parents must be rejected even in preview mode.
mv "$HOME/.config" "$HOME/config-real"
ln -s "$HOME/config-real" "$HOME/.config"
if "$installer" --dry-run; then echo 'Expected linked parent rejection' >&2; exit 1; fi
rm "$HOME/.config"
mv "$HOME/config-real" "$HOME/.config"
# Missing masters are skipped; nested linked masters fail without deployment.
rm "$test_root/repo/rc/.tmux.conf"
preview=$("$installer" --dry-run)
[[ $preview == *'SKIP: .tmux.conf'* ]]
ln -s /tmp "$test_root/repo/rc/nvim/link"
if "$installer" --dry-run; then echo 'Expected linked master rejection' >&2; exit 1; fi
mkdir "$HOME/.dotfiles-install.lock"
if "$installer"; then echo 'Expected lock rejection' >&2; exit 1; fi
[[ -d "$HOME/.dotfiles-install.lock" ]]
echo 'All installer tests passed.'
