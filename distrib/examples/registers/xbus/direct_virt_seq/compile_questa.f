-mfcu
-timescale "1ns/1ns"
+acc=rmb
-suppress 2218,2181
+incdir+../../../../src 
../../../../src/uvm_pkg.sv 
+incdir+../../../xbus/sv
+incdir+../../../xbus/examples
+incdir+../common
+incdir+../common/reg_defn
+incdir+../common/sequences
../common/xbus_top.sv
+define+XA0_TOP_PATH=xbus_reg_tb_top.dut