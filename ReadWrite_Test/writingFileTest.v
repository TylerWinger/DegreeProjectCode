
module writingFileTest (
);
integer file;
reg [63:0] data = 64'b1010101010101010101010101010101010101010101010101010101010101010;

initial begin
    file = $fopen("dataOut.txt","w");
    $fwrite(file,"%b",data);
    $fclose(file);
end
    
endmodule