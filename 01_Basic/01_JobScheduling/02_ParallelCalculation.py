# 02_ParallelCalculation.py
import networkx as nx
import multiprocessing
from typing import Tuple

def process_edge(edge: Tuple[str, str]) -> Tuple[Tuple[str, str], float]:
    u, v = edge
    # 仮の処理：uとvの近傍の共通数を中心性の代理とする
    neighbors_u = set(G.neighbors(u))
    neighbors_v = set(G.neighbors(v))
    score = len(neighbors_u & neighbors_v) / max(1, len(neighbors_u | neighbors_v))
    return ((u, v), score)

def init_graph(path: str) -> nx.Graph:
    G = nx.read_edgelist(path)
    return G

if __name__ == "__main__":
    import os
    from functools import partial

    input_path = "network.edgelist"  # edge list形式のファイル
    G = init_graph(input_path)

    edges = list(G.edges())
    print(f"Processing {len(edges)} edges...")

    # グローバル変数としてGを子プロセスが使えるように（注意：Linuxでのみ推奨）
    with multiprocessing.Pool(processes=8) as pool:
        results = pool.map(process_edge, edges)

    # 保存や分析
    with open("edge_scores.tsv", "w") as f:
        for (u, v), score in results:
            f.write(f"{u}\t{v}\t{score:.4f}\n")