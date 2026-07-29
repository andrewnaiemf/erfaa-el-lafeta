#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

REPO_NAME="erfaa-el-lafeta"

echo "==> التحقق من GitHub CLI..."
if ! command -v gh >/dev/null 2>&1; then
  echo "خطأ: gh مش متثبت. ثبّته من: https://cli.github.com/"
  exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
  echo "محتاج تسجيل دخول GitHub مرة واحدة:"
  gh auth login
fi

OWNER="$(gh api user -q .login)"
echo "==> الحساب: $OWNER"

if [ ! -d .git ]; then
  echo "==> تهيئة git..."
  git init
  git branch -M main
fi

if [ -z "$(git status --porcelain 2>/dev/null || true)" ] && git rev-parse HEAD >/dev/null 2>&1; then
  echo "==> مفيش تغييرات جديدة للـ commit"
else
  echo "==> عمل commit..."
  git add index.html README.md deploy-github-pages.sh 2>/dev/null || git add .
  git commit -m "$(cat <<'EOF'
Publish ضد التيار game for GitHub Pages.

EOF
)" || echo "ممكن يكون مفيش تغييرات للـ commit"
fi

if ! git remote get-url origin >/dev/null 2>&1; then
  echo "==> إنشاء الريبو ورفعه..."
  gh repo create "$REPO_NAME" --public --source=. --remote=origin --push
else
  echo "==> رفع على origin..."
  git push -u origin HEAD
fi

BRANCH="$(git branch --show-current)"
echo "==> تفعيل GitHub Pages على فرع $BRANCH ..."

# تجاهل الخطأ لو Pages مفعّل قبل كده
gh api "repos/$OWNER/$REPO_NAME/pages" -X POST --input - >/dev/null 2>&1 <<EOF || true
{"build_type":"legacy","source":{"branch":"$BRANCH","path":"/"}}
EOF

# لو الريبو كان موجود ومصدر Pages مختلف، حدّثه
gh api "repos/$OWNER/$REPO_NAME/pages" -X PUT --input - >/dev/null 2>&1 <<EOF || true
{"build_type":"legacy","source":{"branch":"$BRANCH","path":"/"}}
EOF

PAGES_URL="https://${OWNER}.github.io/${REPO_NAME}/"
REPO_URL="https://github.com/${OWNER}/${REPO_NAME}"

echo ""
echo "✅ تم!"
echo "الريبو:  $REPO_URL"
echo "اللعبة:  $PAGES_URL"
echo ""
echo "ملاحظة: اللينك ممكن ياخد دقيقة أو اثنين لحد ما يشتغل أول مرة."
