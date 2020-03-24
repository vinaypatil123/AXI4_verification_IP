//  Class: axi_driver
//

class axi_driver extends uvm_driver #(axi_sequence_item);
    /*  PROPERTIES  */

    virtual axi_interface axi_vif;
    //int master_wrt_q[$];
    axi_sequence_item master_wrt_q[$];
    
    axi_sequence_item axi_seq_item_req;
    //axi_sequence_item master_transfer;

    //int unsigned                master_wr_addr_indx = 0;
    //int unsigned                master_wr_data_indx = 0;

    `uvm_component_utils(axi_driver)

    function new(string name = "axi_driver", uvm_component parent = null);
        super.new(name,parent);
    endfunction: new  
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

       // axi_vif = axi_interface::type_id::create("axi_vif", this);
        
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase); 
        
        if(!uvm_config_db#(virtual axi_interface)::get(null, "*", "axi_vif", axi_vif))
            `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".axi_vif"})
    endfunction: connect_phase
    

    extern virtual task run_phase(uvm_phase phase);

    extern virtual task get_and_drive();
    extern virtual task reset_signals();
    extern virtual task send_wrt_addr();
    extern virtual task send_wrt_data();
    extern virtual task receive_wrt_rsp();
    
    

endclass: axi_driver

task axi_driver::run_phase(uvm_phase phase);
    repeat(50)
    //fork
        get_and_drive();
        /*begin
            @(posedge axi_vif.clk);
            seq_item_port.get_next_item(axi_seq_item_req);
            //drive_transfer(axi_seq_item_req);
                `uvm_info(get_type_name(), "Driving", UVM_HIGH)
                master_wrt_q.push_back(axi_seq_item_req);
                `uvm_info(get_type_name(), "Item driven", UVM_HIGH)                
            seq_item_port.item_done;
        end*/
       // reset_signals();
        /*begin
            //@(posedge axi_vif.clk);
            axi_vif.AWID            <=  0;
            axi_vif.AWADDR          <=  0;
            axi_vif.AXI_AWLEN       <=  0;
            axi_vif.AXI_AWSIZE      <=  0;
            axi_vif.AXI_AWBURST     <=  0;
        end */ 
        //send_wrt_addr();
        /*begin
            #5;
            axi_vif.BREADY      <=      1'b0;
            repeat($urandom_range(4,8))
            #5;
            @(posedge axi_vif.clk);
            axi_vif.BREADY      <=      1'b1;

            @(posedge axi_vif.clk);
            while(!axi_vif.BVALID)
            @(posedge axi_vif.clk);

        end */
        //send_wrt_data();
        receive_wrt_rsp();
    //join
endtask : run_phase

task axi_driver::get_and_drive();
    forever begin
       @(posedge axi_vif.reset);
       `uvm_info(get_type_name, "waiting for reset", UVM_MEDIUM)       
    end
    forever begin
        @(posedge axi_vif.clock);
        seq_item_port.get_next_item(axi_seq_item_req);
            `uvm_info(get_type_name, "Driving to DUT", UVM_HIGH)
            send_wrt_addr;
            //send_wrt_data;
            master_wrt_q.push_back(axi_seq_item_req);

            `uvm_info(get_type_name, "Item Sent to DUT", UVM_HIGH)
            axi_seq_item_req.print();
        seq_item_port.item_done();
    end
endtask: get_and_drive

task axi_driver::reset_signals();
    forever begin 
        @(posedge axi_vif.reset);
        `uvm_info(get_type_name, "Reset done", UVM_MEDIUM)
        axi_vif.AWID            <=  0;
        axi_vif.AWADDR          <=  0;
        axi_vif.AWLEN           <=  0;
        axi_vif.AWSIZE          <=  0;
        axi_vif.AWBURST         <=  0;
        axi_vif.AWREG           <=  0;
        axi_vif.AWLOCK          <=  0;
        axi_vif.AWCACHE         <=  0;
        axi_vif.AWPROT          <=  0;
        axi_vif.AWQOS           <=  0;
    end
endtask: reset_signals

task axi_driver::send_wrt_addr();
    forever begin
        //repeat(master_wrt_q.size()==0)
        @(posedge axi_vif.clock);
            axi_vif.AWVALID         <=  1'b1;
            axi_vif.AWID            <=  axi_seq_item_req.AXI_AWID;
            axi_vif.AWADDR          <=  axi_seq_item_req.AXI_AWADDR;
            axi_vif.AWLEN           <=  axi_seq_item_req.AXI_AWLEN;
            axi_vif.AWSIZE          <=  axi_seq_item_req.AXI_AWSIZE;
            axi_vif.AWBURST         <=  axi_seq_item_req.AXI_AWBURST;
            axi_vif.AWREG           <=  axi_seq_item_req.AXI_AWREG;
            axi_vif.AWLOCK          <=  axi_seq_item_req.AXI_AWLOCK;
            axi_vif.AWCACHE         <=  axi_seq_item_req.AXI_AWCACHE;
            axi_vif.AWPROT          <=  axi_seq_item_req.AXI_AWPROT;
            axi_vif.AWQOS           <=  axi_seq_item_req.AXI_AWQOS;

        @(posedge axi_vif.clock);

        while(!axi_vif.AWREADY) 
        @(posedge axi_vif.clock);
            axi_vif.AWVALID         <=  1'b0;

    end
endtask: send_wrt_addr

task axi_driver::send_wrt_data();
    int unsigned i;
    axi_sequence_item axi_seq_item_req;
    forever begin
        repeat(10)
        begin
            @(posedge axi_vif.clock);
            while(i<= axi_seq_item_req.AXI_AWLEN)
                axi_vif.WVALID          <= 1'b1;
                axi_vif.WDATA           <=  axi_seq_item_req.AXI_WDATA;
                axi_vif.WSTRB           <=  axi_seq_item_req.AXI_WSTRB;
                axi_vif.WID             <=  axi_seq_item_req.AXI_WID;
                axi_vif.WLAST           <=  (i==axi_seq_item_req.AXI_AWLEN)? 1'b1 : 1'b0;

            @(posedge axi_vif.clock);
            if(axi_vif.WREADY && axi_vif.WVALID)
                i = i + 1;
            
            @(posedge axi_vif.clock);
                axi_vif.WREADY = 1'b0;
                axi_vif.WVALID = 1'b0;
                i = 0;
        end
    end
endtask: send_wrt_data

task axi_driver::receive_wrt_rsp();
    forever begin
        axi_vif.BREADY          <=  1'b0;
        @(posedge axi_vif.clock);
        repeat(8)
        axi_vif.BREADY          <=  1'b1;
        @(posedge axi_vif.clock);
        while(!axi_vif.BVALID)
        @(posedge axi_vif.clock);

    end
endtask: receive_wrt_rsp

