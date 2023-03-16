`timescale 1ns / 1ps

module IR_top(
    input CLK,
    input RESET,
    
    input [7:0] BUS_ADDR,
    input [7:0] BUS_DATA,

    input [1:0] CarSelectIn,
    output IR_LED
    );
    // IR reads & exec if :
    //     Bus Addr: 0x90 i.e. 8'b10010000
    //     Bus data: 1 byte ([3:0])
    // then
    //    exec IR
    reg [3:0] COMMAND = 4'b0000;
    always @(CLK, BUS_ADDR) begin
        if (BUS_ADDR == 8'b10010000)
            COMMAND <= BUS_DATA;
    end
    
    wire [7:0] START_BURST_SIZE;
    wire [5:0] CAR_SELECT_BURST_SIZE;
    wire [5:0] GAP_SIZE;
    wire [5:0] ASSERT_BURST_SIZE;
    wire [4:0] DE_ASSERT_BURST_SIZE;
    wire FREQUENCY_TRIGGER;
    wire FREQUENCY_PULSE;
    wire GENERATED_PACKET;
    wire [1:0] SELECTED_CAR; 
    CarParameterSelector # ()
        CarSelector (.CLK(CLK),
            .CarSelectIn(CarSelectIn),
            .StartBurstSize(START_BURST_SIZE),
            .CarSelectBurstSize(CAR_SELECT_BURST_SIZE),
            .GapSize(GAP_SIZE),
            .AssertBurstSize(ASSERT_BURST_SIZE),
            .DeAssertBurstSize(DE_ASSERT_BURST_SIZE),
            .FrequencyTrigger(FREQUENCY_TRIGGER),
            .FrequencyPulse(FREQUENCY_PULSE),
            .SelectedCar(SELECTED_CAR)
            );
            
    IRTransmitterSM # ()
        IRTransmitterSM (.CLK(CLK),
        .Command(Command),
        .RESET(RESET),
        .StartBurstSize(START_BURST_SIZE),
        .CarSelectBurstSize(CAR_SELECT_BURST_SIZE),
        .GapSize(GAP_SIZE),
        .AssertBurstSize(ASSERT_BURST_SIZE),
        .DeAssertBurstSize(DE_ASSERT_BURST_SIZE),
        .FrequencyTrigger(FREQUENCY_TRIGGER),
        .FrequencyPulse(FREQUENCY_PULSE),
        .IRLed(GENERATED_PACKET)
        );
        
    
    assign IR_LED = GENERATED_PACKET;    
endmodule
