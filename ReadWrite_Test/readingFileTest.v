/*
//Reading a string
module readingFileTest ();
     integer file;
     reg [8*64:0] string;
     
  initial begin
     file = $fopen("data.txt","r");   

  while (!$feof(file))begin
    $fgets(string,file);
    $display("String %0s",string);
  end
  $fclose(file);
  end


endmodule
*/

//Reading binary data
module readingFileTest (
);
integer file;
reg [63:0] data;

  initial begin
    file = $fopen("data.txt","r");
    while (!$feof(file))begin
        $fscanf(file,"%b",data); 
        $display("data: %0b",data);
    end
    $fclose(file);
  end 
endmodule
