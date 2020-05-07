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

    // AXI address read phase
    logic [3:0]		ARID; //axi4 remove it
    logic [31:0]	ARADDR;
    logic [3:0]     ARREG;
    logic [7:0]		ARLEN;
    logic [2:0]	    ARSIZE;
    logic [1:0]	    ARBURST;
    logic 	        ARLOCK;
    logic [3:0]	    ARCACHE;
    logic [2:0]	    ARPROT;
    logic [3:0]		ARQOS;
    logic 	        ARVALID;
    logic 	        ARREADY;

    // AXI data read phase
    logic [3:0]     RID;
    logic [31:0]	RDATA;
    logic [3:0]	    RRESP;
    logic           RLAST;

    logic           RVALID;
    logic 	        RREADY;

    
endinterface: axi_interface
