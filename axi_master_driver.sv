//  Class: axi_driver
//

class axi_master_driver extends uvm_driver #(axi_sequence_item);
    /*  PROPERTIES  */
    `uvm_component_utils(axi_master_driver)

    virtual axi_interface axi_vif;
    //int master_wrt_q[$];
    axi_sequence_item master_wrt_q[$];
    
    axi_sequence_item axi_seq_item_req;
    axi_sequence_item axi_seq_item_req_data;

    int         index;
    int         data_recieved;
    rand int    data_current;
    int         strb_recieved;

    semaphore sema_addr = new(1);
    semaphore sema_data = new(1);
    semaphore sema_resp = new(1);
    //axi_sequence_item axi_seq_item_req_data;
    //axi_sequence_item master_transfer;

    //int unsigned                master_wr_addr_indx = 0;
    //int unsigned                master_wr_data_indx = 0;


    function new(string name = "axi_master_driver", uvm_component parent = null);
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
    extern virtual task master_write();
    extern virtual task master_write_addr();
    extern virtual task master_write_data();
    extern virtual task master_write_resp();
    extern virtual task reset_signals();
    
    

endclass: axi_master_driver

task axi_master_driver::run_phase(uvm_phase phase);
    super.run_phase(phase);
    repeat(5) 
    begin
        //@(posedge axi_vif.clock);
        seq_item_port.get_next_item(axi_seq_item_req);        
        `uvm_info(get_type_name(), $sformatf("Waiting for data from sequencer"), UVM_NONE)
            master_write();
        seq_item_port.item_done();    
    end
endtask : run_phase

task axi_master_driver::master_write();
    //axi_seq_item_req.print();

    //fork
      //  begin
        //    sema_addr.get(1);
                //master_write_addr();
          //  sema_addr.put(1);
        //end

        //begin
          //  sema_data.get(1);
                master_write_data();
            //sema_data.put(1);
        //end

        //begin
            //sema_resp.get(3);
                //master_write_resp();
            //sema_resp.put(1);
        //end
    //join
endtask: master_write


task axi_master_driver::master_write_addr();
    begin
        //axi_seq_item_req = axi_sequence_item::type_id::create("axi_seq_item_req");

        axi_vif.AWADDR          <=  1'b0;
        axi_vif.AWLEN           <=  1'b0;
        axi_vif.AWSIZE          <=  1'b0;
        axi_vif.AWBURST         <=  1'b0;
        
       /* @(posedge axi_vif.clock); 
        begin
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
            axi_vif.WDATA           <=  0;
            axi_vif.WSTRB           <=  0;
            axi_vif.WLAST           <=  0;
            axi_vif.BID             <=  0;
            axi_vif.BRESP           <=  0;
        end*/
        @(posedge axi_vif.clock); 
            axi_vif.AWVALID         <=  1'b1;       
        //axi_vif.AWID            <=  axi_seq_item_req.AXI_AWID;
            axi_vif.AWADDR          <=  axi_seq_item_req.AXI_AWADDR;
            axi_vif.AWLEN           <=  axi_seq_item_req.AXI_AWLEN;
            axi_vif.AWSIZE          <=  axi_seq_item_req.AXI_AWSIZE;
            axi_vif.AWBURST         <=  axi_seq_item_req.AXI_AWBURST;
            //begin
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
            //end
        
        //$display("\t Address = %0h", axi_vif.AWADDR);
        //@(posedge axi_vif.clock);
        
        wait(axi_vif.AWREADY == 1'b1)
        @(posedge axi_vif.clock);
        wait(axi_vif.AWREADY == 1'b0)
        axi_vif.AWVALID         <=  1'b0;
        
        //data not available after valid asserted to 0
        axi_vif.AWADDR          <=  1'b0;
        axi_vif.AWLEN           <=  1'b0;
        axi_vif.AWSIZE          <=  1'b0;
        axi_vif.AWBURST         <=  1'b0;

        //@(posedge axi_vif.clock);

        //master_write_data();

        //@(posedge axi_vif.clock);
    end
endtask: master_write_addr

task axi_master_driver::master_write_data();
    begin
        int         i;
        //axi_seq_item_req = axi_sequence_item::type_id::create("axi_seq_item_req");
            
        //axi_vif.WLAST           <=      1'b0;
        //axi_vif.WDATA           <=      1'b0;
        //axi_vif.WSTRB           <=      1'b0;
        //$display("Data at Master = %0h", axi_seq_item_req.AXI_WDATA);
        $display("Burst Len = %0t", axi_seq_item_req.AXI_AWLEN);
        //@(posedge axi_vif.clock);
        //seq_item_port.get_next_item(axi_seq_item_req);
        //begin

        for(i = 0; i < axi_seq_item_req.AXI_AWLEN; i++) begin
            //seq_item_port.get_next_item(axi_seq_item_req);
            begin
                //axi_seq_item_req = axi_sequence_item::type_id::create("axi_seq_item_req");

                //data_current            =       $urandom(axi_seq_item_req_data.AXI_WDATA);
                axi_vif.WVALID          <=      1'b1;
                axi_vif.WDATA           <=      axi_seq_item_req.mem_data[i];//data_current;
                axi_vif.WSTRB           <=      axi_seq_item_req.AXI_WSTRB;
                axi_vif.WLAST           <=      (i == axi_seq_item_req.AXI_AWLEN - 1)? 1'b1 : 1'b0;

                //@(posedge axi_vif.clock);
                $display("\t\tData at Master %0d = %0h", i, axi_seq_item_req.mem_data[i]);
                
                wait(axi_vif.WREADY ==  1'b1);
                @(posedge axi_vif.clock);
                wait(axi_vif.WREADY ==  1'b0);
                axi_vif.WVALID          <=      1'b0;

                axi_vif.WDATA           <=      1'b0;
                axi_vif.WSTRB           <=      1'b0;
                @(posedge axi_vif.clock);
                //i = i + 1;
            end
            //seq_item_port.item_done();
        end
        
    end
endtask: master_write_data

task axi_master_driver::master_write_resp();
    forever begin
        
        //wait(axi_vif.AWVALID == 1'b1)
        //@(posedge axi_vif.clock);
        axi_vif.BREADY          <=  1'b1;
        wait(axi_vif.BVALID == 1'b1)
        @(posedge axi_vif.clock);
        axi_vif.BREADY          <=  1'b0;        
    end    
endtask: master_write_resp


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

task axi_master_driver::reset_signals();
    forever begin 
        @(posedge axi_vif.clock);
        `uvm_info(get_type_name(), "Reset Started", UVM_NONE)
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

task axi_master_driver::send_wrt_data();
    int unsigned i;
    axi_sequence_item axi_seq_item_req;
    forever begin
        repeat(100)
        begin
            @(posedge axi_vif.clock)
            while(i<= axi_seq_item_req.AXI_AWLEN)
                axi_vif.WVALID          <= 1'b1;
                axi_vif.WDATA           <=  axi_seq_item_req.AXI_WDATA;
                axi_vif.WSTRB           <=  axi_seq_item_req.AXI_WSTRB;
                axi_vif.WID             <=  axi_seq_item_req.AXI_WID;
                axi_vif.WLAST           <=  (i==axi_seq_item_req.AXI_AWLEN)? 1'b1 : 1'b0;

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