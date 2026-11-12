#!/bin/bash
# 第二開発技工 WF（v3・v3.1 含む全案）を lein-inc/d2-kaihatu-wireframe-v3 に公開する
#   使い方: _publish.sh <github_token> ["コミットメッセージ"]
#   wf/ から公開物だけを同期（ビルド用スクリプト・作業フォルダ・社内メモ・キャプチャは除外）→ commit → push
set -e
cd "$(dirname "$0")"
TOKEN="$1"; MSG="${2:-WF更新}"
[ -z "$TOKEN" ] && { echo "usage: _publish.sh <github_token> [message]"; exit 1; }
rsync -a --delete \
  --exclude='.git/' --exclude='.github/' --exclude='_publish.sh' --exclude='.nojekyll' --exclude='captures/' --exclude='_v3/' \
  --exclude='_build.py' --exclude='_inject_gate.py' --exclude='_auth_gate.html' --exclude='_d2_*.py' --exclude='__pycache__/' \
  --exclude='CHANGELOG.md' --exclude='.gitignore' --exclude='引き継ぎ_*.md' --exclude='.DS_Store' \
  /Users/apple/site/dainigikou/wf/ ./
touch .nojekyll
[ -e 引き継ぎ_第二開発技工.md ] && { echo "引き継ぎメモが混入"; exit 1; }
git add -A
if git diff --cached --quiet; then echo "no changes"; exit 0; fi
git -c user.name="seki" -c user.email="naofumi@le-in.net" commit -q -m "$MSG

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
git push -q "https://${TOKEN}@github.com/lein-inc/d2-kaihatu-wireframe-v3.git" main
echo "PUSHED"
