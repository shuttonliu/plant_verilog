vlog *.v ;#編譯
vsim -voptargs="+acc" work.tb; #模擬(非最佳化) 測試程式
vcd file sim.vcd ;#產生波形圖
vcd add -r /tb/*; #add wave/testbench底下所有訊號
run -all; #模擬
vcd checkpoint; #顯示最後一次的變化值
quit
