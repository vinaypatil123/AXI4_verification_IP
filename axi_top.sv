//  Module: axi_top
//
`include "uvm_macros.svh"
import uvm_pkg::*;

module axi_top();

    bit clock;

    initial begin
        #20;
        forever #10 clock = ~clock;
    end
    
    axi_interface axi_intf(clock);

    
endmodule: axi_top
