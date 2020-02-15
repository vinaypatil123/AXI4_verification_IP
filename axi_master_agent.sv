//  Class: axi_master_agent
//
class axi_master_agent extends uvm_agent;
    
    virtual axi_interface axi_agent_vif;

    axi_sequencer axi_m_sqr;
    axi_driver axi_m_drv;
    axi_master_monitor axi_m_mon;
    axi_master_configuration axi_m_config;

    `uvm_component_utils(axi_master_agent)    

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        axi_m_config = axi_master_configuration::type_id::create("axi_m_config", this);
        axi_m_mon = axi_master_monitor::type_id::create("axi_m_mon", this);

        if(axi_m_config.active == UVM_ACTIVE)
        begin
            axi_m_sqr = axi_sequencer::type_id::create("axi_m_sqr", this);
            axi_m_drv = axi_driver::type_id::create("axi_m_drv", this);
        end
        
    endfunction: build_phase
    
    function void connect_phase(uvm_phase phase);
        if(axi_m_config.active == UVM_ACTIVE)
        begin
            axi_m_drv.seq_item_port.connect(axi_m_sqr.seq_item_export);

        end        
    endfunction: connect_phase
    
    

endclass: axi_master_agent
