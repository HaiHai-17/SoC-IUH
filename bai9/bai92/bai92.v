module bai92(
    input CLOCK_50,
    input [0:0] KEY
);
    system system_inst (
        .clk_clk(CLOCK_50),
        .reset_reset_n(KEY[0])
    );
endmodule