# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# 프롬프트에 git branch/status를 표시하기 위해 __git_ps1을 로드
# (bash-completion 패키지가 보통 자동으로 로드해주지만, 없는 환경을 위한 fallback)
if ! declare -f __git_ps1 >/dev/null 2>&1; then
    for _git_prompt_sh in \
        /usr/lib/git-core/git-sh-prompt \
        /usr/share/git-core/contrib/completion/git-prompt.sh \
        /usr/share/git/completion/git-prompt.sh \
        /etc/bash_completion.d/git-prompt \
        /opt/homebrew/etc/bash_completion.d/git-prompt.sh; do
        [ -r "$_git_prompt_sh" ] && source "$_git_prompt_sh" && break
    done
    unset _git_prompt_sh
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    _ps1_title='\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]'
    ;;
*)
    _ps1_title=''
    ;;
esac

if declare -f __git_ps1 >/dev/null 2>&1; then
    # 대형 모노레포에서 파일 개수에 비례해 느려지는 옵션은 저장소 크기와 무관하게 전역으로 끔
    #   - GIT_PS1_SHOWDIRTYSTATE / SHOWUNTRACKEDFILES: 전체 워킹트리 스캔 비용 (파일 수 비례)
    #   - GIT_PS1_HIDE_IF_PWD_IGNORED: 매 프롬프트마다 git check-ignore 추가 호출 (설정 안 함)
    # 나머지는 O(1) 또는 커밋 수 비례라 레포 크기와 무관하게 항상 켬
    GIT_PS1_SHOWSTASHSTATE=1
    GIT_PS1_SHOWUPSTREAM="auto"
    GIT_PS1_SHOWCOLORHINTS=1
    GIT_PS1_SHOWCONFLICTSTATE="yes"

    if [ "$color_prompt" = yes ]; then
        _ps1_prefix="${_ps1_title}"'${debian_chroot:+($debian_chroot)}\[\033[4;36m\]\u@\h\[\033[00m\]:\[\033[01;35m\]\w\[\033[00m\]'
    else
        _ps1_prefix="${_ps1_title}"'${debian_chroot:+($debian_chroot)}\u@\h:\w'
    fi

    __git_ps1_update() {
        __git_ps1 "$_ps1_prefix" '\$ ' ' (%s)'
    }

    # zoxide 등 기존 PROMPT_COMMAND(cd 훅 등)를 덮어쓰지 않고 뒤에 추가
    PROMPT_COMMAND="${PROMPT_COMMAND%;}"
    PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }__git_ps1_update"
elif [ "$color_prompt" = yes ]; then
    PS1="${_ps1_title}"'${debian_chroot:+($debian_chroot)}\[\033[4;36m\]\u@\h\[\033[00m\]:\[\033[01;35m\]\w\[\033[00m\]\$ '
else
    PS1="${_ps1_title}"'${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

unset color_prompt force_color_prompt _ps1_title
