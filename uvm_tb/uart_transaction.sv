`include "uvm_macros.svh"
import uvm_pkg::*;

class uart_transaction extends uvm_sequence_item;
  rand logic 	[31 : 0]   	payload; // 32-bit data that need to be sent on DUT RX pin serially in UART_DRIVER
  rand logic 	[31 : 0]    transmitter_reg; // 32-data monitored from DUT TX pin...sent to scoreboard from UART_MONITOR

	rand logic 			bad_parity;
	rand logic 			sb_corr;
	rand bit 			start_bit;
	rand bit 	  [1:0] 	stop_bits;

	rand logic 	[6:0]		bad_parity_frame;
	rand logic 	[6:0]		sb_corr_frame;
	rand logic 	[1:0]		sb_corr_bit;

	logic 	[35:0] 			payld_func;

	function bit [6:0] calc_parity 	(
										logic [31:0] payload, // send to RX
										logic [3:0] frame_len, // valid data num
										logic bad_parity, // error pointer
										logic ev_odd, // even or odd
										logic [6:0] bad_parity_frame
									);

		payld_func={{4{1'b0}},payload[31:0]};
		case(frame_len)
			6: begin
				for(int i=0;i<6;i++) begin
					calc_parity[i] = ev_odd?(^( payld_func[i*(6) +: 6] )) : (~^( payld_func[i*(6) +: 6] ));
					if(bad_parity && bad_parity_frame[i])
						calc_parity[i] = ~calc_parity[i];
				end
			end

			7: begin
				for(int i=0;i<5;i++) begin
					calc_parity[i] = ev_odd?(^( payld_func[i*(7) +: 7] )) : (~^( payld_func[i*(7) +: 7] ));
					if(bad_parity && bad_parity_frame[i])
						calc_parity[i] = ~calc_parity[i];
				end
			end

			8: begin
			  for(int i=0;i<4;i++)  begin
					calc_parity[i] = ev_odd?(^( payld_func[i*(8) +: 8] )) : (~^( payld_func[i*(8) +: 8] ));
					if(bad_parity && bad_parity_frame[i])
						calc_parity[i] = ~calc_parity[i];
				end
			end

			default: 	`uvm_error(get_type_name(),$sformatf("------ :: Incorrect frame length selected :: ------"))
		endcase
	endfunction

endclass



