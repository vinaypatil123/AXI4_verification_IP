//  Module: axi_top
//
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "axi_interface.sv"
`include "axi_sequence_item_read.sv"
`include "axi_master_configuration.sv"
`include "axi_sequencer_read.sv"
`include "axi_sequence_read.sv"
`include "axi_master_driver_read.sv"
`include "axi_slave_driver_read.sv"
`include "axi_monitor_read.sv"
`include "axi_master_agent_read.sv"
`include "axi_slave_agent_read.sv"
`include "axi_environment_read.sv"
`include "axi_test_read.sv"

module axi_top_read;

    bit clock;
    bit reset;
    axi_interface axi_intf(clock, reset);

    
    always #1 clock = ~clock;
    
    
    initial
    begin
        clock <=0;
        uvm_top.set_report_verbosity_level(UVM_HIGH);
        uvm_config_db#(virtual axi_interface)::set(null ,"*", "axi_interface", axi_intf);
        run_test("axi_test_read");
    end


    
endmodule: axi_top_read
