//  Class: axi_environment
//
class axi_environment extends uvm_env;
    /*  PROPERTIES  */
    axi_master_agent axi_m_agt;

    `uvm_component_utils(axi_environment)    
    

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        axi_m_agt = axi_master_agent::type_id::create("axi_m_agent", this);

    endfunction: build_phase    

endclass: axi_environment
