alias eza='eza --icons'
alias l='eza'
alias la='eza -alo'
alias ll='eza -lo'
alias tree='eza -T'

alias _='cd -'
alias ..='echo cd ..; cd ..'
alias dotfiles='echo cd \~/.dotfiles; cd ~/.dotfiles'

alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias gl='git log'
alias gp='git push'
alias gs='git status'

alias fedit='nvim $(fzf --preview="bat --color=always {}")'
alias session='tmux attach'
alias neofetch=fastfetch
