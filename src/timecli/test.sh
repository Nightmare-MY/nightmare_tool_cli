set -e
set -E
trap 'echo 脚本检测到错误，为防止后续脚本失败，已自动停止。' ERR
/Users/nightmare/Desktop/nightmare-space/nightmare_tool_cli/src/timecli/timecli sleep 3