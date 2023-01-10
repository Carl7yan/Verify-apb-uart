TEST=apbuart_free_error_test
SCALE=1ns
FILE = testname.f
TEST_NAMES =`cat $(FILE)`

compile:
			@vcs -debug_all \
	 	  -cpp g++-4.8 -cc gcc-4.8 -LDFLAGS -Wl,--no-as-needed -lpthread \
			-sverilog -ntb_opts uvm-1.2 -f flist -timescale=1ns/1ps -cm line+tgl+cond+branch+assert+fsm -assert -full64 -LDFLAGS '-Wl,--no-as-needed'

run_test:
			@./simv -l ${TEST}.log +UVM_TIMEOUT=900000000 +UVM_TESTNAME=${TEST}


# regression ----------------------------------
run:
			@for i in $(TEST_NAMES); do \
				./simv -l $$i.log +UVM_TIMEOUT=900000000 +UVM_TESTNAME=$$i;\
			done

run_cov_all:
			@rm -rf ${TEST_NAMES} ; mkdir ${TEST_NAMES}
			@for i in $(TEST_NAMES); do \
				./simv -l $$i.log +UVM_TIMEOUT=900000000 +UVM_TESTNAME=$$i -cm line+tgl+cond+branch+assert+fsm; \
				cp -rf simv.vdb $$i/; \
				mv $$i.log $$i/; \
			done
			urg -dir *_test/*.vdb -elfile exclusion.el -excl_bypass_checks

dve:
			@dve -covdir *_test/*.vdb &
# -----------------------------------------------

test_list:
			@for i in $(TEST_NAMES); do \
				echo $$i; \
			done

cn:
			rm -rf csrc *DVEfiles urgReport simv.vdb ${TEST_NAMES} inter.vpd dump.vcd simv simv.daidir ucli.key vc_hdrs.h vcs.log .inter.vpd.uvm *.log
