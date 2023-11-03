

		    // ------------ if read these config registers
function void apbuart_scoreboard::compare_config (apb_transaction apb_pkt);
	if(apb_pkt.PADDR == cfg.baud_config_addr) begin
		if(apb_pkt.PRDATA == baud_rate_reg)
			`uvm_info(get_type_name(),$sformatf("------ :: Baud Rate Match :: ------"),UVM_LOW)
		else
		    `uvm_error(get_type_name(),$sformatf("------ :: Baud Rate MisMatch :: ------"))
		`uvm_info(get_type_name(),$sformatf("Expected Baud Rate: %0d Actual Baud Rate: %0d",baud_rate_reg,apb_pkt.PRDATA),UVM_LOW)
		`uvm_info(get_type_name(),"------------------------------------\n",UVM_LOW)
	end

endfunction

		    // ------------ if w/r trans_data_addr
function void apbuart_scoreboard::compare_transmission (apb_transaction apb_pkt, uart_transaction uart_pkt);
	if(apb_pkt.PWDATA == uart_pkt.transmitter_reg)
   	`uvm_info(get_type_name(),$sformatf("------ :: Transmission Data Packet Match :: ------"),UVM_LOW)
  else
   	`uvm_error(get_type_name(),$sformatf("------ :: Transmission Data Packet MisMatch :: ------"))
	`uvm_info(get_type_name(),$sformatf("Expected Transmission Data Value : %0h Actual Transmission Data Value: %0h",apb_pkt.PWDATA,uart_pkt.transmitter_reg),UVM_LOW)
	`uvm_info(get_type_name(),"------------------------------------\n",UVM_LOW)
endfunction

		    // ------------ if w/r receive_data_addr
function void apbuart_scoreboard::compare_receive (apb_transaction apb_pkt , uart_transaction uart_pkt);
  if(apb_pkt.PRDATA == uart_pkt.payload)
   	`uvm_info(get_type_name(),$sformatf("------ :: Reciever Data Packet Match :: ------"),UVM_LOW)
	else
   	`uvm_error(get_type_name(),$sformatf("------ :: Reciever Data Packet MisMatch :: ------"))
	`uvm_info(get_type_name(),$sformatf("Expected Reciever Data Value : %0h Actual Reciever Data Value: %0h",uart_pkt.payload,apb_pkt.PRDATA),UVM_LOW)
	`uvm_info(get_type_name(),"------------------------------------\n",UVM_LOW)
	//$display("uart_pkt.sb_corr::%0b\tuart_pkt.sb_corr_bit[0]::%0b\tcfg.n_sb::%d",uart_pkt.sb_corr,uart_pkt.sb_corr_bit,cfg.parity[1]);
	if((uart_pkt.bad_parity && cfg.parity[1]) || (uart_pkt.sb_corr && (cfg.n_sb || uart_pkt.sb_corr_bit[0]))) begin
		//$display("uart_pkt.sb_corr::%0b\tuart_pkt.sb_corr_bit[0]::%0b\tcfg.n_sb::%d",uart_pkt.sb_corr,uart_pkt.sb_corr_bit[0],cfg.n_sb[0]);

		if(apb_pkt.PSLVERR == 1'b1)
			`uvm_info(get_type_name(),$sformatf("------ :: Error Match :: ------"),UVM_LOW)
		else
			`uvm_error(get_type_name(),$sformatf("------ :: Error MisMatch :: ------"))
		`uvm_info(get_type_name(),$sformatf("Expected Error Value : %0h Actual Error Value: %0h",1'b1,apb_pkt.PSLVERR),UVM_LOW)
		`uvm_info(get_type_name(),"------------------------------------\n",UVM_LOW)
	end
	else begin
		if(apb_pkt.PSLVERR == 1'b0)
			`uvm_info(get_type_name(),$sformatf("------ :: Error Match :: ------"),UVM_LOW)
		else
			`uvm_error(get_type_name(),$sformatf("------ :: Error MisMatch :: ------"))
		`uvm_info(get_type_name(),$sformatf("Expected Error Value : %0h Actual Error Value: %0h",1'b0,apb_pkt.PSLVERR),UVM_LOW)
		`uvm_info(get_type_name(),"------------------------------------\n",UVM_LOW)
	end
endfunction

