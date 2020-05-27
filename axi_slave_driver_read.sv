//  Class: axi_driver
//

class axi_slave_driver_read extends uvm_driver #(axi_sequence_item_read);
    /*  PROPERTIES  */
    `uvm_component_utils(axi_slave_driver_read)

    virtual axi_interface axi_vif;
    //int master_wrt_q[$];
    int         slave_rd_address_queue[$];
    int         slave_rd_data_queue[$];
    //int slave_wrt_strb_queue[$];
    
    axi_sequence_item_read axi_seq_item_rsp;

    int unsigned        start_address;
    int unsigned        burst_len;
    int unsigned        burst_length;
    int unsigned        burst_size;
    int unsigned        number_bytes;
    int unsigned        data_bus_bytes;
    int unsigned        burst_type;
    int unsigned        aligned_address;
    int unsigned        address_n;
    int unsigned        wrap_boundary;
    int unsigned        lower_byte_lane;
    int unsigned        upper_byte_lane;
    int unsigned        index;
    int unsigned        i;
    int unsigned        data_count;
    int unsigned        burst_address;
    int unsigned        data_recieved;
    int unsigned        strb_recieved;
    //int         slave_mem[int];

    //axi_sequence_item master_transfer;

    //int unsigned                master_wr_addr_indx = 0;
    //int unsigned                master_wr_data_indx = 0;


    function new(string name = "axi_slave_driver_read", uvm_component parent = null);
        super.new(name,parent);
    endfunction: new  
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual axi_interface)::get(this,"","axi_interface", axi_vif))
        begin
            `uvm_fatal(get_type_name(), "Didn't get handle to virtual interface")
                
        end
       //axi_vif = axi_interface::type_id::create("axi_vif", this);
        
    endfunction: build_phase    

    extern virtual task run_phase(uvm_phase phase);
    //extern virtual task drive_item(axi_sequence_item axi_seq_item_req);
    //extern virtual task get_and_drive();
    //extern virtual task reset_signals();
    //extern virtual task send_wrt_addr();
    //extern virtual task send_wrt_data();
    extern virtual task slave_read_address();
    extern virtual task slave_address();
    extern virtual task print_address_queue();
    extern virtual task slave_read_data(); 
    

endclass: axi_slave_driver_read

task axi_slave_driver_read::run_phase(uvm_phase phase);
    super.run_phase(phase);
    repeat(50) begin
        //seq_item_port.get_next_item(axi_seq_item_rsp);

        `uvm_info(get_type_name(), $sformatf("Slave Response"), UVM_NONE)
        //fork          
            //slave_read_address();

            slave_read_data();

            //slave_write_resp();
        //join
        //axi_seq_item_rsp.print();
        //seq_item_port.item_done();
    end
endtask : run_phase

task axi_slave_driver_read::slave_read_address();
    forever begin         
        wait(axi_vif.ARVALID == 1'b1)
        @(posedge axi_vif.clock);
        axi_vif.ARREADY         <=  1'b1;

        //@(posedge axi_vif.clock);
        
        start_address           =       axi_vif.ARADDR;
        burst_len               =       axi_vif.ARLEN;
        burst_size              =       axi_vif.ARSIZE;
        burst_type              =       axi_vif.ARBURST;
        
        $display("\t Address = %0h", start_address);
        $display("\t Burst Length = %0d", burst_len + 1'b1);  
        $display("\t Burst Size = %0d", burst_size);


        $display("\t Information Copied At Slave");
        //slave_read_address();
            
        slave_address();

        @(posedge axi_vif.clock);
        //wait(axi_vif.ARVALID == 1'b0)
        axi_vif.ARREADY         <=      1'b0;
        @(posedge axi_vif.clock);

        //print_address_queue();

        //@(posedge axi_vif.clock);
        //slave_write_data();
    end
endtask: slave_read_address

task axi_slave_driver_read::print_address_queue();
    begin
        for(index = 0; index <= burst_length - 1; index++)
        begin
            burst_address = slave_rd_address_queue.pop_front();
            $display("\n Address %0d = %0h", index, burst_address);
        end
    end
endtask: print_address_queue

task axi_slave_driver_read::slave_address();
    begin
        //start_address = axi_vif.ARADDR;
        number_bytes        = 2**(burst_size);
        burst_length        = burst_len + 1'b1;
        aligned_address     = $floor((start_address / number_bytes)) * number_bytes;
        wrap_boundary       = $floor((start_address / (number_bytes * burst_length))) * (number_bytes * burst_length);
        data_bus_bytes      = $size(axi_vif.RDATA) / 8;
        $display("\t number_bytes = %0d", number_bytes);
        $display("\t Aligned Address = %0h", aligned_address);
        $display("\t Wrap Boundary = %0h", wrap_boundary);

        case(burst_type)
            2'b00:  begin
                        $display("\n \t Fixed Burst Mode \n");
                        address_n   =   start_address;
                        ///$display("\t Fixed Address = %0h", address_n);
                        lower_byte_lane = start_address - ($floor(start_address / data_bus_bytes)) * data_bus_bytes;
                        upper_byte_lane = aligned_address + (number_bytes - 1) - ($floor(start_address / data_bus_bytes)) * data_bus_bytes;
                        $display("\t Fixed Address = %0h \t Lower Byte Lane = %0h \t Upper Byte Lane = %0h", address_n, lower_byte_lane, upper_byte_lane);
                        slave_rd_address_queue.push_back(address_n);
                        $display("Queue Printing");
                        $display("\n \tAddress = %0h", slave_rd_address_queue.pop_front());
                        //slave_write_data();                    
                    end
            2'b01:  begin
                        $display("\n \t Incremental Burst Mode \n");
                        for(index = 0; index <= burst_length - 1; index++)
                        begin
                            if(index == 0)
                            begin
                                address_n   =   start_address;
                                ///$display("\t Incremental Address start = %0h", address_n);
                                lower_byte_lane = start_address - ($floor(start_address / data_bus_bytes)) * data_bus_bytes;
                                upper_byte_lane = aligned_address + (number_bytes - 1) - ($floor(start_address / data_bus_bytes)) * data_bus_bytes;
                                $display("\t Incremental Address   = %0h \t Lower Byte Lane = %0h \t Upper Byte Lane = %0h", address_n, lower_byte_lane, upper_byte_lane);
                                slave_rd_address_queue.push_back(address_n);
                                //slave_write_data();
                            end
                            else begin
                                address_n = aligned_address + index * number_bytes;
                                //$display("\t Incremental Address %0d = %0h", index, address_n);
                                lower_byte_lane = address_n - ($floor(address_n / data_bus_bytes)) * data_bus_bytes;
                                upper_byte_lane = lower_byte_lane + number_bytes - 1;
                                $display("\t Incremental Address %0d = %0h \t Lower Byte Lane = %0h \t Upper Byte Lane = %0h", index, address_n, lower_byte_lane, upper_byte_lane);
                                slave_rd_address_queue.push_back(address_n);
                                //slave_write_data();
                            end
                        end
                        $display("Queue Printing");
                        $display("Queue Size", slave_rd_address_queue.size());
                        for(i = 0; i < index; i++)
                        begin
                           $display("\t Address %0d = %0h", i, slave_rd_address_queue.pop_front());
                        end
                    end
                
            2'b10:  begin
                        $display("\t Wrap Burst Mode \n");
                        for(index = 0; index <= burst_length - 1; index++)
                        begin
                            if(index == 0)
                            begin
                                if (address_n >= wrap_boundary + (number_bytes * burst_length))
                                begin
                                    address_n = wrap_boundary; //+ (address_n - wrap_boundary - (number_bytes * burst_length));
                                    $display("\t Wraping Around the Wrap Boundary");
                                    slave_rd_address_queue.push_back(address_n);
                                    //slave_write_data();
                                end
                                else begin
                                    address_n = start_address; //aligned_address + index * number_bytes;
                                    slave_rd_address_queue.push_back(address_n);
                                    //slave_write_data();
                                end
                                lower_byte_lane = start_address - ($floor(start_address / data_bus_bytes)) * data_bus_bytes;
                                upper_byte_lane = aligned_address + (number_bytes - 1) - ($floor(start_address / data_bus_bytes)) * data_bus_bytes;
                                $display("\t Wrap Address = %0h \t Lower Byte Lane = %0h \t Upper Byte Lane = %0h", address_n, lower_byte_lane, upper_byte_lane);
                                ///$display("\t Wrap Address start = %0h", address_n);
                            end
                            else begin                            
                                if (address_n < wrap_boundary + (number_bytes * burst_length))
                                begin
                                    if(address_n < start_address)
                                    begin
                                        address_n = start_address + (index * number_bytes) - (number_bytes * burst_length);
                                        slave_rd_address_queue.push_back(address_n);
                                        //slave_write_data();
                                    end
                                    else
                                    begin
                                        address_n = aligned_address + index * number_bytes;                                        
                                        slave_rd_address_queue.push_back(address_n);
                                        //slave_write_data();
                                    end
                                end
                                else begin
                                    address_n = wrap_boundary; //+ (address_n - wrap_boundary - (number_bytes * burst_length));
                                    $display("\t Wraping Around the Wrap Boundary");
                                    slave_rd_address_queue.push_back(address_n);
                                    //slave_write_data();
                                end
                                lower_byte_lane = address_n - ($floor(address_n / data_bus_bytes)) * data_bus_bytes;
                                upper_byte_lane = lower_byte_lane + number_bytes - 1;
                                $display("\t Wrap Address %0d = %0h \t Lower Byte Lane = %0h \t Upper Byte Lane = %0h", index, address_n, lower_byte_lane, upper_byte_lane);
                                ///$display("\t Wrap Address %0d = %0h", index, address_n);
                            end
                        end
                        $display("Queue Printing");
                        $display("Queue Size", slave_rd_address_queue.size());
                        for(i = 0; i < index; i++)
                        begin
                            $display("\t Address %0d = %0h", i, slave_rd_address_queue.pop_front());
                        end
                    end
            2'b11:  begin
                        $display("\n Reserved Burst Mode");
                    end
        endcase

    /*    for(index = 0; index <= burst_size ; index++)
        begin
            if (index == 0) 
            begin
                case (burst_type)
                    2'b00:      begin
                                    address_n = start_address;
                                    $display("\t Fixed Address start = %0h", address_n);
                                end
                    2'b01:      begin
                                    address_n = start_address;
                                    $display("\t Incremental Address start = %0h", address_n);
                                end
                    2'b10:      begin
                                    //address_n = start_address;
                                    if (address_n >= wrap_boundary + (number_bytes * burst_length))
                                    begin
                                        address_n = wrap_boundary; //+ (address_n - wrap_boundary - (number_bytes * burst_length));
                                        $display("\t Wraping Around the Wrap Boundary");
                                    end
                                    else begin
                                        address_n = start_address; //aligned_address + index * number_bytes;
                                    end
                                    $display("\t Wrap Address start = %0h", address_n);
                                end
                endcase
                //address_n = start_address;
                //$display("\t Address = %0h",    address_n);

                lower_byte_lane = aligned_address - (aligned_address / data_bus_bytes) * data_bus_bytes;
                upper_byte_lane = aligned_address + (number_bytes - 1) - ($floor(address_n / data_bus_bytes)) * data_bus_bytes;
                //index = index + 1;
            end
            else
            begin
                
                case (burst_type)

                    2'b00 :     begin
                                    //$display("\t Fixed Burst Mode \n");
                                    address_n = start_address; //aligned_address;
                                    $display("\t Fixed Address %0d = %0h \n", index, address_n);
                                end
                    2'b01 :     begin
                                    //$display("\t Incremental Burst Mode \n");
                                    //for(index = 1; index <= burst_size; index++)
                                    //begin
                                        address_n = aligned_address + index * number_bytes;
                                        $display("\t Incremental Address %0d = %0h", index, address_n);
                                    //end
                                end
                    2'b10 :     begin
                                    //$display("\t Wrap Burst Mode \n");
                                    //$display("\t Wrap Boundary = %0h", wrap_boundary);
                                    //$display("\t Address N = %0h", (wrap_boundary + (number_bytes * burst_length)));
                                    //for(index = 1; index <= burst_size; index++)
                                    begin    
                                        if (address_n >= wrap_boundary + (number_bytes * burst_length))
                                        begin
                                            if (address_n >= wrap_boundary + (number_bytes * burst_length))
                                            begin
                                                address_n = wrap_boundary; //+ (address_n - wrap_boundary - (number_bytes * burst_length));
                                            end
                                            else begin
                                                for(index = burst_size - index; index <= burst_size; index++)
                                                begin
                                                    address_n = start_address + (index * number_bytes) - (number_bytes * burst_length);
                                                end
                                            end
                                            $display("\t Wraping Around the Wrap Boundary");
                                        end
                                        else begin
                                            address_n = aligned_address + index * number_bytes;
                                        end
                                        $display("\t Wrap Address %0d = %0h", index, address_n);
                                    end
                                end
                    2'b11 :     begin
                                    $display("\t Reserved Burst Mode");    
                                end
                endcase
                lower_byte_lane = address_n - (address_n / data_bus_bytes) * data_bus_bytes;
                upper_byte_lane = lower_byte_lane + (number_bytes - 1);
            end
        end
        //return(lower_byte_lane); */
    end
endtask: slave_address

task axi_slave_driver_read::slave_read_data();
    forever begin
        int         i;
        //axi_seq_item_rsp = axi_sequence_item_read::type_id::create("axi_seq_item_rsp");
            
        //axi_vif.WLAST           <=      1'b0;
        //axi_vif.WDATA           <=      1'b0;
        //axi_vif.WSTRB           <=      1'b0;
        //$display("Data at Slave = %0h", axi_seq_item_rsp.AXI_RDATA);
        $display("Burst Len = %0t", axi_seq_item_rsp.AXI_ARLEN);
        //@(posedge axi_vif.clock);
        //seq_item_port.get_next_item(axi_seq_item_req);
        //begin
        axi_vif.ARLEN           <=          axi_seq_item_rsp.AXI_ARLEN;

        for(i = 0; i < axi_seq_item_rsp.AXI_ARLEN; i++) begin
            //seq_item_port.get_next_item(axi_seq_item_req);
            begin
                //axi_seq_item_req = axi_sequence_item::type_id::create("axi_seq_item_req");

                //data_current            =       $urandom(axi_seq_item_req_data.AXI_WDATA);
                axi_vif.RVALID          <=      1'b1;
                axi_vif.RDATA           <=      axi_seq_item_rsp.mem_data_read[i];//data_current;
                axi_vif.RLAST           <=      (i == axi_seq_item_rsp.AXI_ARLEN - 1)? 1'b1 : 1'b0;

                //@(posedge axi_vif.clock);
                $display("\t\tData %0d = %0h", i, axi_seq_item_rsp.mem_data_read[i]);
                
                wait(axi_vif.RREADY ==  1'b1);
                @(posedge axi_vif.clock);
                wait(axi_vif.RREADY ==  1'b0);
                axi_vif.RVALID          <=      1'b0;

                axi_vif.RDATA           <=      1'b0;
                @(posedge axi_vif.clock);
                //i = i + 1;
            end
            //seq_item_port.item_done();
        end
        /*axi_sequence_item_read   axi_seq_item_rd_data;
        //int             data_at_slave;
        //axi_seq_item_rsp = axi_sequence_item_read::type_id::create("axi_seq_item_rsp");
        //@(posedge axi_vif.clock);
        @(posedge axi_vif.clock);
        //for(i = 0; i <= axi_seq_item_rsp.AXI_ARLEN; i++)
        if(slave_rd_address_queue.size()!=0)
        begin
            @(posedge axi_vif.clock);
            wait(axi_vif.RREADY == 1'b1)
            @(posedge axi_vif.clock);
            axi_vif.RVALID          <=      1'b1;
            axi_vif.RDATA           <=      slave_rd_data_queue[slave_rd_address_queue[i]];
            axi_vif.RRESP           <=      1'b1;
            axi_vif.RLAST           <=      (i == axi_seq_item_rd_data.AXI_ARLEN - 1)? 1'b1 : 1'b0;
            
            //wait(axi_vif.WVALID == 1'b1)
            //@(posedge axi_vif.clock);
            //axi_vif.WREADY          <=      1'b1;
            //data_recieved           =       axi_vif.WDATA;
            @(negedge axi_vif.clock);
            $display("\t Data at Slave = %0h \n",axi_vif.RDATA);
            axi_vif.RVALID          <=      1'b0;
            axi_vif.RDATA           <=      1'b0;
            axi_vif.RRESP           <=      1'b0;
            axi_vif.RVALID          <=      1'b0;
        end */
        //wait(axi_vif.RREADY == 1'b0)
    end
endtask: slave_read_data
/*
task axi_slave_driver_read::slave_write_resp();
    forever begin
            int unsigned    rsp_count;

            wait(axi_vif.BREADY == 1'b1)
            //@(posedge axi_vif.clock);
        //seq_item_port.get_next_item(axi_seq_item_rsp);
        //begin
            for(rsp_count = 0; rsp_count < axi_seq_item_rsp.AXI_ARLEN; rsp_count++) begin
                if(rsp_count == axi_vif.ARLEN - 1)
                begin
                    @(posedge axi_vif.clock);
                    axi_vif.BVALID          <=      1'b1;                    
                    axi_vif.BRESP           <=      axi_seq_item_rsp.AXI_BRESP;
                end
                else begin
                    
                end
            end
            
            
            @(posedge axi_vif.clock);
            
            //wait(axi_vif.BREADY == 1'b1);
            //@(posedge axi_vif.clock);
            wait(axi_vif.BREADY == 1'b0);
            axi_vif.BVALID          <=      1'b0;
            @(posedge axi_vif.clock);

            //axi_vif.BRESP           <=      1'b0;

            //@(posedge axi_vif.clock);
        //seq_item_port.item_done();    
    end
endtask: slave_write_resp



task axi_slave_driver_read::get_addr();

endtask: get_addr

task axi_slave_driver_read::get_len();
    
endtask: get_len



task axi_slave_driver_read::get_size();
    
endtask: get_size

task axi_slave_driver_read::get_burst();
    
endtask: get_burst

*/