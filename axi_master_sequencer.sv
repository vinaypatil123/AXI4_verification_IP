//  Class: axi_sequencer
//


class axi_sequencer extends uvm_sequencer #(axi_sequence_item);
    /*  PROPERTIES  */

    `uvm_sequencer_utils(axi_sequencer)

    function new(string name = "axi_sequencer", uvm_component parent = null);
        super.new(name,parent);
    endfunction: new  
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);        
    endfunction: build_phase

    
    
    

endclass: axi_sequencer
