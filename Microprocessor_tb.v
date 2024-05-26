`timescale 1ns / 1ps

module Microprocessor_tb;

    // Definiowanie sygnałów
    reg clk;
    reg reset;
    reg [7:0] io_in;
    wire [7:0] io_out;
    
    // Instancja testowanego modułu
    Microprocessor uut (
        .clk(clk),
        .reset(reset),
        .io_in(io_in),
        .io_out(io_out)
    );

    // Generowanie zegara
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Okres zegara 10 ns
    end
    
    // Test główny
    initial begin
        // Inicjalizacja sygnałów
        reset = 1;
        io_in = 8'd0;
        
        // Inicjalizacja programu w pamięci RAM
        uut.ram[0] <= uut.LDA_IMM;
        uut.ram[1] <= 8'd10;
        uut.ram[2] <= uut.STA_MEM;
        uut.ram[3] <= 8'd0;
        uut.ram[4] <= uut.ADD_IMM;
        uut.ram[5] <= 8'd5;
        uut.ram[6] <= uut.STA_MEM;
        uut.ram[7] <= 8'd1;
        uut.ram[8] <= uut.LDA_MEM;
        uut.ram[9] <= 8'd0;
        uut.ram[10] <= uut.SUB_MEM;
        uut.ram[11] <= 8'd1;
        uut.ram[12] <= uut.JZ;
        uut.ram[13] <= 8'd15;
        uut.ram[14] <= uut.LDA_IMM;
        uut.ram[15] <= 8'd1;
        uut.ram[16] <= uut.OUT;
        uut.ram[17] <= uut.JMP;
        uut.ram[18] <= 8'd9;
        uut.ram[19] <= uut.LDA_IMM;
        uut.ram[20] <= 8'd0;
        uut.ram[21] <= uut.OUT;
        uut.ram[22] <= uut.NOP;

        // Zwolnienie resetu po 20 ns
        #20;
        reset = 0;
        
        // Testowanie instrukcji
        #100;
        io_in = 8'd42; // Przykładowa wartość do instrukcji IN
        #10;
        
        // Oczekiwanie na zakończenie
        #200;
        
        // Zakończenie symulacji
        $stop;
    end
    
    // Monitorowanie sygnałów
    initial begin
        $monitor("Time=%0d, clk=%b, reset=%b, io_in=%d, io_out=%d, pc=%d, acc=%d", 
                  $time, clk, reset, io_in, io_out, uut.pc, uut.acc);
    end

endmodule