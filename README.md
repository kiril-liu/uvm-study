# Minimal UVM Environment
一个用于学习的uvm环境
## 配置
软件：QuestaSim
## 介绍
两个最小tb环境：一个是纯sv，一个是包含uvm组件的。
dut是32bit 4opcode的ALU，不包含时钟。
## 运行
### 编译
vlog +cover=sbceft -F flist
### 仿真
vsim -coverage -sv_seed 1 -do "run -all; coverage save -directive -cvg -codeAll ./alu_seed1.ucdb; quit -sim" work.tb_top
### Merge覆盖率文件：
vcover merge alu.ucdb alu_seed0.ucdb alu_seed1.ucdb
## 结果
- 保留了一个错误的opcode，可以在结果中看到当op=2时，也就是AND操作大概率会报错。
- 约束a,b的输入为[0:30],定义功能点cross(cp_op, a_kind, b_kind)是4种ALU操作在不同输入类别（如 0/1/30/[0:29]）下的情况。
- 运行 3 个不同 seed，每个 seed 100 笔 transaction，共 300 笔。每次运行生成 .ucdb，最终对 3 个 .ucdb 进行 merge。
- Merge 后 cross 覆盖率为 48%（31/64 cross bins 命中）。这说明随机激励已经覆盖到一部分 “op × 输入类别组合”的功能点，但仍有 33/64 的组合未命中。
