# ---------------- 個人コマンドを最優先 ----------------
export PATH="$HOME/.local/bin:$PATH"     # ← direnv など

# ---------------- pyenv を有効化 ------------------------
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"      # pyenv 本体
eval "$(pyenv init --path)"              # shims を PATH 先頭へ

# ---------------- 対話用設定を取り込む ------------------
[ -f ~/.bashrc ] && . ~/.bashrc

