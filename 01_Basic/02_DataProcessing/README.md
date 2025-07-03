## 前提

- 次のディレクトリ構成の中で`notebooks`または`src`ディレクトリ内で動作するプログラムのテンプレートとする。

## コーディング規約

- 全てのパッケージ名、ファイル名、関数名、変数名で5単語以下を繋げたスネークケースのみを用いる。
  - そのうち、`notebooks`の各ファイルにおいて、関数をまたいで利用する変数(e.g., データのファイルパス)のみアッパースネークケース。
- データがそんなに大きくないので、`メモリ効率` より `可読性` の高い処理を優先する。
- `メモリ効率`の高い処理は、文字通り可読性よりもメモリ効率を優先した処理を指し、例えばpandasでは再帰代入（recursive query/function）が挙げられる。
- メモリ効率の高い処理は、メモリ効率を優先した処理を指し、例えばpandasでは再帰代入（recursive query/function）が挙げられる。
- `可読性`の高い処理は、メモリ効率よりも可読性を優先した処理を指し、例えばpandasではquery methodとmethod chainingが挙げられる。
  - 例: 
    ```python
    # method chaining
    df.query('col1 == 1')\
      .assign(col2 = lambda x: x['col1'] * 2)
    ```
- なお、保守性のためにどちらの処理においても余計なコピーや参照エラーが発生しやすく可読性の低いBoolean Indexingや、推奨されないchaining(chained indexing/assignment、あるいはhidden chaining)、mutatingといった処理は使わない。
  - 例: 
    ```python
    # Boolean Indexing
    df[[df['col1'] == 1]]

    # Chained Indexing
    df[df['col1'] == 1]['col2'] = 3

    # Mutating
    df['col1'] = 2
    df['col1'] = df['col1'].astype(np.int64)


    ```