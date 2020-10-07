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

### key bindings ###
select_history() {
    local selected="$(history -nr 1 | awk '!a[$0]++' | fzf --query "$LBUFFER" | sed 's/\\n/\n/g')"
    if [ -n "$selected" ]; then
        BUFFER="$selected"
        CURSOR=$#BUFFER
    fi
    zle -R -c # refresh screen
}

select_cdr() {
    local selected="$(cdr -l | awk '{ $1=""; print }' | sed 's/^ //' | fzf --preview "fzf-preview-directory '{}'" --preview-window=right:50%)"
    if [ -n "$selected" ]; then
        BUFFER="cd $selected"
        zle accept-line
    fi
    zle -R -c # refresh screen
}

select_ghq() {
    local root="$(ghq root)"
    local selected="$(GHQ_ROOT="$root" ghq list | fzf --preview "fzf-preview-git $root/{}" --preview-window=right:60%)"
    if [ -n "$selected" ]; then
        BUFFER="cd \"$(GHQ_ROOT="$root" ghq list --exact --full-path "$selected")\""
        zle accept-line
    fi
    zle -R -c # refresh screen
}

select_ghq_go() {
    local root="$GOPATH/src"
    local selected="$(GHQ_ROOT="$root" ghq list | fzf --preview "fzf-preview-git $root/{}" --preview-window=right:60%)"
    if [ -n "$selected" ]; then
        BUFFER="cd \"$(GHQ_ROOT="$root" ghq list --exact --full-path "$selected")\""
        zle accept-line
    fi
    zle -R -c # refresh screen
}

select_dir() {
    local selected="$(fd --hidden --color=always --exclude='.git' --type=d . $(git rev-parse --show-cdup 2> /dev/null) | fzf --preview "fzf-preview-directory '{}'" --preview-window=right:50%)"
    if [ -n "$selected" ]; then
        BUFFER="cd $selected"
        zle accept-line
    fi
    zle -R -c # refresh screen
}

zle -N select_history
zle -N select_cdr
zle -N select_ghq
zle -N select_ghq_go
zle -N select_dir

bindkey -v
bindkey "^R"       select_history        # C-r
bindkey "^F"       select_cdr            # C-f
bindkey "^G"       select_ghq            # C-g
bindkey "^[g"      select_ghq_go         # Alt-g
bindkey "^O"       select_dir            # C-o
bindkey "^A"       beginning-of-line     # C-a
bindkey "^E"       end-of-line           # C-e
bindkey "^?"       backward-delete-char  # backspace
bindkey "^[[3~"    delete-char           # delete
bindkey "^[[1;3D"  backward-word         # Alt + arrow-left
bindkey "^[[1;3C"  forward-word          # Alt + arrow-right
bindkey "^[^?"     vi-backward-kill-word # Alt + backspace
bindkey "^[[1;33~" kill-word             # Alt + delete

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
