#!/usr/bin/env bash
# 从上游 GitHub release 下载静态站点资产到 content/（CI 构建时执行）。
# 版本号取自 package.yml，资产带 .sha256 校验。
set -euo pipefail

VERSION=$(grep '^version:' package.yml | awk '{print $2}')
REPO="shaom/keyboard-island"
ZIP_URL="https://github.com/${REPO}/releases/download/v${VERSION}/keyboard-island-v${VERSION}.zip"
SHA_URL="https://github.com/${REPO}/releases/download/v${VERSION}/keyboard-island-v${VERSION}.sha256"

echo "Fetching keyboard-island v${VERSION} ..."
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

curl -fsSL --retry 4 --retry-delay 2 --connect-timeout 15 --max-time 300 "$ZIP_URL" -o "$TMP/site.zip"
curl -fsSL --retry 4 --retry-delay 2 --connect-timeout 15 --max-time 60 "$SHA_URL" -o "$TMP/site.sha256"

# 校验：.sha256 内容形如 "<hash>  <filename>"
EXPECTED=$(awk '{print $1}' "$TMP/site.sha256")
ACTUAL=$(sha256sum "$TMP/site.zip" | awk '{print $1}')
if [ "$EXPECTED" != "$ACTUAL" ]; then
  echo "sha256 mismatch: expected $EXPECTED got $ACTUAL" >&2
  exit 1
fi

unzip -q "$TMP/site.zip" -d "$TMP/unpacked"

# 兼容 zip 内有无顶层目录两种布局：定位 index.html 所在目录
if [ -f "$TMP/unpacked/index.html" ]; then
  SRC="$TMP/unpacked"
elif [ -f "$TMP/unpacked/public/index.html" ]; then
  SRC="$TMP/unpacked/public"
else
  SRC=$(dirname "$(find "$TMP/unpacked" -name index.html | head -1)")
fi
if [ -z "${SRC:-}" ] || [ ! -f "$SRC/index.html" ]; then
  echo "index.html not found in release zip" >&2
  exit 1
fi

mkdir -p content
rm -rf content/*
cp -r "$SRC"/. content/
echo "content/ ready ($(find content -type f | wc -l) files)"
