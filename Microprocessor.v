module Microprocessor(
    input clk,
    input reset,
    input [7:0] io_in,
    output reg [7:0] io_out
);

    // Definicja rejestrów
    reg [15:0] pc; // licznik programu
    reg [7:0] ir;  // rejestr instrukcji
    reg [7:0] acc; // akumulator
    reg [7:0] ram [0:255]; // pamięć RAM

    // Definicja instrukcji za pomocą lokalnych parametrów
    localparam [7:0]
        NOP      = 8'b00000000,
        LDA_IMM  = 8'b00000001,
        LDA_MEM  = 8'b00000010,
        STA_MEM  = 8'b00000011,
        ADD_IMM  = 8'b00000100,
        ADD_MEM  = 8'b00000101,
        SUB_IMM  = 8'b00000110,
        SUB_MEM  = 8'b00000111,
        JMP      = 8'b00001000,
        JZ       = 8'b00001001,
        JNZ      = 8'b00001010,
        IN       = 8'b00001011,
        OUT      = 8'b00001100;

    // Inicjalizacja pamięci RAM
    initial begin
        ram[0] <= LDA_IMM;
        ram[1] <= 8'd10;
        ram[2] <= STA_MEM;
        ram[3] <= 8'd0;
        ram[4] <= ADD_IMM;
        ram[5] <= 8'd5;
        ram[6] <= STA_MEM;
        ram[7] <= 8'd1;
        ram[8] <= LDA_MEM;
        ram[9] <= 8'd0;
        ram[10] <= SUB_MEM;
        ram[11] <= 8'd1;
        ram[12] <= JZ;
        ram[13] <= 8'd15;
        ram[14] <= LDA_IMM;
        ram[15] <= 8'd1;
        ram[16] <= OUT;
        ram[17] <= JMP;
        ram[18] <= 8'd9;
        ram[19] <= LDA_IMM;
        ram[20] <= 8'd0;
        ram[21] <= OUT;
        ram[22] <= NOP;
        pc <= 16'd0; // Ustawienie licznika programu na początek
    end

    // Główna pętla wykonawcza
    always @(posedge clk) begin
        if (reset) begin
            pc <= 16'd0; // Resetowanie licznika programu
        end else begin
            ir <= ram[pc]; // Pobranie instrukcji z pamięci RAM
            case(ir)
                NOP: pc <= pc + 1; // Brak operacji
                
                LDA_IMM: begin
                    acc <= ram[pc + 1]; // Załadowanie wartości natychmiastowej do akumulatora
                    pc <= pc + 2;
                end
                
                LDA_MEM: begin
                    acc <= ram[ram[pc + 1]]; // Załadowanie wartości z pamięci do akumulatora
                    pc <= pc + 2;
                end
                
                STA_MEM: begin
                    ram[ram[pc + 1]] <= acc; // Zapis akumulatora do pamięci
                    pc <= pc + 2;
                end
                
                ADD_IMM: begin
                    acc <= acc + ram[pc + 1]; // Dodanie wartości natychmiastowej do akumulatora
                    pc <= pc + 2;
                end
                
                ADD_MEM: begin
                    acc <= acc + ram[ram[pc + 1]]; // Dodanie wartości z pamięci do akumulatora
                    pc <= pc + 2;
                end
                
                SUB_IMM: begin
                    acc <= acc - ram[pc + 1]; // Odjęcie wartości natychmiastowej od akumulatora
                    pc <= pc + 2;
                end
                
                SUB_MEM: begin
                    acc <= acc - ram[ram[pc + 1]]; // Odjęcie wartości z pamięci od akumulatora
                    pc <= pc + 2;
                end
                
                JMP: begin
                    pc <= {8'b0, ram[pc + 1]}; // Skok do adresu
                end
                
                JZ: begin
                    if (acc == 0)
                        pc <= {8'b0, ram[pc + 1]}; // Skok, jeśli akumulator jest zerowy
                    else
                        pc <= pc + 2;
                end
                
                JNZ: begin
                    if (acc != 0)
                        pc <= {8'b0, ram[pc + 1]}; // Skok, jeśli akumulator nie jest zerowy
                    else
                        pc <= pc + 2;
                end
                
                IN: begin
                    acc <= io_in; // Pobranie danych wejściowych do akumulatora
                    pc <= pc + 1;
                end
                
                OUT: begin
                    io_out <= acc; // Wysłanie danych z akumulatora na wyjście
                    pc <= pc + 1;
                end
            endcase
        end
    end

endmodule