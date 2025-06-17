# ---------- ~/.bashrc ----------
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"                 # シェルフック
eval "$(pyenv virtualenv-init -)"      # 自動 activate
eval "$(direnv hook bash)"             # .venv 自動化

cd $HOME/workspace/TrafficSimulation/
