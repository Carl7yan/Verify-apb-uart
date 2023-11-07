module tbench_top;


  apbuart_property assertions (
                            	.PCLK(PCLK),
                 	        	  .PRESETn(PRESETn),
	             	            .PSELx(vifapb.PSELx),
	            	            .PENABLE(vifapb.PENABLE),
	             	            .PWRITE(vifapb.PWRITE),
	             	            .PREADY(vifapb.PREADY),
	             	            .PSLVERR(vifapb.PSLVERR),
	             	            .PWDATA(vifapb.PWDATA),
	             	            .PADDR(vifapb.PADDR),
	             	            .PRDATA(vifapb.PRDATA)
                              );

endmodule
