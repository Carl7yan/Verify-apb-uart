
interface clk_rst_interface (
    output logic reset_n,
    output logic clk
  );
  //import clk_rst_pkg::*;
  logic reset_n_drv = 'z;
  logic clk_drv = 'z;

  // TBD do we need the 2 modports at all?
  modport driver (
    output reset_n     ,
    output clk         ,
    output reset_n_drv ,
    output clk_drv
  );

  modport monitor (
    input  reset_n     ,
    input  clk
  );
  // Drivable signals (not net type). Defaults to 'z so it works when the agent is passive

  // Continous assignments to drive the modport wires
  assign reset_n = reset_n_drv;
  assign clk     = clk_drv;

endinterface
