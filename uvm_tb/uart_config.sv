class uart_config extends uvm_object;
    // From APB AGENTs
    rand bit [31:0] frame_len;  // frame length
    rand bit [31:0] n_sb;       // stop bit
    rand bit [31:0] parity;     // parity
    rand bit [31:0] bRate;      // baud rate
    // To UART Monitor
         bit [31:0] baud_rate;

    const int loop_time = 10;

    function void baudRateFunc();
        case (bRate)
            32'd4800: 	baud_rate = 32'd10416;
            32'd9600: 	baud_rate = 32'd5208;
	          32'd14400:	baud_rate = 32'd3472;
            32'd19200: 	baud_rate = 32'd2604;
            32'd38400: 	baud_rate = 32'd1302;
	          32'd57600: 	baud_rate = 32'd868;
            32'd115200: baud_rate = 32'd434;
            32'd128000: baud_rate = 32'd392;

            default:  	baud_rate = 32'd5208;
        endcase
    endfunction

endclass
