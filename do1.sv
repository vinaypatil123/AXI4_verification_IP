interface axi_interface
    /*  package imports  */
    #(
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

class axi_sequence;

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

endclass

//  Class: do1
//
class driver(axi_interface axi_intf, axi_sequence axi_seq);
    
    longint      start_address;
    int          number_bytes;
    int          data_bus_bytes;
    longint      aligned_address;
    int          burst_length;
    longint      address_n;
    longint      wrap_boundary;
    int          lower_byte_lane;
    int          upper_byte_lane;

    task calculate();
            
        start_address = axi_seq.AXI_AWADDR;
        number_bytes = 2^(axi_seq.AXI_AWSIZE);
        burst_length = axi_seq.AXI_AWLEN + 1;
        aligned_address = (start_address/number_bytes) * number_bytes;
        wrap_boundary = (start_address/(number_bytes * burst_length)) * (number_bytes * burst_length);
        data_bus_bytes = axi_seq.AXI_AWADDR / 8;
        if (index == 0) begin
          address_n = start_address;
          lower_byte_lane = aligned_address - (aligned_address/data_bus_bytes) * data_bus_bytes;
          upper_byte_lane = aligned_address + (number_bytes - 1) - (address_n/data_bus_bytes) * data_bus_bytes;
        end else begin
          case (axi_seq.AXI_AWBURST)
            2'b00 : begin
              address_n = aligned_address+index*number_bytes;
              if (address_n >= wrap_boundary + (number_bytes*burst_length)) begin
                address_n = wrap_boundary + (address_n - wrap_boundary - (number_bytes*burst_length));
              end
            end
            2'b01 : begin
              address_n = aligned_address;
            end
            2'b10 : begin
              address_n = aligned_address+index*number_bytes;
            end
          endcase
          lower_byte_lane = address_n - (address_n/data_bus_bytes) * data_bus_bytes;
          upper_byte_lane = lower_byte_lane + (number_bytes - 1);
        end
        return(lower_byte_lane);
    endtask



endclass: driver
