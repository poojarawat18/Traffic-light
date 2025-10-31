module traffic_light_controller (
    input clk, reset,
    output reg [2:0] light  // {Red, Yellow, Green}
);

    // State encoding
    parameter RED    = 2'b00,
              GREEN  = 2'b01,
              YELLOW = 2'b10;

    reg [1:0] state, next_state;
    reg [3:0] count; // counter for time delay

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= RED;
            count <= 0;
        end else begin
            state <= next_state;
            count <= count + 1;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            RED: begin
                light = 3'b100;  // Red ON
                if (count == 4'd5) // stay 5 cycles
                    next_state = GREEN;
                else
                    next_state = RED;
            end
            GREEN: begin
                light = 3'b001;  // Green ON
                if (count == 4'd5)
                    next_state = YELLOW;
                else
                    next_state = GREEN;
            end
            YELLOW: begin
                light = 3'b010;  // Yellow ON
                if (count == 4'd3) // shorter time
                    next_state = RED;
                else
                    next_state = YELLOW;
            end
            default: begin
                light = 3'b100;
                next_state = RED;
            end
        endcase
    end

    // Reset counter when state changes
    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 0;
        else if (state != next_state)
            count <= 0;
    end
