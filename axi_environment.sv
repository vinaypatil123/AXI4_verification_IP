//  Class: axi_environment
//
class axi_environment extends uvm_env;
    /*  PROPERTIES  */
    `uvm_component_utils(axi_environment)    

    function new(string name = "axi_environment", uvm_component parent = null);
        super.new(name,parent);
    endfunction: new

    axi_master_agent axi_m_agt;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        axi_m_agt = axi_master_agent::type_id::create("axi_m_agent", this);

    endfunction: build_phase 
    
    virtual function void connect_phase(uvm_phase phase);
        
    endfunction: connect_phase    

endclass: axi_environment
