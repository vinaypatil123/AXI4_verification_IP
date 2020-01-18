//  Class: axi_sequence_item
//
`include "uvm_macros.svh"
import uvm_pkg::*;

class axi_sequence_item extends uvm_sequence_item;
    

    //  Group: Variables

    // AXI address write phase
    rand bit[2:0] 		AXI_AWID;
    rand bit[7:0] 	    AXI_AWADDR;
    //logic [AXI_REG_WITH-1:0]        AXI_AWREG;
    rand bit[7:0] 		AXI_AWLEN;
    rand bit[2:0] 	    AXI_AWSIZE;
    rand bit[1:0] 	    AXI_AWBURST;
    //rand logic[] 	    AXI_AWLOCK;
    //logic[] 	        AXI_AWCACHE;
    //logic[] 	        AXI_AWPROT;
    //logic[] 		    AXI_AWQOS;
    rand bit 	        AXI_AWVALID;
    bit 	            AXI_AWREADY;

	// AXI data write phase
    rand bit[2:0]       AXI_WID;
    rand bit[31:0]      AXI_WDATA;
    //rand bit[]  	    AXI_WSTRB;
    //rand bit[]  	    AXI_WLAST;
    rand bit            AXI_WVALID;
    bit 	            AXI_WREADY;

	// AXI response write phase
    logic[2:0]   	    AXI_BID;
    logic[1:0] 	        AXI_BRESP;
    logic               AXI_BVALID;
    rand logic	        AXI_BREADY;

    //  Group: Functions

    //  Constructor: new
    function new(string name = "axi_sequence_item");
        super.new(name);
    endfunction: new

    `uvm_object_utils(axi_sequence_item)
    //  Function: do_copy
    // extern function void do_copy(uvm_object rhs);
    //  Function: do_compare
    // extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    //  Function: convert2string
    // extern function string convert2string();
    //  Function: do_print
    // extern function void do_print(uvm_printer printer);
    //  Function: do_record
    // extern function void do_record(uvm_recorder recorder);
    //  Function: do_pack
    // extern function void do_pack();
    //  Function: do_unpack
    // extern function void do_unpack();
    

    
endclass: axi_sequence_item
