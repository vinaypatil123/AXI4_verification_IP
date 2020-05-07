//  Class: axi_environment
//
class axi_environment_read extends uvm_env;
    /*  PROPERTIES  */
    `uvm_component_utils(axi_environment_read)    

    function new(string name = "axi_environment_read", uvm_component parent = null);
        super.new(name,parent);
    endfunction: new

    axi_master_agent_read    axi_m_agt;
    axi_slave_agent_read     axi_s_agt;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        axi_m_agt = axi_master_agent_read::type_id::create("axi_m_agt", this);
        axi_s_agt = axi_slave_agent_read::type_id::create("axi_s_agt", this);

    endfunction: build_phase 
    
    virtual function void connect_phase(uvm_phase phase);
        
    endfunction: connect_phase    

endclass: axi_environment_read
