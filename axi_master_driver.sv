//  Class: axi_driver
//

class axi_driver extends uvm_driver #(axi_sequence_item);
    /*  PROPERTIES  */

    virtual axi_interface axi_vif;
    int master_wrt_q[$];
    axi_sequence_item axi_seq_item_req;
    //axi_sequence_item master_transfer;

    int unsigned                master_wr_addr_indx = 0;
    int unsigned                master_wr_data_indx = 0;

    `uvm_component_utils(axi_driver)

    function new(string name = "axi_driver", uvm_component parent = null);
        super.new(name,parent);
    endfunction: new    

    task run_phase(uvm_phase phase);/*
        
        //repeat(50)
        fork
            begin
                @(posedge axi_vif.clk);
                seq_item_port.get_next_item(axi_seq_item_req);
                //drive_transfer(axi_seq_item_req);
                    `uvm_info(get_type_name(), "Driving", UVM_HIGH)
                    master_wrt_q.push_back(axi_seq_item_req);
                    `uvm_info(get_type_name(), "Item driven", UVM_HIGH)                
                seq_item_port.item_done;
            end
            begin
                //@(posedge axi_vif.clk);
                axi_vif.AWID            <=  0;
                axi_vif.AWADDR          <=  0;
                axi_vif.AXI_AWLEN       <=  0;
                axi_vif.AXI_AWSIZE      <=  0;
                axi_vif.AXI_AWBURST     <=  0;
            end  
            
                //repeat(1)//master_wrt_q.size()==0)
                begin
                    //master_transfer = master_wrt_q[master_wr_addr_indx];
                    @(posedge axi_vif.clk);
                    #5;
                    axi_vif.AWVALID     <=      1'b1;
                    axi_vif.AWID        <=      axi_seq_item_req.AXI_AWID;
                    axi_vif.AWADDR      <=      axi_seq_item_req.AXI_AWADDR;
                    axi_vif.AWLEN       <=      axi_seq_item_req.AXI_AWLEN;
                    axi_vif.AWSIZE      <=      axi_seq_item_req.AXI_AWSIZE;
                    axi_vif.AWBURST     <=      axi_seq_item_req.AXI_AWBURST;    

                    @(posedge axi_vif.clk);

                    while(!axi_vif.AWREADY)
                    @(posedge axi_vif.clk);
                    #5;
                    axi_vif.AWVALID     <=      1'b0;
                end
            

             forever begin
                #5;
                axi_vif.BREADY      <=      1'b0;
                repeat($urandom_range(4,8))
                #5;
                @(posedge axi_vif.clk);
                axi_vif.BREADY      <=      1'b1;

                @(posedge axi_vif.clk);
                while(!axi_vif.BVALID)
                @(posedge axi_vif.clk);

            end 
     
        
    */endtask: run_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if(!uvm_config_db#(virtual axi_interface)::get(null, "*", "axi_vif", axi_vif))
            `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".axi_vif"})
        
    endfunction: connect_phase
    
    

endclass: axi_driver
