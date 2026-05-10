`timescale 1ns / 1ps

module conv #(
    parameter [3:0] FILTER_MODE  = 4'd0,   // select filter
    parameter signed [8:0] BRIGHT_VAL = -9'sd80,
    parameter [7:0] DUOTONE_TH   = 8'd128,
    parameter [23:0] COLOR_DARK  = 24'h1A1A1A,
    parameter [23:0] COLOR_LIGHT = 24'hE6E6E6,
    parameter [7:0] FADE_AMOUNT  = 8'd70,
    parameter [7:0] WARM_SHIFT   = 8'd10,
    parameter [1:0] GAMMA_LEVEL  = 2'd8,
    parameter [7:0] EDGE_TH      = 8'd11
)(
    input              clk,
    input              rst,
    input              pixel_valid,
    input      [23:0]  pixel_in,
    output reg         pixel_out_valid,
    output reg [23:0]  pixel_out
);

    // =========================================================
    // FILTER MODE DEFINITIONS
    // =========================================================
    localparam MODE_BRIGHT_SOFT   = 4'd0;
    localparam MODE_COLOR_BOOST   = 4'd1;
    localparam MODE_DARK_CINEMA   = 4'd2;
    localparam MODE_FADE_MILK     = 4'd3;
    localparam MODE_HIGH_CONTRAST = 4'd4;
    localparam MODE_BRIGHTNESS    = 4'd5;
    localparam MODE_DUOTONE       = 4'd6;
    localparam MODE_FILM_FADE     = 4'd7;
    localparam MODE_GAMMA         = 4'd8;
    localparam MODE_EDGE_SKETCH   = 4'd9;

    // =========================================================
    // INPUT CHANNEL SPLIT
    // =========================================================
    wire [7:0] R = pixel_in[23:16];
    wire [7:0] G = pixel_in[15:8];
    wire [7:0] B = pixel_in[7:0];

    // previous pixel storage for edge filter
    reg [23:0] prev_pixel;

    wire [7:0] Rp = prev_pixel[23:16];
    wire [7:0] Gp = prev_pixel[15:8];
    wire [7:0] Bp = prev_pixel[7:0];

    // =========================================================
    // COMMON FUNCTIONS
    // =========================================================
    function [7:0] clamp_signed;
        input signed [10:0] v;
        begin
            if (v < 0)
                clamp_signed = 8'd0;
            else if (v > 255)
                clamp_signed = 8'd255;
            else
                clamp_signed = v[7:0];
        end
    endfunction

    function [7:0] clamp_unsigned;
        input [10:0] v;
        begin
            if (v > 255)
                clamp_unsigned = 8'd255;
            else
                clamp_unsigned = v[7:0];
        end
    endfunction

    function [7:0] fade_fn;
        input [7:0] x;
        reg [8:0] temp;
        begin
            temp = (x >> 1) + 9'd40;
            if (temp > 9'd255)
                fade_fn = 8'd255;
            else
                fade_fn = temp[7:0];
        end
    endfunction

    function [7:0] contrast_fn;
        input [7:0] x;
        reg [8:0] temp;
        begin
            if (x < 8'd128) begin
                contrast_fn = x >> 1;
            end else begin
                temp = 9'd128 + ((x - 8'd128) << 1);
                if (temp > 9'd255)
                    contrast_fn = 8'd255;
                else
                    contrast_fn = temp[7:0];
            end
        end
    endfunction

    // =========================================================
    // INTERMEDIATE CALCULATIONS
    // =========================================================

    // grayscale for color boost
    wire [15:0] gray_cb_full = (R * 8'd30) + (G * 8'd59) + (B * 8'd11);
    wire [7:0]  gray_cb      = gray_cb_full / 8'd100;

    // grayscale for duotone and edge
    wire [9:0] gray_duo  = R + G + B;
    wire [7:0] gray      = gray_duo / 3;

    wire [9:0] gray_prev_sum = Rp + Gp + Bp;
    wire [7:0] gray_prev     = gray_prev_sum / 3;

    wire [7:0] diff = (gray > gray_prev) ? (gray - gray_prev) : (gray_prev - gray);

    // gamma
    wire [8:0] Rg = {1'b0, R} + ({1'b0, R} >> GAMMA_LEVEL);
    wire [8:0] Gg = {1'b0, G} + ({1'b0, G} >> GAMMA_LEVEL);
    wire [8:0] Bg = {1'b0, B} + ({1'b0, B} >> GAMMA_LEVEL);

    // film fade
    wire [15:0] R_mul_fade = (R * FADE_AMOUNT);
    wire [15:0] G_mul_fade = (G * FADE_AMOUNT);
    wire [15:0] B_mul_fade = (B * FADE_AMOUNT);

    wire [9:0] Rf = R + FADE_AMOUNT - (R_mul_fade / 8'd255);
    wire [9:0] Gf = G + FADE_AMOUNT - (G_mul_fade / 8'd255);
    wire [9:0] Bf = B + FADE_AMOUNT - (B_mul_fade / 8'd255);

    wire signed [10:0] Rout = {1'b0, Rf} + $signed({1'b0, WARM_SHIFT});
    wire signed [10:0] Gout = {1'b0, Gf};
    wire signed [10:0] Bout = $signed({1'b0, Bf}) - $signed({1'b0, WARM_SHIFT});

    // =========================================================
    // MAIN SEQUENTIAL LOGIC
    // =========================================================
    always @(posedge clk) begin
        if (rst) begin
            pixel_out_valid <= 1'b0;
            pixel_out       <= 24'd0;
            prev_pixel      <= 24'd0;
        end else begin
            pixel_out_valid <= pixel_valid;

            if (pixel_valid) begin
                case (1) // controlling part

                    // -------------------------------------------------
                    // 0. BRIGHT + SOFT
                    // -------------------------------------------------
                    MODE_BRIGHT_SOFT: begin
                        pixel_out <= {
                            clamp_unsigned({3'd0, R} + 11'd30),
                            clamp_unsigned({3'd0, G} + 11'd30),
                            clamp_unsigned({3'd0, B} + 11'd30)
                        };
                    end

                    // -------------------------------------------------
                    // 1. COLOR BOOST
                    // -------------------------------------------------
                    MODE_COLOR_BOOST: begin
                        pixel_out <= {
                            clamp_signed($signed({1'b0, gray_cb}) + (($signed({1'b0, R}) - $signed({1'b0, gray_cb})) <<< 1)),
                            clamp_signed($signed({1'b0, gray_cb}) + (($signed({1'b0, G}) - $signed({1'b0, gray_cb})) <<< 1)),
                            clamp_signed($signed({1'b0, gray_cb}) + (($signed({1'b0, B}) - $signed({1'b0, gray_cb})) <<< 1))
                        };
                    end

                    // -------------------------------------------------
                    // 2. DARK CINEMATIC
                    // -------------------------------------------------
                    MODE_DARK_CINEMA: begin
                        pixel_out <= {
                            R >> 1,
                            G >> 1,
                            B >> 1
                        };
                    end

                    // -------------------------------------------------
                    // 3. FADE MILK
                    // -------------------------------------------------
                    MODE_FADE_MILK: begin
                        pixel_out <= {
                            fade_fn(R),
                            fade_fn(G),
                            fade_fn(B)
                        };
                    end

                    // -------------------------------------------------
                    // 4. HIGH CONTRAST
                    // -------------------------------------------------
                    MODE_HIGH_CONTRAST: begin
                        pixel_out <= {
                            contrast_fn(R),
                            contrast_fn(G),
                            contrast_fn(B)
                        };
                    end

                    // -------------------------------------------------
                    // 5. BRIGHTNESS FILTER
                    // -------------------------------------------------
                    MODE_BRIGHTNESS: begin
                        pixel_out <= {
                            clamp_signed($signed({1'b0, R}) + BRIGHT_VAL),
                            clamp_signed($signed({1'b0, G}) + BRIGHT_VAL),
                            clamp_signed($signed({1'b0, B}) + BRIGHT_VAL)
                        };
                    end

                    // -------------------------------------------------
                    // 6. DUOTONE FILTER
                    // -------------------------------------------------
                    MODE_DUOTONE: begin
                        pixel_out <= (gray > DUOTONE_TH) ? COLOR_LIGHT : COLOR_DARK;
                    end

                    // -------------------------------------------------
                    // 7. FILM FADE FILTER
                    // -------------------------------------------------
                    MODE_FILM_FADE: begin
                        pixel_out <= {
                            clamp_signed(Rout),
                            clamp_signed(Gout),
                            clamp_signed(Bout)
                        };
                    end

                    // -------------------------------------------------
                    // 8. GAMMA FILTER
                    // -------------------------------------------------
                    MODE_GAMMA: begin
                        pixel_out <= {
                            clamp_unsigned({2'd0, Rg}),
                            clamp_unsigned({2'd0, Gg}),
                            clamp_unsigned({2'd0, Bg})
                        };
                    end

                    // -------------------------------------------------
                    // 9. EDGE SKETCH FILTER
                    // -------------------------------------------------
                    MODE_EDGE_SKETCH: begin
                        pixel_out <= (diff > EDGE_TH) ? 24'h000000 : 24'hFFFFFF;
                    end

                    // -------------------------------------------------
                    // DEFAULT = BYPASS
                    // -------------------------------------------------
                    default: begin
                        pixel_out <= pixel_in;
                    end
                endcase

                prev_pixel <= pixel_in;
            end
        end
    end

endmodule