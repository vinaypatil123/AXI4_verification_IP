//  Interface: axi_interface
//
interface axi_interface #(
        parameter integer AXI_ID_WIDTH 	    = 10,
		parameter integer AXI_ADDR_WIDTH 	= 32,
        //parameter integer AXI_REG_WITH      = 4,
		parameter integer AXI_DATA_WIDTH 	= 32,
		parameter integer AXI_LEN_WIDTH 	= 8, 
		parameter integer AXI_SIZE_WIDTH 	= 3,
		parameter integer AXI_BURST_WIDTH   = 2,
        parameter integer AXI_LOCK_WIDTH    = 1,
		parameter integer AXI_CACHE_WIDTH   = 4,
		parameter integer AXI_PROT_WIDTH 	= 3,
		parameter integer AXI_QOS_WIDTH	    = 4,
		parameter integer AXI_STRB_WIDTH 	= 4,
		parameter integer AXI_RESP_WIDTH 	= 2,
        parameter integer AXI_VALID_WIDTH   = 1,
        parameter integer AXI_READY_WIDTH   = 1,
        parameter integer AXI_LAST_WIDTH    = 1,
        parameter string name = "vif"
    )(input bit clock);

    // AXI address write phase
    logic [AXI_ID_WIDTH-1:0]		AWID; //axi4 remove it
    logic [AXI_ADDR_WIDTH-1:0]	    AWADDR;
    //logic [AXI_REG_WITH-1:0]        AXI_AWREG;
    logic [AXI_LEN_WIDTH-1:0]		AWLEN;
    logic [AXI_SIZE_WIDTH-1:0]	    AWSIZE;
    logic [AXI_BURST_WIDTH-1:0]	    AWBURST;
    logic [AXI_LOCK_WIDTH-1:0]	    AWLOCK;
    logic [AXI_CACHE_WIDTH-1:0]	    AWCACHE;
    logic [AXI_PROT_WIDTH-1:0]	    AWPROT;
    logic [AXI_QOS_WIDTH-1:0]		AWQOS;
    logic [AXI_VALID_WIDTH-1:0]	    AWVALID;
    logic [AXI_READY_WIDTH-1:0]	    AWREADY;

	// AXI data write phase
    logic [AXI_ID_WIDTH-1:-0]       WID;
    logic [AXI_DATA_WIDTH-1:0]	    WDATA;
    logic [AXI_STRB_WIDTH-1:0]	    WSTRB;
    logic [AXI_LAST_WIDTH-1:0]	    WLAST;
    logic [AXI_VALID_WIDTH-1:0]     WVALID;
    logic [AXI_READY_WIDTH-1:0]	    WREADY;

	// AXI response write phase
    logic [AXI_ID_WIDTH-1:0]		BID;
    logic [AXI_RESP_WIDTH-1:0]	    BRESP;
    logic [AXI_VALID_WIDTH-1:0]	    BVALID;
    logic [AXI_READY_WIDTH-1:0]	    BREADY;

    
endinterface: axi_interface
