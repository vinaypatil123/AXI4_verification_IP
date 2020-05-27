//  Class: axi_monitor_read
//
class axi_monitor_read extends uvm_monitor;
    /*  PROPERTIES  */
    `uvm_component_utils(axi_monitor_read)

    virtual axi_interface axi_vif;

    uvm_analysis_port #(axi_sequence_item_read) item_collected_port;

    axi_sequence_item_read trans_collected;

    function new(string name = "axi_monitor", uvm_component parent);
        super.new(name,parent);
        item_collected_port =   new("item_collected_port",this);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        trans_collected = axi_sequence_item_read::type_id::create("trans_collected");

        if(!uvm_config_db#(virtual axi_interface)::get(this,"","axi_interface", axi_vif))
        begin
            `uvm_fatal(get_type_name(), "Didn't get handle to virtual interface")
        end
    endfunction: build_phase
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        item_collected_port.write(trans_collected);
    endtask: run_phase

endclass: axi_monitor_read
