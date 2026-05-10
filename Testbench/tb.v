`timescale 1ns / 1ps

module tb;

    // ---------------------------------
    // Parameters
    // ---------------------------------
    parameter WIDTH  = 512;
    parameter HEIGHT = 512;
    parameter TOTAL_PIXELS = WIDTH * HEIGHT;

    // ---------------------------------
    // Signals
    // ---------------------------------
    reg         clk;
    reg         rst;

    reg         pixel_valid;
    reg [23:0]  pixel_in;

    wire        pixel_out_valid;
    wire [23:0] pixel_out;

    integer infile;
    integer outfile;
    integer r, g, b;
    integer pixel_count;

    // ---------------------------------
    // DUT : conv.v (COLOR)
    // ---------------------------------
    conv dut (
        .clk(clk),
        .rst(rst),
        .pixel_valid(pixel_valid),
        .pixel_in(pixel_in),
        .pixel_out_valid(pixel_out_valid),
        .pixel_out(pixel_out)
    );

    // ---------------------------------
    // Clock generation
    // ---------------------------------
    always #5 clk = ~clk;

    // ---------------------------------
    // Test sequence
    // ---------------------------------
    initial begin
        clk = 0;
        rst = 1;
        pixel_valid = 0;
        pixel_in = 24'd0;
        pixel_count = 0;

        #50;
        rst = 0;

        // Open files
        infile  = $fopen("image_rgb.txt", "r");
        outfile = $fopen("image_rgb_out.txt", "w");

        if (infile == 0) begin
            $display("ERROR: Cannot open input file.");
            $finish;
        end

        if (outfile == 0) begin
            $display("ERROR: Cannot open output file.");
            $finish;
        end

        // Feed pixels
        while (!$feof(infile) && pixel_count < TOTAL_PIXELS) begin
            @(posedge clk);

            if ($fscanf(infile, "%d %d %d\n", r, g, b) == 3) begin
                pixel_in    <= {r[7:0], g[7:0], b[7:0]};
                pixel_valid <= 1'b1;
                pixel_count <= pixel_count + 1;
            end else begin
                pixel_valid <= 1'b0;
            end
        end

        // Stop sending pixels
        @(posedge clk);
        pixel_valid <= 0;

        // Allow pipeline to flush
        repeat (20) @(posedge clk);

        $fclose(infile);
        $fclose(outfile);

        $display("Simulation finished successfully.");
        $finish;
    end

    // ---------------------------------
    // Capture output pixels
    // ---------------------------------
    always @(posedge clk) begin
        if (pixel_out_valid) begin
            $fwrite(outfile, "%0d %0d %0d\n",
                pixel_out[23:16],
                pixel_out[15:8],
                pixel_out[7:0]
            );
        end
    end

endmodule
