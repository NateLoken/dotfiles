if status is-interactive
  alias vim="nvim"
  # Git commands
  alias gs="git status --short"

  alias ga="git add"
  alias gp="git push"
  alias gu="git pull"
  alias gf="git fetch"
  alias gb="git branch"
  alias gl="git log --all --graph --pretty=\
      format:'%C(magenta)%h %C(white) %an %ar%C(auto) %D%n%s%n'"

  alias gsw="git switch"
  alias gc="git commit"
  alias gcl="git clone"
  alias b="cd .."
    # Commands to run in interactive sessions can go here
end

starship init fish | source
zoxide init fish | source

set fish_greeting | fortune | cowsay -f actually
