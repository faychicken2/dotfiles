# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# --- Git branch in prompt ---
# Load the git prompt script
if [ -f /usr/share/git-core/contrib/completion/git-prompt.sh ]; then
  source /usr/share/git-core/contrib/completion/git-prompt.sh
fi

# Customize PS1 (your prompt)
#export PS1='\u@\h:\w$(__git_ps1 " (\[\033[1;33m\]%s\[\033[0m\])")\$ '
export PS1='\[\033[1;32m\]\u@\h\[\033[0m\]:\[\033[1;34m\]\w\[\033[0m\]$(__git_ps1 " (\[\033[1;33m\]%s\[\033[0m\])")\$ '

alias codium="flatpak run com.vscodium.codium"
#alias code="flatpak run com.vscodium.codium"

alias cdls='codex resume'
alias cdlsa='codex resume --all'

# Search recursively from the current directory by name or quoted pattern.
f() {
    if [[ $# -ne 1 ]]; then
        printf 'Usage: f <name or quoted pattern>\n' >&2
        return 2
    fi
    find . -name "$1"
}

alias vi='nvim'
alias vim='nvim'
alias vimdiff='nvim -d'
export EDITOR=nvim
export VISUAL=nvim
