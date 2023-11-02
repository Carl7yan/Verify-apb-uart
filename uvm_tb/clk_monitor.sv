
class clk_rst_monitor extends uvm_monitor;

  virtual clk_rst_interface vifclk;
  clk_rst_cfg clk_cfg;

  protected clk_rst_seq_item clk_item;
  protected realtime prev_clk_rise;
  protected realtime prev_clk_fall;
  protected realtime t_high;
  protected realtime t_low;
  protected realtime t_reset;



  virtual task run_phase(uvm_phase phase);
    fork
      collect_clk();
      collect_rst();
    join // None of these are expected to return
    `uvm_fatal(get_name(),$sformatf("clk_rst_monitor threads ended! This should never happen."));
  endtask : run_phase
