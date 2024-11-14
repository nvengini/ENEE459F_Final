#### Pin constraints for OLED
set_property IOSTANDARD LVCMOS18 [get_ports CLK]
set_property IOSTANDARD LVCMOS18 [get_ports RST]
set_property IOSTANDARD LVCMOS18 [get_ports EN]
set_property IOSTANDARD LVCMOS18 [get_ports CS]
set_property IOSTANDARD LVCMOS18 [get_ports SDIN]
set_property IOSTANDARD LVCMOS18 [get_ports SCLK]
set_property IOSTANDARD LVCMOS18 [get_ports DC]
set_property IOSTANDARD LVCMOS18 [get_ports RES]
set_property IOSTANDARD LVCMOS18 [get_ports VBAT]
set_property IOSTANDARD LVCMOS18 [get_ports VDD]
set_property IOSTANDARD LVCMOS18 [get_ports FIN]
# set_property PACKAGE_PIN W5 [get_ports CLK]
set_property PACKAGE_PIN U18 [get_ports RST]
set_property PACKAGE_PIN W19 [get_ports EN]
set_property PACKAGE_PIN A14 [get_ports CS]
set_property PACKAGE_PIN A16 [get_ports SDIN]
set_property PACKAGE_PIN B16 [get_ports SCLK]
set_property PACKAGE_PIN A15 [get_ports DC]
set_property PACKAGE_PIN A17 [get_ports RES]
set_property PACKAGE_PIN C15 [get_ports VBAT]
set_property PACKAGE_PIN C16 [get_ports VDD]
set_property PACKAGE_PIN L1 [get_ports FIN]


###___

set_property PACKAGE_PIN V16 [get_ports {SW[3]}]
set_property PACKAGE_PIN V17 [get_ports {SW[2]}]
set_property PACKAGE_PIN W16 [get_ports {SW[1]}]
set_property PACKAGE_PIN W17 [get_ports {SW[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {SW[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {SW[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {SW[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {SW[0]}]


##___


##set_property PACKAGE_PIN U16 [get_ports FIN]

##### transmitter and reciever pins for Second board 
##set_property IOSTANDARD LVCMOS18 [get_ports RxD]
##set_property IOSTANDARD LVCMOS18 [get_ports TxD]
##set_property PACKAGE_PIN J1 [get_ports RxD] # JA1
##set_property PACKAGE_PIN L2 [get_ports TxD] # JA2

##### transmitter and reciever pins for Main board 
#set_property IOSTANDARD LVCMOS18 [get_ports RxD]
#set_property IOSTANDARD LVCMOS18 [get_ports TxD]
#set_property PACKAGE_PIN K17 [get_ports RxD] 
#set_property PACKAGE_PIN M18 [get_ports TxD] 
##
## Button contraints for TX (fifo) and TX_en (multiplier)
#set_property IOSTANDARD LVCMOS18 [get_ports TX]
#set_property IOSTANDARD LVCMOS18 [get_ports TX_en]
#set_property PACKAGE_PIN T18 [get_ports TX] 
#set_property PACKAGE_PIN U17 [get_ports TX_en]
## Button layout
##        | TX  |
##   | EN | RST |    |
##        |TX_en|
##   
##   


## Pins used for UART
#set_property PACKAGE_PIN V16 [get_ports {SW[1]}]
#    set_property IOSTANDARD LVCMOS18 [get_ports {SW[1]}]
#set_property PACKAGE_PIN V17 [get_ports {SW[0]}]
#    set_property IOSTANDARD LVCMOS18 [get_ports {SW[0]}]
#set_property DRIVE 12 [get_ports UART_TX]
#set_property PACKAGE_PIN B18 [get_ports UART_RX] 
#    set_property IOSTANDARD LVCMOS18 [get_ports UART_RX]
#set_property PACKAGE_PIN A18 [get_ports UART_TX] 
#    set_property IOSTANDARD LVCMOS18 [get_ports UART_TX]
#    create_clock -add -name sys_clk_pin -period 20.00 -waveform {0 5} [get_ports CLK]
    
#set_property PACKAGE_PIN W3 [get_ports {cntr[0]}]
#set_property PACKAGE_PIN U3 [get_ports {cntr[1]}]
#set_property PACKAGE_PIN P3 [get_ports {cntr[2]}]
#set_property PACKAGE_PIN N3 [get_ports {cntr[3]}]
#set_property PACKAGE_PIN P1 [get_ports {cntr[4]}]
#set_property PACKAGE_PIN L1 [get_ports {cntr[5]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {cntr[0]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {cntr[1]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {cntr[2]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {cntr[3]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {cntr[4]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {cntr[5]}]     

#set_property PACKAGE_PIN V14 [get_ports {rx_pointer[0]}]
#set_property PACKAGE_PIN V13 [get_ports {rx_pointer[1]}]
#set_property PACKAGE_PIN V3  [get_ports {rx_pointer[2]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {rx_pointer[0]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {rx_pointer[1]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {rx_pointer[2]}]


#set_property PACKAGE_PIN V19 [get_ports {tx_pointer[0]}]
#set_property PACKAGE_PIN W18 [get_ports {tx_pointer[1]}]
#set_property PACKAGE_PIN V15 [get_ports {tx_pointer[2]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {tx_pointer[0]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {tx_pointer[1]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {tx_pointer[2]}]