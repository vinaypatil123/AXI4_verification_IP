//  Module: axi_top
//
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "axi_interface.sv"
`include "axi_master_sequence_item.sv"
`include "axi_master_configuration.sv"
`include "axi_master_sequencer.sv"
`include "axi_master_sequence.sv"
`include "axi_master_driver.sv"
`include "axi_slave_driver.sv"
`include "axi_master_monitor.sv"
`include "axi_master_agent.sv"
`include "axi_slave_agent.sv"
`include "axi_environment.sv"
`include "axi_test.sv"

module axi_top;

    bit clock;
    bit reset;
    axi_interface axi_intf(clock, reset);

    
    always #1 clock = ~clock;
    
    
    initial
    begin
        clock <=0;
        uvm_top.set_report_verbosity_level(UVM_HIGH);

        uvm_config_db#(virtual axi_interface)::set(null ,"*", "axi_interface", axi_intf);
        
        run_test("axi_test");
    end


    
endmodule: axi_top
