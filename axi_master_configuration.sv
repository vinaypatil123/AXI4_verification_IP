//  Class: axi_master_configuration
//
class axi_master_configuration extends uvm_object;
    
    virtual axi_interface axi_conf_vif;

    uvm_active_passive_enum active = UVM_ACTIVE;

    `uvm_object_utils(axi_master_configuration)

    function new(string name = "axi_master_configuration");
        super.new(name);
    endfunction: new    

endclass: axi_master_configuration
