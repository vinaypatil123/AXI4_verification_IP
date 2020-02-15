//  Class: axi_master_monitor
//
class axi_master_monitor extends uvm_monitor;

    virtual axi_interface axi_vif;

    longint monitor_cycle   =   0;

    `uvm_component_utils(axi_master_monitor)    

    uvm_analysis_port #(axi_sequence_item) item_collected_port;

    function new(string name = "axi_master_monitor", uvm_component parent = null);
        super.new(name,parent);

        item_collected_port = new("item_collected_port", this);
    endfunction: new

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        if(!uvm_config_db#(virtual axi_interface)::get(null, "*", "axi_vif", axi_vif))
            `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),"axi_vif"})

    endfunction: connect_phase

    task run_phase(uvm_phase phase);
        fork

        join        
    endtask: run_phase
    
    

endclass: axi_master_monitor
