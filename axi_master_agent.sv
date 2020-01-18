//  Class: axi_master_agent
//
class axi_master_agent extends uvm_agent;
    
    virtual axi_interface axi_agent_vif;

    axi_sequencer axi_m_sqr;
    axi_driver axi_m_drv;
    axi_monitor axi_m_mon;
    axi_master_configuration axi_m_config;

    function new(string name = "axi_master_agent");
        super.new(name);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.new(phase);

        axi_m_mon = axi_master_monitor::type_id::create("axi_m_mon", this);
        if(axi_m_config.active == UVM_ACTIVE)
        begin
            axi_m_sqr = axi_sequencer::type_id::create("axi_m_sqr", this);
            axi_m_drv = axi_driver::type_id::create("axi_m_drv", this);
        end
      
        
        
    endfunction: name
    

    

endclass: axi_master_agent
