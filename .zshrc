ZSH_THEME=""
ZSH_TMUX_AUTOSTART=true

export PATH="/home/kkelso/projects/Extra_Scripts/bin:/home/kkelso/projects/ARC_2022_09_EMM/MetaWare/arc/bin/:/home/kkelso/projects/clangd_15.0.6/bin:/home/kkelso/.local/bin/:/home/kkelso/bin:/apps/xilinx/Xilinx_Vivado_SDK_Web_2018.3_1207_2324/SDK/2018.3/bin:/home/kkelso/go/bin:$PATH:$HOME/.pyenv/bin"
export METAWARE_LOCAL_VERSION="2022.09"
export EDITOR="nvim"

export AG_DEFAULT_OPTIONS="--path-to-ignore ~/.ignore --stats --workers 24"
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'

setopt autocd
autoload -Uz compinit && compinit
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

HYPHEN_INSENSITIVE="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# Add wisely, as too many plugins slow down shell startup.
plugins=(
    fzf-zsh-plugin
    tmux
    zsh-autosuggestions
    zsh-syntax-highlighting
)

export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
# For a full list of active aliases, run `alias`.
source $HOME/projects/dotfiles/aliases.zsh


# Theme configuration
fpath+=($HOME/.zsh/pure)
autoload -U promptinit; promptinit
prompt pure
export PURE_PROMPT_SYMBOL="$"

# pyenv configuration
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
 eval "$(pyenv init -)"
fi
