module sha256_core (
    input  logic         clk,
    input  logic         rst,
    input  logic         start,
    input  logic         first_block,
    input  logic [511:0] block,
    output logic         busy,
    output logic         done,
    output logic [255:0] digest
);

import sha256_pkg::*;

typedef enum logic [1:0] {IDLE, ROUNDS, FINAL} state_t;
state_t state;

logic [31:0] a, b, c, d, e, f, g, h;   // working variables
logic [31:0] H[8]; // the current hash state
logic [7:0] t; // time step counter

// sliding window
logic [31:0] w [16];
logic [31:0] w_next;

logic [31:0] T1, T2;

// mod 2^32 is the default behavior so we r chilling
assign T1 = h + Sigma1(e) + ch(e, f, g) + K[t[5:0]] + w[0]; // w[0] is the next word
assign T2 = Sigma0(a) + maj(a, b, c);

assign w_next = sigma1(w[14]) + w[9] + sigma0(w[1]) + w[0];

assign busy   = (state != IDLE);
assign digest = {H[0], H[1], H[2], H[3], H[4], H[5], H[6], H[7]};

always @(posedge clk) begin
    done <= 1'b0;

    if (rst) begin
        state <= IDLE; // set state to idle if reset held
        t     <= 8'd0; // same thing reset t
    end else begin
        case (state)

            IDLE: begin

                if (start) begin

                    // TODO theres def a syntax to replace this LMAO
                    w[0] <= block[511:480];
                    w[1] <= block[479:448];
                    w[2] <= block[447:416];
                    w[3] <= block[415:384];
                    w[4] <= block[383:352];
                    w[5] <= block[351:320];
                    w[6] <= block[319:288];
                    w[7] <= block[287:256];
                    w[8] <= block[255:224];
                    w[9] <= block[223:192];
                    w[10] <= block[191:160];
                    w[11] <= block[159:128];
                    w[12] <= block[127:96];
                    w[13] <= block[95:64];
                    w[14] <= block[63:32];
                    w[15] <= block[31:0];

                    // IF we're on the first block then set a-h (our working vars) to H_INIT
                    if (first_block) begin
                        for (int i = 0; i < 8; i++) H[i] <= H_INIT[i];
                        a <= H_INIT[0];  b <= H_INIT[1];  c <= H_INIT[2];  d <= H_INIT[3];
                        e <= H_INIT[4];  f <= H_INIT[5];  g <= H_INIT[6];  h <= H_INIT[7];
                    end else begin
                        // otherwise a-h are just the ones from the previous block (plus H)
                        a <= H[0];  b <= H[1];  c <= H[2];  d <= H[3];
                        e <= H[4];  f <= H[5];  g <= H[6];  h <= H[7];
                    end


                    t <= 8'd0; // counter for current time step, used in rounds
                    state <= ROUNDS; // move on
                end
            end

            ROUNDS: begin
                for (int i = 0; i < 15; i++) w[i] <= w[i+1];   // shift down everything to make room for new w
                w[15] <= w_next; // newest word enters at the top

                h <= g;
                g <= f;
                f <= e;

                e <= d + T1;

                d <= c;
                c <= b;
                b <= a;
                a <= T1 + T2;

                t <= t + 8'b1; // increment the time step

                if (t == 8'd63) begin
                    state <= FINAL; // move to the final state IF all rounds are done
                end
            end

            FINAL: begin

                H[0] <= H[0] + a;
                H[1] <= H[1] + b;
                H[2] <= H[2] + c;
                H[3] <= H[3] + d;
                H[4] <= H[4] + e;
                H[5] <= H[5] + f;
                H[6] <= H[6] + g;
                H[7] <= H[7] + h;

                done <= 1'b1;
                state <= IDLE;
            end

            default: state <= IDLE;

        endcase

    end
end

endmodule
