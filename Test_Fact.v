module MIPS32_test2;

reg clk1,clk2;
integer k;

Pipeline_MIPS32 mips2 (clk1,clk2);

initial 
    begin
        clk1=0;clk2=0;
        repeat(50)
            begin
            #5 clk1=1;#5 clk1=0;
            #5 clk2=1;#5 clk2=0;
            end
    end
initial
    begin
        for(k=0;k<31;k=k+1)
            begin
            mips2.Reg[k]=k;
            end
        
        mips2.Mem[0] = 32'h280a00c8; //ADDI R10,R0,200
        mips2.Mem[1] = 32'h28020001; //ADDI R2,R0,1
        mips2.Mem[2] = 32'h0e94a000; //DUMMY
        mips2.Mem[3] = 32'h21430000; //LW   R3,0(R10)
        mips2.Mem[4] = 32'h0e94a000; //DUMMY
        mips2.Mem[5] = 32'h14431000; //LOOP :MUL R2,R2,R3
        mips2.Mem[6] = 32'h2c630001; //SUBI R3,R3,1
        mips2.Mem[7] = 32'h0e94a000; //DUMMY
        mips2.Mem[8] = 32'h3460fffc; //BNEQZ R3,LOOP
        mips2.Mem[9] = 32'h2542fffc; //SW   R3,-2(R10)
        mips2.Mem[10] = 32'hfc000000;//HALT
        
        mips2.Mem[200] = 7;
        
        mips2.HALTED = 0;
        mips2.PC = 0;
        mips2.TAKEN_BRANCH = 0;
        
        #2000 $display("Mem[200] =%2d, Mem[198]= %6d",mips2.Mem[200],mips2.Mem[198]);
       
    end    

initial
    begin
    $monitor ("R2:%4d",mips2.Reg[2]);
    #3000 $finish;
    end
    
endmodule
