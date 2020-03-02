//  Class: axi_master_configuration
//
class axi_master_configuration extends uvm_object;
    
    virtual axi_interface axi_conf_vif;

    uvm_active_passive_enum is_active = UVM_ACTIVE;
    uvm_active_passive_enum is_passive = UVM_PASSIVE;

    `uvm_object_utils(axi_master_configuration)

    function new(string name = "axi_master_configuration");
        super.new(name);
    endfunction: new    

endclass: axi_master_configuration
