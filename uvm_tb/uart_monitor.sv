`define MONUART_IF vifuart.MONITOR.monitor_cb

class uart_monitor extends uvm_monitor;
	`uvm_component_utils(uart_monitor)

  	virtual uart_if 			vifuart;

  	uart_config 	cfg;
  	uvm_analysis_port #(uart_transaction) item_collected_port_mon;
  	uart_transaction trans_collected;

	  logic [6:0] 	count,count1;
	  logic [31:0] 	receive_reg;
	  logic [6:0] 	LT;
	  logic 			parity_en;

  	function new (string name, uvm_component parent);
  	  	super.new(name, parent);
  	  	trans_collected = new();
  	  	item_collected_port_mon = new("item_collected_port_mon", this);
  	endfunction : new

	  extern virtual function void build_phase(uvm_phase phase);
	  extern virtual function void cfg_settings();
	  extern virtual task monitor_and_send();
	  extern virtual task run_phase(uvm_phase phase);
endclass

function void uart_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(uart_config)::get(this, "", "cfg", cfg))
		`uvm_fatal("No cfg",{"Configuration must be set for: ",get_full_name(),".cfg"});
  if(!uvm_config_db#(virtual uart_if)::get(this, "", "vifuart", vifuart))
   	`uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vifuart"});
endfunction: build_phase

task uart_monitor::run_phase(uvm_phase phase);
	super.run_phase(phase);
	forever begin
		@(posedge vifuart.PCLK);
		cfg_settings(); // extracting parity enable (parity_en) and loop time (LT).
		monitor_and_send();
	end
endtask : run_phase

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
