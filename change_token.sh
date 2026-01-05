#!/usr/bin/env bash
set -euo pipefail

# 보안주의. stdout로 출력되지 않도록할 것.
# export로 임시등록만하고, bashrc 등에 등록하지 말것
OLD_TOKEN="${OLD_GIT_TOKEN}"
NEW_TOKEN="${NEW_GIT_TOKEN}"

# 기준이 되는 루트 디렉터리 # default: 현 경로
ROOT_DIR="${1:-$(pwd)}"

# 루트 디렉터리에서 recursive하게 모든 .git 디렉터리를 찾아 config 수정
echo "Scanning under: $ROOT_DIR"
echo "Replacing token: OLD_TOKEN -> NEW_TOKEN"

# GNU sed 기준 (-i''는 BSD/macOS면 -i '' 로 바꿔야 함)
find "$ROOT_DIR" -type d -name ".git" | while read -r gitdir; do
  config="$gitdir/config"
  if [ -f "$config" ]; then
    echo "Updating: $config"
    # 백업 파일 만들고 싶으면 -i.bak 사용
    sed -i "s/${OLD_TOKEN}/${NEW_TOKEN}/g" "$config"
  fi
done

echo "Done."
