<!-- <h1>01_ParallelCalculation</h1>
    <h2>概要</h2>
    並列計算の基礎を学ぶ。
    <h2>0. 目次</h2>
        <ol>
            <li><a href=#freq></a></li>
        </ol>
    <h2 id=freq></h2>
    SEGの並列化≠Pythonの並列化 -->
# 🚀 並列化処理 README

## 1️⃣ 並列処理の種類

- **multiprocessing** : 1台のマシンで複数CPUを利用
- **SGEアレイジョブ** : 同じ処理を複数回、独立に実行
- **SGEパラレルジョブ（MPI）** : 複数CPU/ノードで協調計算
- **MPI + multiprocessing** : ノード間MPI、ノード内multiprocessing

---

## 🍳 料理で例えると

| 技術            | 例え                       |
|-----------------|---------------------------|
| multiprocessing | 1キッチンで複数コンロ調理 |
| SGEアレイ       | 各家で同じ弁当を作る      |
| SGEパラレル(MPI)| 1料理を皆で協力           |
| メモリ          | 調理台の広さ              |
| MPI+multi       | 各家で複数人分担調理      |

---

## ⚖️ メリット・デメリット

| 技術     | メリット            | デメリット              |
|----------|--------------------|-------------------------|
| multiprocessing | 簡単、同一メモリ | 1台限定               |
| SGEアレイ | 多数タスク管理容易 | 通信なし               |
| MPI      | 大規模分散可能     | 設計難易度↑             |
| MPI+multi| フル資源活用       | 複雑                   |

---

## 🔧 実行例スニペット

### multiprocessing
```python
from multiprocessing import Pool
def f(x): return x*x
with Pool(4) as p:
    print(p.map(f, range(10)))
```

### SGEアレイ

```bash
#$ -t 1-100
python process.py data_${SGE_TASK_ID}.txt
```

### SGEパラレル(MPI)

```bash
#$ -pe mpi 16
mpirun -np 16 ./simulate
```

### MPI + multiprocessing

```python
from mpi4py import MPI
from multiprocessing import Pool
comm = MPI.COMM_WORLD
rank, size = comm.Get_rank(), comm.Get_size()
data = range(100)
chunk = data[rank::size]
with Pool(4) as p:
    results = p.map(lambda x: x*x, chunk)
all_results = comm.gather(results, root=0)
if rank==0:
    print(sum(all_results, []))
```

---

## 🐛 トラブル例

| 症状                | 対処法                     |
| ----------------- | ----------------------- |
| CPU oversubscribe | `Pool`数=SGE割当CPUに制限     |
| メモリ不足             | `-l mem=4G`等で確保         |
| ファイル名競合           | `rank`や`SGE_TASK_ID`含める |

---

## 🔗 参考

* [https://mpi4py.readthedocs.io/](https://mpi4py.readthedocs.io/)
* [https://docs.python.org/3/library/multiprocessing.html](https://docs.python.org/3/library/multiprocessing.html)
* [https://arc.liv.ac.uk/SGE/](https://arc.liv.ac.uk/SGE/)

