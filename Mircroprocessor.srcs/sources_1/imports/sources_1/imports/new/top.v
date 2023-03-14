`timescale 1ns / 1ps

module top(
    input CLK,
    input RESET,
    input [3:0] Command,
    input [1:0] CarSelectIn,
    output IR_LED
    );
    
    wire [7:0] START_BURST_SIZE;
    wire [5:0] CAR_SELECT_BURST_SIZE;
    wire [5:0] GAP_SIZE;
    wire [5:0] ASSERT_BURST_SIZE;
    wire [4:0] DE_ASSERT_BURST_SIZE;
    wire FREQUENCY_TRIGGER;
    wire FREQUENCY_PULSE;
    wire GENERATED_PACKET;
    wire [1:0] SELECTED_CAR;
    wire [3:0] ACTIVE_ANODE;
    wire [6:0] SEGMENT_DISPLAY_OUT;
    
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