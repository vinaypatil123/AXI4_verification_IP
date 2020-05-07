//  Class: axi_sequence_item
//


class axi_sequence_item extends uvm_sequence_item;

    //  Group: Variables
    `uvm_object_utils(axi_sequence_item)

    // AXI address write phase
    rand bit[3:0] 		AXI_AWID;
    rand bit[31:0] 	    AXI_AWADDR;
    rand bit[3:0]       AXI_AWREG;
    rand bit[7:0] 		AXI_AWLEN;
    rand bit[2:0] 	    AXI_AWSIZE;
    rand bit[1:0] 	    AXI_AWBURST;
    rand bit 	        AXI_AWLOCK;
    rand bit[3:0] 	    AXI_AWCACHE;
    rand bit[2:0] 	    AXI_AWPROT;
    rand bit[3:0] 	    AXI_AWQOS;
    bit  	            AXI_AWVALID;
    bit 	            AXI_AWREADY;

	// AXI data write phase
    //rand bit[2:0]       AXI_WID;
    rand bit[31:0]      AXI_WDATA;
    rand bit[3:0]  	    AXI_WSTRB;
    rand bit  	        AXI_WLAST;
    bit                 AXI_WVALID;
    bit 	            AXI_WREADY;

	// AXI response write phase
    bit[3:0]       	    AXI_BID;
    bit[1:0] 	        AXI_BRESP;
    bit                 AXI_BVALID;
    bit	                AXI_BREADY;

    //  Group: Functions

    int                 mem_data[$];
    int                 mem_addr[$];

    //  Constructor: new
    function new(string name = "axi_sequence_item");
        super.new(name);
    endfunction: new

    extern function void post_randomize();

    
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

function void axi_sequence_item::post_randomize();
    begin
        for(int i = 0; i <= AXI_AWLEN - 1; i++)
        begin
            mem_data.push_back(AXI_WDATA[i]);
        end
    end
            
endfunction : post_randomize
