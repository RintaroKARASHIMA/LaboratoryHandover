#!/bin/bash

# pyenvのインストール
git clone https://github.com/pyenv/pyenv.git ~/.pyenv

# pyenv-virtualenvのインストール
git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv

pyenv install --list

# 好きなバージョンをインストール (xxは任意のバージョン番号)
pyenv install 3.xx.xx
pyenv global 3.xx.xx


# mkdir -p ~/.local/bin

# direnvの最新バージョン番号を確認
VERSION=$(curl -s https://api.github.com/repos/direnv/direnv/releases/latest | grep tag_name | cut -d '"' -f 4)

# direnvの最新のバイナリをダウンロード（例：Linux用 amd64）
curl -L "https://github.com/direnv/direnv/releases/download/${VERSION}/direnv.linux-amd64" -o ~/.local/bin/direnv

# 実行権限を付与
chmod +x ~/.local/bin/direnv

mkdir -p workspace

# 一度ログアウトします。
exit