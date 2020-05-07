//  Class: axi_sequence
//


class axi_sequence_read extends uvm_sequence #(axi_sequence_item_read);
    /*  PROPERTIES  */
    `uvm_object_utils(axi_sequence_read)
    
    
    function new(string name = "axi_sequence_read");
        super.new(name);
    endfunction: new
    axi_sequence_item_read axi_seq_item_read;

    /*constraint AW_LEN{
        axi_seq_item.AXI_AWBURST == 2    ->      axi_seq_item.AXI_AWSIZE inside {1, 3, 7, 15};
        axi_seq_item.AXI_AWBURST == 3    ->      axi_seq_item.AXI_AWSIZE inside {0};
    }*/
    //rand int num;

    //constraint c1 { num inside {[20:50]}; }
    virtual task body();
        forever begin
            //`uvm_do(axi_seq_item);
            axi_seq_item_read = axi_sequence_item_read::type_id::create("axi_seq_item_read");

            wait_for_grant();
            void'(axi_seq_item_read.randomize());
            send_request(axi_seq_item_read);
            wait_for_item_done();
            /*
            axi_sequence_item axi_seq_item = axi_sequence_item::type_id::create("axi_seq_item");
            start_item(axi_seq_item);
            void'(axi_seq_item.randomize());
                `uvm_info("SEQ", $sformatf("Generated Item :"), UVM_NONE)
            axi_seq_item.print();
            finish_item(axi_seq_item);
            `uvm_info("SEQ", $sformatf("Done Generation items"), UVM_NONE) */
        end
    endtask



endclass: axi_sequence_read
