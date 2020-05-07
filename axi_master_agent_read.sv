//  Class: axi_master_agent
//
class axi_master_agent_read extends uvm_agent;
    `uvm_component_utils(axi_master_agent_read)    
    
    virtual axi_interface axi_agent_vif;

    uvm_sequencer #(axi_sequence_item_read) axi_m_sqr;
    axi_master_driver_read axi_m_drv;
    //axi_master_monitor axi_m_mon;
    axi_master_configuration axi_m_config;


    function new(string name = "axi_master_agent_read", uvm_component parent = null);
        super.new(name,parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        axi_m_config = axi_master_configuration::type_id::create("axi_m_config", this);
        //axi_m_mon = axi_master_monitor::type_id::create("axi_m_mon", this);

        if(axi_m_config.is_active == UVM_ACTIVE)
        begin
            axi_m_sqr = axi_sequencer_read::type_id::create("axi_m_sqr", this);
            axi_m_drv = axi_master_driver_read::type_id::create("axi_m_drv", this);
            
        end
        
    endfunction: build_phase
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(axi_m_config.is_active == UVM_ACTIVE)
        begin
            axi_m_drv.seq_item_port.connect(axi_m_sqr.seq_item_export);
        end
    endfunction: connect_phase
    


endclass: axi_master_agent_read
