#!/usr/bin/env bash
set -euo pipefail
# Mesh Avatar Studio 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/shinshin86/mesh-avatar-studio#try-the-sample
# 更新日期：2026-10-29
# 类型：script
cd "$(dirname "${BASH_SOURCE[0]}")"

command -v git >/dev/null 2>&1 || { echo "需要先安装 Git"; exit 1; }
command -v node >/dev/null 2>&1 || { echo "需要先安装 Node.js"; exit 1; }

mkdir -p .download
cd .download

node -e "const [a,b]=process.versions.node.split('.').map(Number); if(a<22||(a===22&&b<17)){console.error('需要 Node.js 22.17+，当前 '+process.versions.node);process.exit(1)}"
npx create-mesh-avatar-studio
cd mesh-avatar-studio
npm run dev
echo "已启动：http://127.0.0.1:5173"

echo ""
if command -v curl >/dev/null 2>&1; then
  echo "等待服务启动：http://127.0.0.1:5173"
  ready=0
  for _ in $(seq 1 30); do
    if curl -sS -o /dev/null "http://127.0.0.1:5173" 2>/dev/null; then ready=1; break; fi
    sleep 2
  done
  if [ "$ready" = "1" ]; then
    echo "服务已就绪"
  else
    echo "警告：60 秒内未探测到 http://127.0.0.1:5173，请手动打开确认或查看日志"
    exit 1
  fi
else
  echo "未检测到 curl，跳过启动探测；请手动访问 http://127.0.0.1:5173 确认"
fi
echo "部署完成：打开 http://127.0.0.1:5173 ，先用内置样例熟悉网格编辑，再让 Agent 按你的插画建新项目"
echo "若结果异常或需要改配置，请参考官方文档：https://github.com/shinshin86/mesh-avatar-studio#try-the-sample"
