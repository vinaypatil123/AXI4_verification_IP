//  Module: axi_top
//
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "axi_interface.sv"
`include "axi_master_configuration.sv"
`include "axi_master_sequence_item.sv"
`include "axi_master_sequencer.sv"
`include "axi_master_sequence.sv"
`include "axi_master_driver.sv"
`include "axi_master_monitor.sv"
`include "axi_master_agent.sv"
`include "axi_environment.sv"
`include "axi_test.sv"

module axi_top;

    bit clock;
    axi_interface axi_intf(clock);
    

    initial begin
        forever #10 clock = ~clock;
    end
    
    initial
    begin
        uvm_config_db#(virtual axi_interface)::set(null ,"*", "axi_vif", axi_intf);
        run_test("axi_test");
    end


    
endmodule: axi_top
