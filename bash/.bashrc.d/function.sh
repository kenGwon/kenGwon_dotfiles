winpath() {
  if [ -z "$1" ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo "Usage: winpath <file>"
    echo "Convert Linux path to Windows style path with network share substitution."
    return 0
  fi

  local abs_path transformed_target_path

  # 절대 경로 획득
  abs_path=$(realpath "$1" 2>/dev/null)
  if [ $? -ne 0 ]; then
    echo "Error: 파일 경로를 찾을 수 없습니다."
    return 1
  fi

  transformed_target_path=$(echo "$abs_path" | sed 's/\//\\/g')

  # 런타임 환경 감지
  if grep -qiE "microsoft|wsl" /proc/version 2>/dev/null; then
    # === WSL 환경 ===
    # WSL distro 이름 동적 획득 (없으면 fallback)
    local distro_name
    distro_name=$(wslvar WSL_DISTRO_NAME 2>/dev/null || echo "$WSL_DISTRO_NAME")
    [ -z "$distro_name" ] && distro_name="Ubuntu-24.04"

    transformed_target_path="\\\\wsl.localhost\\${distro_name}${transformed_target_path}"
  else
    # === 원격 리눅스 서버 환경 ===
    local build_server_ip transformed_user_path
    build_server_ip=$(ip addr show \
      | grep "inet " \
      | grep -v 127.0.0.1 \
      | awk '{print $2}' \
      | cut -d/ -f1 \
      | head -n1)

    transformed_user_path=$(echo "$HOME" | sed 's/\//\\/g')

    if [[ "$transformed_target_path" == "$transformed_user_path"* ]]; then
      transformed_target_path="\\\\${build_server_ip}\\${USER}${transformed_target_path#"$transformed_user_path"}"
    fi
  fi

  echo "$transformed_target_path"
}

evk_echo_nfs_mount() {
	echo "mount -t nfs -o nolock 192.168.0.99:/home/ghgwon /nfs"
	echo

	/usr/bin/cat << 'EOF'
ping 192.168.0.99 -c 1 > /dev/null 
if [ $? -eq 0 ] ; then 
  mount -t nfs -o nolock 192.168.0.99:/home/ghgwon /nfs 
  if [ $? -eq 0 ] ; then 
    df | grep nfs 
    echo "0.100 WSL ghgwon NFS mount success!!!" 
  fi 
fi
EOF
}

