# 02_ParallelCalculation.sh
#! /usr/bin/env bash
#$ -S /bin/bash
#$ -cwd
#$ -V
#$ -N parallel_calculation  # ジョブ名
#$ -q all.q@Cheryl          # 「Cheryl」というホストにある all.q キューを使う
#$ -pe smp 4                # 並列スロット数を指定（必要に応じて）
#$ -l h_vmem=4G             # スロットごとの最大メモリ
#$ -o logs/parallel_calculation.out
#$ -e logs/parallel_calculation.err

python 01_ParallelCalculation.py
