alias l='eza --icons'
alias ll='eza -l --icons'
alias la='eza -al --icons'

alias _='cd -'
alias ..='echo cd ..; cd ..'
alias dotfiles='echo cd \~/.dotfiles; cd ~/.dotfiles'

alias fedit='nvim $(fzf --preview="bat --color=always {}")'
alias session='tmux attach'
alias neofetch=fastfetch
