

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
