#%%
import pandas as pd
import numpy as np
from IPython.display import display


# 列の抽出はfilterを使う。
df.filter(
          items=['col1', 'col2'], 
          axis='columns'
          )\
  .filter(
          like='col',  # 特定の文字列を含む列を抽出
          axis='columns'
          )\
  .filter(
          regex='(col | +.3)',  # 複数種類の文字列を指定したいときは正規表現も使える
          axis='columns'
          )

# 特定の条件を満たす行の抽出
df.query(# デフォルトではengine='numexpr'なので、より高速なengine='python'を使う。
         'col1 == 1'
         , engine='python'
         )\
  .query(# 複数queryを組み合わせるときは{and, or}もしくは{&, |}を使う。
         'col1 == 1 and col2 == 2'
         )\
  .query(# 複数queryを組み合わせるときは\を使って改行すると可読性が高まる。
         'col1 == 1 or col2 != 2\
          & col3==3'
         )\
  .query(# 特定の文字列を含む列を抽出、regex=Trueなら正規表現を使う。
         'col3.str.contains("a", regex=False)'
         )\
  .query(# 変数を使うときは@を使う。f文字列を使っても良いが、バグになりやすいので注意。
         'col1 == @var1'
         )\
  .query(# ミュータブル変数の要素を含む行を抽出。
         'col1 in [1, 2, 3]\
          or col1 in @mutable'
         )\

# 特定の条件を満たす行の削除
df.drop_duplicates(
                   subset=['col1', 'col2'], 
                   keep='first'  # 'first'なら重複した最初の行, 'last'なら最後の行, Falseなら重複した行を全て残す
                   ignore_index=True  # 重複した行を削除した後にインデックスをリセットする
                   )
