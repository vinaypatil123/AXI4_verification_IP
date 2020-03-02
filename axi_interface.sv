//  Interface: axi_interface
//
interface axi_interface (input bit clock, input bit reset);

    // AXI address write phase
    logic [3:0]		AWID; //axi4 remove it
    logic [31:0]	AWADDR;
    logic [3:0]     AWREG;
    logic [7:0]		AWLEN;
    logic [2:0]	    AWSIZE;
    logic [1:0]	    AWBURST;
    logic 	        AWLOCK;
    logic [3:0]	    AWCACHE;
    logic [2:0]	    AWPROT;
    logic [3:0]		AWQOS;
    logic 	        AWVALID;
    logic 	        AWREADY;

	// AXI data write phase
    //logic [AXI_ID_WIDTH-1:-0]       WID;
    logic [31:0]	WDATA;
    logic [3:0]	    WSTRB;
    logic           WLAST;
    logic           WVALID;
    logic 	        WREADY;

	// AXI response write phase
    logic [3:0]		BID;
    logic [1:0]	    BRESP;
    logic 	        BVALID;
    logic           BREADY;

    
endinterface: axi_interface
