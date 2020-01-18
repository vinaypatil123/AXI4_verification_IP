//  Class: axi_sequencer
//
`include "uvm_macros.svh"
import uvm_pkg::*;

class axi_sequencer extends uvm_sequencer #(axi_sequence_item);
    /*  PROPERTIES  */
    `uvm_object_utils(axi_sequencer)
    

    function new(string name = "axi_sequencer", uvm_component parent = null);
        super.new(name,parent);
    endfunction: new    

endclass: axi_sequencer
