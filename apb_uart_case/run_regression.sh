#!/usr/bin/env bash
set -uo pipefail

# ===== 路径配置 =====
PROJ=$(pwd)                         # 工程根目录（flist 在这）
FLIST=$PROJ/flist
TOP=work.tb_top
STAMP=$(date +%Y%m%d_%H%M%S)
RUNDIR=$PROJ/regression/$STAMP      # 本次 regression 专属目录

mkdir -p "$RUNDIR"/{logs,cov}
cd "$RUNDIR"                        # 之后所有产物都落在这里

# 方便随时看最新一次
ln -sfn "$RUNDIR" "$PROJ/regression/latest"

# ===== 编译一次（work/、compile.log 都在 RUNDIR 里）=====
vlib work
vmap work work
vlog -reportprogress 300 +cover -F "$FLIST" -l compile.log

# ===== case 列表：测试名 | 额外参数 | 标签 =====
TESTS=(
  "apb_reg_smoke_test||"
  "apb_rw_reg_test||"
  "apb_ro_reg_test||"
  "apb_invalid_addr_test||"
  "apb_safe_reg_random_test|-sv_seed 1|seed1"
  "apb_safe_reg_random_test|-sv_seed 2|seed2"
  "apb_safe_reg_random_test|-sv_seed 3|seed3"
)

REPORT=$RUNDIR/report.txt
printf "%-40s %6s %6s  %s\n" "TEST" "ERR" "FATAL" "RESULT" | tee "$REPORT"
printf '%.0s-' {1..64}; echo | tee -a "$REPORT"

# ===== 逐个 case 跑（每个独立进程 / 独立 log / 独立 ucdb）=====
for entry in "${TESTS[@]}"; do
  IFS='|' read -r name extra tag <<< "$entry"
  id=$name${tag:+_$tag}
  log=logs/$id.log
  ucdb=cov/$id.ucdb

  vsim -c $TOP +UVM_TESTNAME=$name $extra \
       -coverage -voptargs="+cover" \
       -l "$log" \
       -do "run -all; coverage save $ucdb; quit -f" || true

  err=$(grep -m1 'UVM_ERROR :'   "$log" | grep -oE '[0-9]+' | tail -1)
  fatal=$(grep -m1 'UVM_FATAL :' "$log" | grep -oE '[0-9]+' | tail -1)
  err=${err:--1}; fatal=${fatal:--1}
  if [[ "$err" == "0" && "$fatal" == "0" ]]; then res=PASS; else res=FAIL; fi

  printf "%-40s %6s %6s  %s\n" "$id" "$err" "$fatal" "$res" | tee -a "$REPORT"
done

# ===== 合并 coverage + 出报告 =====
if ls cov/*.ucdb >/dev/null 2>&1; then
  vcover merge  cov/merged.ucdb cov/*.ucdb
  vcover report -details -output cov/coverage_summary.txt cov/merged.ucdb
  vcover report -html -htmldir cov/html cov/merged.ucdb || true
fi

echo
echo "本次 regression 全部产物: $RUNDIR"
echo "  ├─ work/                 编译中间文件"
echo "  ├─ compile.log           编译日志"
echo "  ├─ logs/                 每个 case 的仿真日志"
echo "  ├─ cov/merged.ucdb       合并后的覆盖率"
echo "  ├─ cov/html/             覆盖率 HTML 报告"
echo "  └─ report.txt            PASS/FAIL 汇总"