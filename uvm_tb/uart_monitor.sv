
	  logic [6:0] 	count,count1;
	  logic [31:0] 	receive_reg;
	  logic [6:0] 	LT;
	  logic 	parity_en;


function void uart_monitor::cfg_settings();
	parity_en=cfg.parity[1];
	case(cfg.frame_len)
		5:		LT =7;
		6:		LT =6;
		7:		LT =5;
		8:		LT =4;
		9:		LT =4;
		default:	 `uvm_error(get_type_name(),$sformatf("------ :: Incorrect frame length selected :: ------"))
	endcase
endfunction

task uart_monitor::monitor_and_send ();
	count = 0;
	count1 = 1;

	for(int i=0;i<LT;i++) begin
    wait(!`MONUART_IF.Tx);  // waiting for start bit
		cfg_settings();
		repeat(cfg.baud_rate/2) @(posedge vifuart.PCLK);
		repeat(cfg.frame_len) begin
			repeat(cfg.baud_rate)@(posedge vifuart.PCLK);
			receive_reg[count]  = `MONUART_IF.Tx;
			count=count+1;
		end
		if(parity_en) begin // if parity is enabled
			repeat(cfg.baud_rate)@(posedge vifuart.PCLK); // wait for parity bit
		end
		repeat(cfg.n_sb+1) begin
			repeat(cfg.baud_rate)@(posedge vifuart.PCLK); // wait for parity bit
		end
	end
	trans_collected.transmitter_reg=receive_reg;
	item_collected_port_mon.write(trans_collected); // It sends the transaction non-blocking and it sends to all connected export
	receive_reg = 32'hx;
endtask
