//  Class: axi_slave_driver
//
class axi_slave_driver extends uvm_driver #(axi_sequence_item);

    /*  PROPERTIES  */
    virtual axi_interface axi_vif;

    axi_sequence_item axi_seq_item_resp;

    function new(string name = "axi_slave_driver");
    endfunction: new


    

endclass: axi_slave_driver
