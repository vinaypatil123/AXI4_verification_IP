//  Module: axi_constraints
//
//  Class: axi_constraints
//


class axi_constraint;
    /*  PROPERTIES  */
    rand bit [7:0]start_address       ;
    rand int number_byte                  ;
    rand int data_bus_bytes               ;
    rand bit [7:0]aligned_address   ;
    rand int burst_length                 ;
    rand bit [7:0]wrap_boundary;
    rand bit [7:0]address[]           ;
    rand int lower_byte_lane[]            ;
    rand int upper_byet_lane[]            ;
    rand int total_byte                  ;

    //function new(string name = "axi_constraints");
      //  super.new(name);
    //endfunction: new

    constraint boundary
    {
        foreach( address[i])
                if(i == 0)
                begin
                    address[i] = start_address;
                end
                else
                begin
                    address[i] = aligned_address + i * number_byte
                end

        wrap_boundary = (start_address/(number_byte * burst_length)) * (number_byte * burst_length);

        foreach(lower_byte_lane[i])
            
                if(i == 0)
                begin
                    lower_byte_lane[i] = start_address - (start_address/data_bus_bytes) * data_bus_bytes;
                end
                else
                begin
                    lower_byte_lane[i] = address[i] - (address[i]/data_bus_bytes) * data_bus_bytes;
                end
            

        foreach(upper_byet_lane[i])
            
                if(i == 0)
                begin
                    upper_byet_lane[i] = aligned_address + (number_byte - 1) - (start_address/data_bus_bytes) * data_bus_bytes;
                end
                else
                begin
                    upper_byet_lane[i] = address[i] + (number_byte - 1) - (address[i]/data_bus_bytes) * data_bus_bytes;
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

