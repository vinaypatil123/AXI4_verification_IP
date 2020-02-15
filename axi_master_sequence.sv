//  Class: axi_sequence
//


class axi_sequence extends uvm_sequence #(axi_sequence_item);
    /*  PROPERTIES  */
    `uvm_object_utils(axi_sequence)
    
    function new(string name = "axi_sequence");
        super.new(name);
    endfunction: new

    task body();
        axi_sequence_item axi_seq_item;

        forever begin
            axi_seq_item = axi_sequence_item::type_id::create("axi_seq_item");
            start_item(axi_seq_item);
            if(!axi_seq_item.randomize())
            begin
                `uvm_error("body", "axi_seq_item randomization failure")                
            end
            finish_item(axi_seq_item);
        end

    endtask
    

endclass: axi_sequence
