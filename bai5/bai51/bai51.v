module bai51(
input CLOCK_50,
input [0:0]KEY,
output [0:0]LCD_ON,
output [0:0]LCD_BLON,
output [0:0]LCD_EN,
output [0:0]LCD_RW,
output [0:0]LCD_RS,
output [7:0]LCD_DATA
);
system nios_system (
        .clk_clk                             (CLOCK_50),                             
        .reset_reset_n                       (KEY[0]),                       
        .lcd_on_external_connection_export   (LCD_ON),   
        .lcd_blon_external_connection_export (LCD_BLON), 
        .lcd_en_external_connection_export   (LCD_EN),   
        .lcd_rw_external_connection_export   (LCD_RW),   
        .lcd_rs_external_connection_export   (LCD_RS),   
        .lcd_d_external_connection_export (LCD_DATA),  
    );
	 
endmodule