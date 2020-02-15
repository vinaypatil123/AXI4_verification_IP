//  Class: axi_test
//
class axi_test extends uvm_test;
    
    axi_environment axi_env;
    axi_sequence axi_test_seq;

    `uvm_component_utils(axi_test)
    
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

        //`uvm_field_object (axi_env,      UVM_DEFAULT)
        //`uvm_field_object (axi_test_seq, UVM_DEFAULT)
    //`uvm_component_utils_end
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        axi_env = axi_environment::type_id::create("axi_env", this);

    endfunction: build_phase

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
            axi_test_seq = axi_sequence::type_id::create("axi_test_seq", this);
            assert(axi_test_seq.randomize());
            `uvm_info(get_type_name(), "Randomized \n", UVM_MEDIUM)            
            axi_test_seq.start(axi_env.axi_m_agt.axi_m_sqr);
            #10;
        phase.drop_objection(this);
    endtask: run_phase
    
    function void end_of_elaboration();
        print();
        
    endfunction: end_of_elaboration
    

endclass: axi_test
