import sha256_pkg::*;

typedef enum logic [1:0] {IDLE, ROUNDS, FINAL} state_t;
state_t state;

always @(posedge clk) begin
    case (state)

        IDLE: begin

            if (start) begin

                // TODO theres def a syntax to replace this LMAO
                W[0] <= block[511:480];
                W[1] <= block[479:448];
                W[2] <= block[447:416];
                W[3] <= block[415:384];
                W[4] <= block[383:352];
                W[5] <= block[351:320];
                W[6] <= block[319:288];
                W[7] <= block[287:256];
                W[8] <= block[255:224];
                W[9] <= block[223:192];
                W[10] <= block[191:160];
                W[11] <= block[159:128];
                W[12] <= block[127:96];
                W[13] <= block[95:64];
                W[14] <= block[63:32];
                W[15] <= block[31:0];

                t <= 8'd0 // counter for current time step, used in rounds
                state <= ROUNDS;
            end

        end



    endcase
end