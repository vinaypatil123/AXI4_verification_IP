//  Class: axi_driver
//
`include "uvm_macros.svh"
import uvm_pkg::*;

class axi_driver extends uvm_driver #(axi_sequence_item);
    /*  PROPERTIES  */
    `uvm_component_utils(axi_driver)

    virtual axi_interface axi_vif;
    axi_sequence_item master_wrt_q[$];

    int unsigned                master_number_sent = 0;

    int unsigned                master_wr_addr_indx = 0;
    int unsigned                master_wr_data_indx = 0;

    function new(string name = "axi_driver", uvm_component parent = null);
        super.new(name,parent);
    endfunction: new

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if (!uvm_config_db#(virtual interface axi_interface)::get(this, "", "axi_vif", axi_vif))
            `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".axi_vif"})
        
    endfunction: connect_phase
    

    task run_phase(uvm_phase phase);
        axi_sequence_item axi_seq_item_req;
        axi_sequence_item axi_seq_item_rsp;
        axi_sequence_item master_transfer;

        fork
            begin
                @(posedge axi_vif.clk)
                seq_item_port.get_next_item(axi_seq_item_req);
                //drive_transfer(axi_seq_item_req);
                    `uvm_info(get_type_name(), $psprint("Driving %s \n", axi_seq_item_req.sprint()), UVM_HIGH)
                    master_wrt_q.push_back(axi_seq_item_req);
                    `uvm_info(get_type_name(), $psprint("Item %d sent\n", master_number_sent), UVM_HIGH)

                    master_number_sent++;
                
                seq_item_port.item_done;
            end
            forever begin
                //@(posedge axi_vif.clk);
                axi_vif.AWID        <=  0;
                axi_vif.AWADDR      <=  0;
                axi_vif.AXI_AWLEN       <=  0;
                axi_vif.AXI_AWSIZE      <=  0;
                axi_vif.AXI_AWBURST     <=  0;
            end 
            forever begin
                repeat(master_wrt_q.size()==0)
                master_transfer = master_wrt_q[master_wr_addr_indx];
                @(posedge axi_vif.clk)
                #5;
                axi_vif.AWVALID     <=      1'b1;
                axi_vif.AWID        <=      master_transfer.AXI_AWID;
                axi_vif.AWADDR      <=      master_transfer.AXI_AWADDR;
                axi_vif.AWLEN       <=      master_transfer.AXI_AWLEN;
                axi_vif.AWSIZE      <=      master_transfer.AXI_AWSIZE;
                axi_vif.AWBURST     <=      master_transfer.AXI_AWBURST;    

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
        join
        
    endtask: run_phase
    
    

endclass: axi_driver
