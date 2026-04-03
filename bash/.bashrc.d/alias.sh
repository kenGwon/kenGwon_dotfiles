alias vim='nvim'
alias vi='nvim'
alias python='python3'
# alias ls='ls -Cv --color=auto'
# alias ll='ls -alFv --color=auto'
# alias lh='ls -alFvh --color=auto'
# alias la='ls -A --color=auto'
# alias l='ls -CFv --color=auto'
alias ls='eza --color=always'
alias ll='eza --color=always --long --bytes --all' 
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias gr='grep -r -n -i'



alias cat='batcat'
alias bmake='bear --append -- make'
alias bmakef='bear -- make'          # f = fresh

# zoxide 사용을 위한 eval(cd에 대한 zoxide alias는 setup.sh에서 자체적으로 적용중임)
eval "$(zoxide init bash)"

