//  Class: axi_sequence_item
//


class axi_sequence_item_read extends uvm_sequence_item;

    //  Group: Variables
    `uvm_object_utils(axi_sequence_item_read)

    // AXI address write phase
    rand bit[3:0] 		AXI_ARID;
    rand bit[31:0] 	    AXI_ARADDR;
    rand bit[3:0]       AXI_ARREG;
    rand bit[7:0] 		AXI_ARLEN;
    rand bit[2:0] 	    AXI_ARSIZE;
    rand bit[1:0] 	    AXI_ARBURST;
    rand bit 	        AXI_ARLOCK;
    rand bit[3:0] 	    AXI_ARCACHE;
    rand bit[2:0] 	    AXI_ARPROT;
    rand bit[3:0] 	    AXI_ARQOS;
    bit  	            AXI_ARVALID;
    bit 	            AXI_ARREADY;

	// AXI data write phase
    rand bit[2:0]       AXI_RID;
    rand bit[31:0]      AXI_RDATA;
    rand bit[3:0]  	    AXI_RRESP;
    rand bit  	        AXI_RLAST;
    rand bit            AXI_RUSER;
    bit                 AXI_RVALID;
    bit 	            AXI_RREADY;


    //  Group: Functions

    int                 mem_data;
    int                 mem_addr;
    
    //  Constructor: new
    function new(string name = "axi_sequence_item_read");
        super.new(name);
    endfunction: new

    

    
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
    

    
endclass: axi_sequence_item_read
