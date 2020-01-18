//  Module: axi_constraints
//
//  Class: axi_constraints
//
`define AW = 8;
`define DW = 32;
`define size = 4;
`define address = 32'h00000000;

class axi_constraint;
    /*  PROPERTIES  */
    rand bit [`AW-1:0]start_address       = `address;
    rand int number_byte                  = 2 ^ (`size);
    rand int data_bus_bytes               = `DW / 8;
    rand bit [`AW-1 : 0]aligned_address   = (start_address/number_byte)*number_byte;
    rand int burst_length                 = length + 1;
    rand bit [`AW-1:0]wrap_boundary;
    rand bit [`AW-1:0]address[]           = new[burst_length];
    rand int lower_byte_lane[]            = new[burst_length];
    rand int upper_byet_lane[]            = new[burst_length];
    rand int total_byte                   = 0;

    //function new(string name = "axi_constraints");
      //  super.new(name);
    //endfunction: new

    constraint boundary
    {
        foreach( address[i])
            begin
                if(i == 0)
                begin
                    address[i] = start_address;
                end
                else
                begin
                    address[i] = aligned_address + i * number_byte
                end
            end

        wrap_boundary = (start_address/(number_byte * burst_length)) * (number_byte * burst_length);

        foreach(lower_byte_lane[i])
            begin
                if(i == 0)
                begin
                    lower_byte_lane[i] = start_address - (start_address/data_bus_bytes) * data_bus_bytes;
                end
                else
                begin
                    lower_byte_lane[i] = address[i] - (address[i]/data_bus_bytes) * data_bus_bytes;
                end
            end

        foreach(upper_byet_lane[i])
            begin
                if(i == 0)
                begin
                    upper_byet_lane[i] = aligned_address + (number_byte - 1) - (start_address/data_bus_bytes) * data_bus_bytes;
                end
                else
                begin
                    upper_byet_lane[i] = address[i] + (number_byte - 1) - (address[i]/data_bus_bytes) * data_bus_bytes;
                end
            end
    };
endclass
Module top();

axi_constraint axi_c = new();

    initial begin
        repeat(10)
        begin
            axi_c.start_address = $urandom();
            $display("Start Address = %h",axi_c.start_address);
        end
    end

    
    

endmodule: axi_constraint

