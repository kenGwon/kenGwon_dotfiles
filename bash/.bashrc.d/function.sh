winpath() {
  if [ -z "$1" ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo "Usage: winpath <file>"
    echo "Convert Linux path to Windows style path with network share substitution."
    return 0
  fi 

  local build_server_ip abs_path transformed_target_path 

  # ip주소 획득
  build_server_ip=$(ip addr show | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | cut -d/ -f1)

  # 경로 변환 과정
  abs_path=$(realpath "$1" 2>/dev/null)
  if [ $? -ne 0 ]; then
    echo "Error: 파일 경로를 찾을 수 없습니다."
    return 1
  fi

  transformed_target_path=$(echo "$abs_path" | sed 's/\//\\/g')

  # 앞에다가 wsl 경로 붙이기
  transformed_target_path="\\\\wsl.localhost\\Ubuntu-24.04${transformed_target_path}"

  echo "$transformed_target_path"
}

evk_echo_nfs_mount() {
	echo "mount -t nfs -o nolock 192.168.0.100:/home/ghgwon /nfs"
	echo

	/usr/bin/cat << 'EOF'
ping 192.168.0.100 -c 1 > /dev/null 
if [ $? -eq 0 ] ; then 
  mount -t nfs -o nolock 192.168.0.100:/home/ghgwon /nfs 
  if [ $? -eq 0 ] ; then 
    df | grep nfs 
    echo "0.100 WSL ghgwon NFS mount success!!!" 
  fi 
fi
EOF
}

