# 사용자용 실행파일 PATH 추가
export PATH="$PATH:$HOME/.local/bin"

# npm 패키지 매니저로 깐 모듈들 PATH 잡기
export PATH="$PATH:$HOME/.nvm/versions/node/v22.20.0/lib/node_modules/@mermaid-js/mermaid-cli/node_modules/.bin"

# zoxide 사용을 위한 eval(cd에 대한 zoxide alias는 setup.sh에서 자체적으로 적용중임)
eval "$(zoxide init bash)"


# kenGwon alias
alias vim='nvim'
alias vi='nvim'

alias ls='eza --color=always'
alias ll='eza --color=always --long --bytes --all' 
# alias ls='ls -Cv --color=auto'
# alias ll='ls -alFv --color=auto'
# alias lh='ls -alFvh --color=auto'
# alias la='ls -A --color=auto'
# alias l='ls -CFv --color=auto'
#
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias gr='grep -r -n -i'


alias python='python3'
alias cat='bat'

alias bmake='bear --append -- make'
alias bmakef='bear -- make'          # f = fresh

