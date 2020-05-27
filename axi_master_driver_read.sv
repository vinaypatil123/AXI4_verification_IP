//  Class: axi_driver
//

class axi_master_driver_read extends uvm_driver #(axi_sequence_item_read);
    /*  PROPERTIES  */
    `uvm_component_utils(axi_master_driver_read)

    virtual axi_interface axi_vif;
    //int master_wrt_q[$];
    axi_sequence_item_read master_wrt_q[$];
    
    axi_sequence_item_read axi_seq_item_req;
    axi_sequence_item_read axi_seq_item_req_data;

    int         index;
    int         data_recieved;
    rand int    data_current;
    int         strb_recieved;
    //axi_sequence_item axi_seq_item_req_data;
    //axi_sequence_item master_transfer;

    //int unsigned                master_wr_addr_indx = 0;
    //int unsigned                master_wr_data_indx = 0;


    function new(string name = "axi_driver_read", uvm_component parent = null);
        super.new(name,parent);
    endfunction: new  
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual axi_interface)::get(this,"","axi_interface", axi_vif))
        begin
            `uvm_fatal(get_type_name(), "Didn't get handle to virtual interface")
                
        end
       // axi_vif = axi_interface::type_id::create("axi_vif", this);
        
    endfunction: build_phase    

    extern virtual task run_phase(uvm_phase phase);
    //extern virtual task drive_item(axi_sequence_item axi_seq_item_req);
    //extern virtual task get_and_drive();
    //extern virtual task reset_signals();
    //extern virtual task send_wrt_addr();
    //extern virtual task send_wrt_data();
    extern virtual task master_read_addr();
    extern virtual task master_read_data();
    
    extern virtual task reset_signals();
    
    

endclass: axi_master_driver_read

task axi_master_driver_read::run_phase(uvm_phase phase);
    super.run_phase(phase);
    begin
        //@(posedge axi_vif.clock);
        seq_item_port.get_next_item(axi_seq_item_req);
        //get_and_drive();    
        
        `uvm_info(get_type_name(), $sformatf("Waiting for data from Slave"), UVM_NONE)
        //fork
        //master_read_addr();
        //@(posedge axi_vif.clock);
        master_read_data();

        //master_write_resp();
        //join
        
        //axi_seq_item_req.print();


        seq_item_port.item_done();    
    end
endtask : run_phase

task axi_master_driver_read::master_read_addr();
    begin
        //axi_seq_item_req = axi_sequence_item_read::type_id::create("axi_seq_item_req");

        axi_vif.ARID            <=  1'b0;
        axi_vif.ARADDR          <=  1'b0;
        axi_vif.ARLEN           <=  1'b0;
        axi_vif.ARSIZE          <=  1'b0;
        axi_vif.ARBURST         <=  1'b0;
        
        @(posedge axi_vif.clock);

            axi_vif.ARVALID         <=  1'b1;       
            axi_vif.ARID            <=  axi_seq_item_req.AXI_ARID;
            axi_vif.ARADDR          <=  axi_seq_item_req.AXI_ARADDR;
            axi_vif.ARLEN           <=  axi_seq_item_req.AXI_ARLEN;
            axi_vif.ARSIZE          <=  axi_seq_item_req.AXI_ARSIZE;
            axi_vif.ARBURST         <=  axi_seq_item_req.AXI_ARBURST;
            //axi_vif.AWREG           <=  axi_seq_item_req.AXI_AWREG;
            //axi_vif.AWLOCK          <=  axi_seq_item_req.AXI_AWLOCK;
            //axi_vif.AWCACHE         <=  axi_seq_item_req.AXI_AWCACHE;
            //axi_vif.AWPROT          <=  axi_seq_item_req.AXI_AWPROT;
            //axi_vif.AWQOS           <=  axi_seq_item_req.AXI_AWQOS;
            //axi_vif.WDATA           <=  axi_seq_item_req.AXI_WDATA;
            //axi_vif.WSTRB           <=  axi_seq_item_req.AXI_WSTRB;
            //axi_vif.WLAST           <=  1'b0;
            //axi_vif.WVALID          <=  1'b0;
            //axi_vif.BID             <=  axi_seq_item_req.AXI_BID;
            //axi_vif.BRESP           <=  axi_seq_item_req.AXI_BRESP;
        
        //$display("\t Address = %0h", axi_vif.ARADDR);
        //@(posedge axi_vif.clock);
        
        wait(axi_vif.ARREADY == 1'b1)
        @(posedge axi_vif.clock);
        wait(axi_vif.ARREADY == 1'b0)
        axi_vif.ARVALID         <=  1'b0;
        
        //data not available after valid asserted to 0
        axi_vif.ARADDR          <=  1'b0;
        axi_vif.ARLEN           <=  1'b0;
        axi_vif.ARSIZE          <=  1'b0;
        axi_vif.ARBURST         <=  1'b0;

        //@(posedge axi_vif.clock);

        //master_read_data();

        //@(posedge axi_vif.clock);
    end
endtask: master_read_addr

task axi_master_driver_read::master_read_data();
    begin
        int unsigned    i;
        int             data_from_slave;
        //axi_seq_item_req = axi_sequence_item::type_id::create("axi_seq_item_req");
            
        //@(posedge axi_vif.clock);
        //axi_seq_item_req = axi_sequence_item_read::type_id::create("axi_seq_item_req");

        //data_current            =       $urandom(axi_seq_item_req_data.AXI_WDATA);
        for(i = 0; i < axi_vif.AXI_ARLEN; i++) begin
            axi_vif.RREADY          <=      1'b1;
            @(posedge axi_vif.clock);
            wait(axi_vif.RVALID == 1'b1)
            @(posedge axi_vif.clock);
            data_from_slave         =      axi_vif.RDATA;//data_current;
            //axi_vif.RSTRB           <=      axi_seq_item_req.AXI_RSTRB;
            //axi_vif.RLAST           <=      (i == axi_seq_item_req.AXI_ARLEN - 1)? 1'b1 : 1'b0;

            //@(negedge axi_vif.clock);
            $display("\t\tData at Master = %0h", data_from_slave);
            axi_vif.RREADY          <=      1'b0;
        end
    end
endtask: master_read_data


/*
task axi_master_driver::drive_item(axi_sequence_item axi_seq_item_req);
    begin
        fork
            //get_and_drive();
            
            //reset_signals();
            
            send_wrt_addr();
            
            //send_wrt_data();
        join
    end
endtask: drive_item


task axi_master_driver::get_and_drive();
    //forever begin
      // @(posedge axi_vif.reset);
       //`uvm_info(get_type_name, "waiting for reset", UVM_NONE)       
    //end 
    forever begin
        @(posedge axi_vif.clock);
        seq_item_port.get_next_item(axi_seq_item_req);
            `uvm_info(get_type_name, "Driving to DUT", UVM_NONE)
            master_wrt_q.push_back(axi_seq_item_req);
            //axi_seq_item_req.print();
            `uvm_info(get_type_name, "Item Sent to DUT", UVM_NONE)
        seq_item_port.item_done();
    end
endtask: get_and_drive */

task axi_master_driver_read::reset_signals();
    forever begin 
        @(posedge axi_vif.clock);
        `uvm_info(get_type_name(), "Reset Started", UVM_NONE)
        axi_vif.AWID            <=  0;
        axi_vif.ARADDR          <=  0;
        axi_vif.ARLEN           <=  0;
        axi_vif.ARSIZE          <=  0;
        axi_vif.ARBURST         <=  0;
        axi_vif.AWREG           <=  0;
        axi_vif.AWLOCK          <=  0;
        axi_vif.AWCACHE         <=  0;
        axi_vif.AWPROT          <=  0;
        axi_vif.AWQOS           <=  0;
        `uvm_info(get_type_name(), "Reset Done", UVM_NONE)
        
    end
endtask: reset_signals
/*
task axi_master_driver::send_wrt_addr();
    repeat(100) begin
        //repeat(master_wrt_q.size()==0)
        @(posedge axi_vif.clock);
            axi_vif.AWVALID         <=  1'b1;
            axi_vif.AWID            <=  axi_seq_item_req.AXI_AWID;
            axi_vif.ARADDR          <=  axi_seq_item_req.AXI_ARADDR;
            axi_vif.ARLEN           <=  axi_seq_item_req.AXI_ARLEN;
            axi_vif.ARSIZE          <=  axi_seq_item_req.AXI_ARSIZE;
            axi_vif.ARSBURST         <=  axi_seq_item_req.AXI_ARSBURST;
            axi_vif.AWREG           <=  axi_seq_item_req.AXI_AWREG;
            axi_vif.AWLOCK          <=  axi_seq_item_req.AXI_AWLOCK;
            axi_vif.AWCACHE         <=  axi_seq_item_req.AXI_AWCACHE;
            axi_vif.AWPROT          <=  axi_seq_item_req.AXI_AWPROT;
            axi_vif.AWQOS           <=  axi_seq_item_req.AXI_AWQOS;

        @(posedge axi_vif.clock);

        while(!axi_vif.AWREADY) 
        @(posedge axi_vif.clock);
            axi_vif.AWVALID         <=  1'b0;

    end.
endtask: send_wrt_addr

task axi_master_driver::send_wrt_data();
    int unsigned i;
    axi_sequence_item axi_seq_item_req;
    forever begin
        repeat(100)
        begin
            @(posedge axi_vif.clock)
            while(i<= axi_seq_item_req.AXI_ARLEN)
                axi_vif.WVALID          <= 1'b1;
                axi_vif.WDATA           <=  axi_seq_item_req.AXI_WDATA;
                axi_vif.WSTRB           <=  axi_seq_item_req.AXI_WSTRB;
                axi_vif.WID             <=  axi_seq_item_req.AXI_WID;
                axi_vif.WLAST           <=  (i==axi_seq_item_req.AXI_ARLEN)? 1'b1 : 1'b0;

            @(posedge axi_vif.clock)
            if(axi_vif.WREADY && axi_vif.WVALID)
                i = i + 1;
            
            @(posedge axi_vif.clock)
                axi_vif.WREADY = 1'b0;
                axi_vif.WVALID = 1'b0;
                i = 0;
        end
    end
endtask: send_wrt_data
*/