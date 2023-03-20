`timescale 1ns / 1ps

module top(
    input CLK,
    input RESET,
    input [1:0] CAR_SELECT_IN,
    output IR_LED
);
    
    wire [7:0] Bus_Data;
    wire [7:0] Bus_Addr;
    wire Bus_WE;
    wire [7:0] Rom_Address;
    wire [7:0] Rom_Data;
    wire [1:0] Bus_Interrupts_Rise;
    wire [1:0] Bus_Interrupts_Ack;
    wire GENERATED_PACKET;

    
    Processor Processor_1(
        //Standard Signals
        .CLK(CLK),
        .RESET(RESET),
        //BUS Signals
        .BUS_DATA(Bus_Data),
        .BUS_ADDR(Bus_Addr),
        .BUS_WE(Bus_WE),
        // ROM signals
        .ROM_ADDRESS(Rom_Address),
        .ROM_DATA(Rom_Data),
        // INTERRUPT signals
        .BUS_INTERRUPTS_RAISE(Bus_Interrupts_Rise),
        .BUS_INTERRUPTS_ACK(Bus_Interrupts_Ack)
    );
     
     
    ROM ROM_1(
        //standard signals
        .CLK(CLK),
        //BUS signals
        .DATA(Rom_Data),
        .ADDR(Rom_Address)
    );
    
    RAM RAM_1(
        //standard signals
        .CLK(CLK),
        //BUS signals
        .BUS_DATA(Bus_Data),
        .BUS_ADDR(Bus_Addr),
        .BUS_WE(Bus_WE)
    );
    
    Timer # (.InitialIterruptRate(100))  Timer_1(
        //standard signals
        .CLK(CLK),
        .RESET(RESET),
        //BUS signals
        .BUS_DATA(Bus_Data),
        .BUS_ADDR(Bus_Addr),
        .BUS_WE(Bus_WE),
        .BUS_INTERRUPT_RAISE(Bus_Interrupts_Rise[1]),
        .BUS_INTERRUPT_ACK(Bus_Interrupts_Ack[1])
    );
    
    IR_top IR_top_1(
        .CLK(CLK),
        .RESET(RESET),
        .BUS_ADDR(Bus_Addr),
        .BUS_DATA(Bus_Data),
        .CarSelectIn(CAR_SELECT_IN),
        .IR_LED(GENERATED_PACKET)
    );
    assign IR_LED = GENERATED_PACKET;    

endmodule