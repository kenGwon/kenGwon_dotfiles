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

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    _ps1_title='\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]'
    ;;
*)
    _ps1_title=''
    ;;
esac

if [ "$color_prompt" = yes ]; then
    _ps1_prefix="${_ps1_title}"'${debian_chroot:+($debian_chroot)}\[\033[4;36m\]\u@\h\[\033[00m\]:\[\033[01;35m\]\w\[\033[00m\]'
else
    _ps1_prefix="${_ps1_title}"'${debian_chroot:+($debian_chroot)}\u@\h:\w'
fi

# 1순위: gitstatus(gitstatusd) - 병렬 스캔 데몬이라 대형 모노레포에서도 dirty/staged/untracked를
# 전부 빠르게 보여줄 수 있음. romkatv/gitstatus 서브모듈이 있고 데몬 기동에 성공할 때만 사용.
_gitstatus_plugin="$(dirname "${BASH_SOURCE[0]}")/vendor/gitstatus/gitstatus.plugin.sh"
if [ -r "$_gitstatus_plugin" ] && source "$_gitstatus_plugin"; then
    # tmux 등에서 새 pane을 열면, 이 pane과 무관한 예전 프로세스가 export해둔
    # GITSTATUS_DAEMON_PID/_GITSTATUS_REQ_FD 등을 그대로 물려받는 경우가 있다.
    # gitstatus_start는 GITSTATUS_DAEMON_PID가 있으면 "이미 시작됨"으로 보고
    # 그냥 넘어가버리는데, 그 FD는 이 프로세스에서 연 적이 없어서
    # "Bad file descriptor" 에러가 난다. gitstatus_stop은 자신이 연 게 맞는지
    # (_GITSTATUS_CLIENT_PID == $BASHPID) 확인 후 아니면 변수만 안전하게 지워주므로,
    # 매번 먼저 호출해서 물려받은 상태를 정리하고 이 프로세스 몫을 새로 연다.
    gitstatus_stop 2>/dev/null
fi

if [ -r "$_gitstatus_plugin" ] \
    && declare -f gitstatus_start >/dev/null 2>&1 \
    && gitstatus_start -s -1 -u -1 -c -1 -d -1 2>/dev/null; then

    __prompt_update() {
        local seg="" color=32 extra=""

        if gitstatus_query -t 0.5 2>/dev/null && [ "$VCS_STATUS_RESULT" = "ok-sync" ]; then
            # 브랜치명은 사용자가 통제 못 하는(악의적 문자열일 수 있는) 값이라
            # PS1에 직접 박지 않고, 간접 변수 참조(${__ps1_git_branch})로만 노출한다.
            # (PS1은 promptvars로 인해 표시 시점에 재평가되므로, 여기서 직접 텍스트를
            #  합쳐넣으면 브랜치명에 담긴 $(...) 가 실행될 수 있다 - git-prompt.sh와 동일한 방어)
            __ps1_git_branch="${VCS_STATUS_LOCAL_BRANCH:-${VCS_STATUS_COMMIT:0:8}}"

            if [ "${VCS_STATUS_HAS_CONFLICTED:-0}" != "0" ]; then
                color=31  # 빨강: conflict
            elif [ "${VCS_STATUS_HAS_STAGED:-0}" != "0" ] || [ "${VCS_STATUS_HAS_UNSTAGED:-0}" != "0" ] || [ "${VCS_STATUS_HAS_UNTRACKED:-0}" != "0" ]; then
                color=33  # 노랑: dirty/staged/untracked
            fi

            [ "${VCS_STATUS_NUM_STAGED:-0}" -gt 0 ] 2>/dev/null && extra+=" +${VCS_STATUS_NUM_STAGED}"
            [ "${VCS_STATUS_NUM_UNSTAGED:-0}" -gt 0 ] 2>/dev/null && extra+=" !${VCS_STATUS_NUM_UNSTAGED}"
            [ "${VCS_STATUS_NUM_UNTRACKED:-0}" -gt 0 ] 2>/dev/null && extra+=" ?${VCS_STATUS_NUM_UNTRACKED}"
            [ "${VCS_STATUS_COMMITS_AHEAD:-0}" -gt 0 ] 2>/dev/null && extra+=" ⇡${VCS_STATUS_COMMITS_AHEAD}"
            [ "${VCS_STATUS_COMMITS_BEHIND:-0}" -gt 0 ] 2>/dev/null && extra+=" ⇣${VCS_STATUS_COMMITS_BEHIND}"
            [ -n "${VCS_STATUS_ACTION:-}" ] && extra+="|${VCS_STATUS_ACTION}"

            printf -v seg ' (\[\033[%sm\]${__ps1_git_branch}\[\033[00m\]%s)' "$color" "$extra"
        fi

        PS1="${_ps1_prefix}${seg}"'\$ '
    }

    # zoxide 등 기존 PROMPT_COMMAND(cd 훅 등)를 덮어쓰지 않고 뒤에 추가
    PROMPT_COMMAND="${PROMPT_COMMAND%;}"
    PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }__prompt_update"

else
    # 2순위: 순정 git-prompt.sh (gitstatus 서브모듈이 없거나 데몬을 못 띄우는 환경 - 구형 서버 등)
    # (bash-completion 패키지가 보통 __git_ps1을 자동으로 로드해주지만, 없는 환경을 위한 fallback)
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

    if declare -f __git_ps1 >/dev/null 2>&1; then
        # 대형 모노레포에서 파일 개수에 비례해 느려지는 옵션은 저장소 크기와 무관하게 전역으로 끔
        #   - GIT_PS1_SHOWDIRTYSTATE / SHOWUNTRACKEDFILES: 전체 워킹트리 스캔 비용 (파일 수 비례)
        #   - GIT_PS1_HIDE_IF_PWD_IGNORED: 매 프롬프트마다 git check-ignore 추가 호출 (설정 안 함)
        # 나머지는 O(1) 또는 커밋 수 비례라 레포 크기와 무관하게 항상 켬
        GIT_PS1_SHOWSTASHSTATE=1
        GIT_PS1_SHOWUPSTREAM="auto"
        GIT_PS1_SHOWCOLORHINTS=1
        GIT_PS1_SHOWCONFLICTSTATE="yes"

        __git_ps1_update() {
            __git_ps1 "$_ps1_prefix" '\$ ' ' (%s)'
        }

        PROMPT_COMMAND="${PROMPT_COMMAND%;}"
        PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }__git_ps1_update"
    else
        # 3순위: git 정보 없이 기본 프롬프트만
        PS1="${_ps1_prefix}"'\$ '
    fi
fi

unset color_prompt force_color_prompt _ps1_title _gitstatus_plugin
