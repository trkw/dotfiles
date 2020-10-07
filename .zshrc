if  [ -e ~/.zinit/bin/zinit.zsh ]; then
  source ~/.zinit/bin/zinit.zsh

  autoload -Uz _zinit
  (( ${+_comps} )) && _comps[zinit]=_zinit

  zinit light zdharma/fast-syntax-highlighting

  zinit load zdharma/history-search-multi-word

  zinit light zsh-users/zsh-autosuggestions
  zinit wait lucid atload"zicompinit; zicdreplay" blockf for \
  zsh-users/zsh-completions

  zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'

  alias update-zinit='zinit self-update && zinit update'
fi

if  [ -e ~/.dash ] && [ -e ~/dotfiles ]; then
  alias update-dash-brewfile='brew bundle dump -f && diff -u ~/dotfiles/osx ./Brewfile ; mv ./Brewfile ~/dotfiles/osx'
  alias update-dash-dotfiles='git -C ~/dotfiles/ pull'
  alias update-dash='update-dash-dotfiles && update-zinit && ~/.dash/bin/update'
fi

if  [ -e /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/ ]; then
  source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
  source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
fi

if  [ -e $HOME/.nodebrew/current/bin ]; then
  export PATH=$HOME/.nodebrew/current/bin:$PATH
fi

setopt print_exit_value
setopt nolistbeep

if [[ "$(locale LC_CTYPE)" == "UTF-8" ]]; then
    setopt combining_chars
fi

HISTSIZE=1000
SAVEHIST=10000
setopt hist_ignore_dups
setopt extended_history
setopt hist_reduce_blanks
setopt hist_no_store
setopt inc_append_history

# history fuzzy find
function select_history() {
    BUFFER=$(history -n -r 1 | fzf --no-sort +m --query "$LBUFFER" --prompt="History > ")
    CURSOR=$#BUFFER
}
zle -N select_history
bindkey "^r" select_history

# repository fuzzy find
function select_ghq() {
    local target_dir=$(ghq list -p | fzf --query="$LBUFFER")

    if [ -n "$target_dir" ]; then
    BUFFER="cd ${target_dir}"
    zle accept-line
    fi

    zle reset-prompt
}
zle -N select_ghq
bindkey "^g" select_ghq

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias sl='ls'
case "${OSTYPE}" in
freebsd*|darwin*)
  alias ll="ls -alGF"
  ;;
linux*)
  alias ll="ls -alF --color"
  ;;
esac
alias grep='grep --color=auto'
alias his='history'
