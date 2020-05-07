class axi_sequencer_read extends uvm_sequencer #(axi_sequence_item_read);
    /*  PROPERTIES  */

    `uvm_sequencer_utils(axi_sequencer_read)

    function new(string name = "axi_sequencer_read", uvm_component parent = null);
        super.new(name,parent);
    endfunction: new  
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);        
    endfunction: build_phase

    
    
    

endclass: axi_sequencer_read