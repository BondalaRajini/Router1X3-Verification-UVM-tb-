
//router rd_xtn class

class rd_xtn extends uvm_sequence_item;
       `uvm_object_utils(rd_xtn)
    bit [7:0] header;
    bit [7:0] payload[];
    bit [7:0] parity;
    bit read_enb;
    bit valid_out;
    rand bit[5:0]cyc;
    
   function new(string name ="rd_xtn");
      super.new(name);
   endfunction

   function void do_print(uvm_printer printer);
     super.do_print(printer);
    //                   srting name                              bitstream value          size       radix for printing
    printer.print_field( "valid_out",                               this.valid_out,         1,          UVM_DEC                );
    printer.print_field( "read_enb",                                this.read_enb,          1,          UVM_DEC                );
    printer.print_field( "header",                                  this.header,            8,          UVM_DEC                );
  foreach(payload[i])
    printer.print_field(  $sformatf("payload[%0d]",i),              this.payload[i],        8,          UVM_DEC                );
    printer.print_field( "parity",                                  this.parity,            8,          UVM_DEC                );
    printer.print_field( "cyc",                                     this.cyc,               6,          UVM_DEC                );
  endfunction 
 

endclass
