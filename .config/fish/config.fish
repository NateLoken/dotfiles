if status is-interactive
  alias vim="nvim"
  alias gstat="git status"
  alias gcln="git clone"
  alias ga="git add"
  alias gcb="git checkout"
  alias gcm="git checkout main"
  alias gcmsg="git commit -m"
  alias b="cd .."
    # Commands to run in interactive sessions can go here
end

starship init fish | source
zoxide init fish | source
fzf init fish | source

set fish_greeting ""
