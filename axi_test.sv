//  Class: axi_test
//
class axi_test extends uvm_test;
    `uvm_component_utils (axi_test)

    uvm_objection objection;
    uvm_object object_list[$];

    function new(string name = "axi_test", uvm_component parent = null);
        super.new(name,parent);
    endfunction: new

    axi_environment axi_env;
    axi_sequence axi_test_seq;
    virtual axi_interface axi_vif;

        //`uvm_field_object (axi_env,      UVM_DEFAULT)
        //`uvm_field_object (axi_test_seq, UVM_DEFAULT)
    //`uvm_component_utils_end
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        axi_env = axi_environment::type_id::create("axi_env", this);

        axi_test_seq = axi_sequence::type_id::create("axi_test_seq", this);
        if(!uvm_config_db#(virtual axi_interface)::get(this, "", "axi_interface", axi_vif))
        begin
            `uvm_fatal("TEST", "Did not get virtual interface")
        end
        uvm_config_db#(virtual axi_interface)::set(this, "axi_env.axi_m_agt.*", "axi_interface", axi_vif);
           
        //axi_test_seq.randomize();

    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        axi_sequence axi_test_seq = axi_sequence::type_id::create("axi_test_seq");
        phase.raise_objection(this);
            //axi_test_seq.randomize();
            fork            
                axi_test_seq.start(axi_env.axi_m_agt.axi_m_sqr);
            join_none
            #1000;
            objection = phase.get_objection();
            objection.get_objectors(object_list);
            foreach(object_list[i])
                begin
                    objection.display_objections(object_list[i]);
                end
        phase.drop_objection(this);
    endtask: run_phase
    
    virtual function void end_of_elaboration();
        print();
        
    endfunction: end_of_elaboration
    

endclass: axi_test
