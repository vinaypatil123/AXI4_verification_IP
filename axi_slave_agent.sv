//  Class: axi_master_agent
//
class axi_slave_agent extends uvm_agent;
    `uvm_component_utils(axi_slave_agent)    
    
    virtual axi_interface axi_agent_vif;

    //uvm_sequencer #(axi_sequence_item) axi_s_sqr;
    axi_sequencer axi_s_sqr;
    axi_slave_driver axi_s_drv;
    axi_master_monitor axi_m_mon;
    axi_master_configuration axi_s_config;


    function new(string name = "axi_slave_agent", uvm_component parent = null);
        super.new(name,parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        axi_s_config    = axi_master_configuration::type_id::create("axi_s_config", this);
        axi_m_mon       = axi_master_monitor::type_id::create("axi_m_mon", this);

        if(axi_s_config.is_active == UVM_ACTIVE)
        begin
            axi_s_sqr   = axi_sequencer::type_id::create("axi_s_sqr", this);
            axi_s_drv   = axi_slave_driver::type_id::create("axi_s_drv", this);            
        end
        
    endfunction: build_phase
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(axi_s_config.is_active == UVM_ACTIVE)
        begin
            axi_s_drv.seq_item_port.connect(axi_s_sqr.seq_item_export);
        end        
    endfunction: connect_phase
    
    

endclass: axi_slave_agent