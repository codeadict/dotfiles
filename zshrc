source ~/.dotfiles/zsh/antigen.zsh
antigen use oh-my-zsh
antigen bundle autojump
antigen bundle zsh-users/zsh-syntax-highlighting
antigen apply

# completion
autoload -U compinit
compinit
autoload bashcompinit
bashcompinit
compdef g='git'

# make completion
# https://github.com/zsh-users/zsh-completions/issues/541#issuecomment-384223016
zstyle ':completion:*:make:*:targets' call-command true
zstyle ':completion:*:make:*' tag-order targets

# Load environment
source ~/.dotfiles/env

# history search
bindkey '\C-p' history-beginning-search-backward
bindkey '\C-n' history-beginning-search-forward
bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward 

# history
setopt histignoredups
export HISTSIZE=10000

# helper functions
function truncate_string {
  max=$1
  ellipsis=$(if [ ! -z $2 ]; then echo $2; else echo "…"; fi)
  read string
  len=$(echo "${#string}")
  if [ $len -gt $max ]; then
    print $string[1,$(($max - 1))]$ellipsis
  else
    print $string
  fi
}

# aixterm color escape sequences: bright but *not* bold, work also when the
# option "Draw bold text in bright colors" in iTerm2 is unchecked.
typeset -A fg_bright
fg_bright[black]="[90m"
fg_bright[red]="[91m"
fg_bright[green]="[92m"
fg_bright[yellow]="[93m"
fg_bright[blue]="[94m"
fg_bright[magenta]="[95m"
fg_bright[cyan]="[96m"
fg_bright[white]="[97m"

# prompt
__PROMPT_VCS_DELIMITER_COLOR="$fg_bright[black]"
__PROMPT_VCS_DIRTY_COLOR="$fg[red]"
__PROMPT_VCS_BRANCH_COLOR="$fg[green]"
__PROMPT_VCS_HASH_COLOR="$fg[yellow]"
__PROMPT_EXIT_CODE_STR="%(?..%{$fg[red]%}↯%?%{$reset_color%} )"
__PROMPT_DELIMITER_COLOR="$fg_bright[black]"
__PROMPT_TIME_COLOR="$fg_bright[black]"
__PROMPT_PWD_COLOR="$fg[blue]"

function __accept_line_and_enable_warning {
  __PROMPT_EXIT_CODE=$__PROMPT_EXIT_CODE_STR
  zle accept-line
}
zle -N __accept_line_and_enable_warning
bindkey '^M' __accept_line_and_enable_warning

function __find_git_root {
  git rev-parse --show-toplevel > /dev/null 2>&1
}

function __git_dirty {
  test -n "`git status --porcelain`"
}

function __git_branch {
  git rev-parse --abbrev-ref HEAD 2>/dev/null
}

function __git_abbrev_branch {
  __git_branch | truncate_string 20 "⋯"
}

function __git_hash {
  git log -1 --format="%h" 2>/dev/null || print '(none)'
}

function __git_prompt {
  if __find_git_root; then
    local dirty_str=''
    if __git_dirty; then
      dirty_str='*'
    fi

    print "%{$__PROMPT_VCS_DIRTY_COLOR%}${dirty_str}%{$reset_color%}"\
"%{$__PROMPT_VCS_BRANCH_COLOR%}$(__git_abbrev_branch)%{$reset_color%}"\
"%{$__PROMPT_VCS_DELIMITER_COLOR%}@%{$reset_color%}"\
"%{$__PROMPT_VCS_HASH_COLOR%}$(__git_hash)%{$reset_color%} "
  fi
}

function __abbrev_pwd {
  setopt extendedglob
  local pwd="${PWD/#$HOME/~}"
  if [[ "$pwd" == (#m)[/~] ]]; then
    print $MATCH
  else
    print "${${${(@j:/:M)${(@s:/:)pwd}##.#?}:h}%/}/${pwd:t}"
  fi
}

PROMPT=\
"%{$__PROMPT_TIME_COLOR%}"'%D{%H:%M} '\
'${__PROMPT_EXIT_CODE}$(__git_prompt)'\
"%{$__PROMPT_DELIMITER_COLOR%}"'${__PROMPT_BG}'\
"%{$__PROMPT_PWD_COLOR%}"'$(__abbrev_pwd)'"%{$reset_color%}
%{$__PROMPT_DELIMITER_COLOR%}%#>{$reset_color%} "

source $HOME/.asdf/completions/asdf.bash
