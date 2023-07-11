#----------------------------------------------------------------------------------
#-- Constraints
#----------------------------------------------------------------------------------

## 	Switches

# Valores por defecto para los switches, que están asociados con un pin determinado de la FPGA y alimentados con 3.3V
#set_property PACKAGE_PIN V17 [get_ports {SW[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SW[0]}]
#set_property PACKAGE_PIN V16 [get_ports {SW[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SW[1]}]
#set_property PACKAGE_PIN W16 [get_ports {SW[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SW[2]}]
#set_property PACKAGE_PIN W17 [get_ports {SW[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SW[3]}]
#set_property PACKAGE_PIN W15 [get_ports {SW[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SW[4]}]
#set_property PACKAGE_PIN V15 [get_ports {SW[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SW[5]}]
#set_property PACKAGE_PIN W14 [get_ports {SW[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SW[6]}]
#set_property PACKAGE_PIN W13 [get_ports {SW[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SW[7]}]
#set_property PACKAGE_PIN V2 [get_ports {SW[8]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SW[8]}]
#set_property PACKAGE_PIN T3 [get_ports {SW[9]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SW[9]}]
#set_property PACKAGE_PIN T2 [get_ports {SW[10]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SW[10]}]
#set_property PACKAGE_PIN R3 [get_ports {SW[11]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SW[11]}]
#set_property PACKAGE_PIN W2 [get_ports {SW[12]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SW[12]}]
#set_property PACKAGE_PIN U1 [get_ports {SW[13]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SW[13]}]
#set_property PACKAGE_PIN T1 [get_ports {SW[14]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SW[14]}]
#set_property PACKAGE_PIN R2 [get_ports {SW[15]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SW[15]}]


## 	LEDs

# Valores por defecto para los leds, que están asociados con un pin determinado de la FPGA y alimentados con 3.3V
set_property PACKAGE_PIN U16 [get_ports {LED[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[0]}]
set_property PACKAGE_PIN E19 [get_ports {LED[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[1]}]
set_property PACKAGE_PIN U19 [get_ports {LED[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[2]}]
set_property PACKAGE_PIN V19 [get_ports {LED[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[3]}]
set_property PACKAGE_PIN W18 [get_ports {LED[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[4]}]
set_property PACKAGE_PIN U15 [get_ports {LED[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[5]}]
set_property PACKAGE_PIN U14 [get_ports {LED[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[6]}]
set_property PACKAGE_PIN V14 [get_ports {LED[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[7]}]
set_property PACKAGE_PIN V13 [get_ports {LED[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[8]}]
set_property PACKAGE_PIN V3 [get_ports {LED[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[9]}]
set_property PACKAGE_PIN W3 [get_ports {LED[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[10]}]
set_property PACKAGE_PIN U3 [get_ports {LED[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[11]}]
set_property PACKAGE_PIN P3 [get_ports {LED[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[12]}]
set_property PACKAGE_PIN N3 [get_ports {LED[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[13]}]
set_property PACKAGE_PIN P1 [get_ports {LED[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[14]}]
set_property PACKAGE_PIN L1 [get_ports {LED[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[15]}]


##7	segment display
# Valores por defecto para los cátodos del display, que están asociados con un pin determinado de la FPGA y alimentados con 3.3V
set_property PACKAGE_PIN W7 [get_ports {CAT[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {CAT[0]}]
set_property PACKAGE_PIN W6 [get_ports {CAT[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {CAT[1]}]
set_property PACKAGE_PIN U8 [get_ports {CAT[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {CAT[2]}]
set_property PACKAGE_PIN V8 [get_ports {CAT[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {CAT[3]}]
set_property PACKAGE_PIN U5 [get_ports {CAT[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {CAT[4]}]
set_property PACKAGE_PIN V5 [get_ports {CAT[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {CAT[5]}]
set_property PACKAGE_PIN U7 [get_ports {CAT[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {CAT[6]}]
set_property PACKAGE_PIN V7 [get_ports {CAT[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {CAT[7]}]

# Valores por defecto para los ánodos del display, que están asociados con un pin determinado de la FPGA y alimentados con 3.3V
set_property PACKAGE_PIN U2 [get_ports {AN[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[0]}]
set_property PACKAGE_PIN U4 [get_ports {AN[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[1]}]
set_property PACKAGE_PIN V4 [get_ports {AN[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[2]}]
set_property PACKAGE_PIN W4 [get_ports {AN[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[3]}]

# ajustamos el voltaje de configuración a 3.3V y el voltaje del banco de configuración a Vcc
###########################################################
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
###########################################################

# ajustamos el voltaje de conexión con los botones a 3.3V
#set_property IOSTANDARD LVCMOS33 [get_ports {BTN[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {BTN[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {BTN[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {BTN[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RST}]
# configuramos los botones asociándolos a los pines del FPGA
# BTNL:
#set_property PACKAGE_PIN W19 [get_ports {rst}]
# BTNC:
set_property PACKAGE_PIN U18 [get_ports {RST}]
# BTND:
#set_property PACKAGE_PIN U17 [get_ports {BTN[3]}]
# BTNU:
#set_property PACKAGE_PIN T18 [get_ports {BTN[1]}]
# BTNR:
#set_property PACKAGE_PIN T17 [get_ports {BTN[2]}]


##Pmod Header JA
##Sch name = JA1
set_property PACKAGE_PIN J1 [get_ports {DATA_CAM[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DATA_CAM[6]}]
##Sch name = JA2
set_property PACKAGE_PIN L2 [get_ports {XCLK}]
set_property IOSTANDARD LVCMOS33 [get_ports {XCLK}]
##Sch name = JA3
set_property PACKAGE_PIN J2 [get_ports {HREF}]
set_property IOSTANDARD LVCMOS33 [get_ports {HREF}]
##Sch name = JA4
#set_property PACKAGE_PIN G2 [get_ports {JA[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JA[3]}]
##Sch name = JA7
set_property PACKAGE_PIN H1 [get_ports {PCLK}]
set_property IOSTANDARD LVCMOS33 [get_ports {PCLK}]
##Sch name = JA8
set_property PACKAGE_PIN K2 [get_ports {DATA_CAM[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DATA_CAM[7]}]
##Sch name = JA9
set_property PACKAGE_PIN H2 [get_ports {VSYNC}]
set_property IOSTANDARD LVCMOS33 [get_ports {VSYNC}]
##Sch name = JA10
#set_property PACKAGE_PIN G3 [get_ports {JA[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JA[7]}]


##Pmod Header JB
##Sch name = JB1
set_property PACKAGE_PIN A14 [get_ports {DATA_IO[0]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {DATA_IO[0]}]
##Sch name = JB2
set_property PACKAGE_PIN A16 [get_ports {DATA_IO[2]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {DATA_IO[2]}]
##Sch name = JB3
set_property PACKAGE_PIN B15 [get_ports {DATA_IO[4]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {DATA_IO[4]}]
##Sch name = JB4
set_property PACKAGE_PIN B16 [get_ports {DATA_IO[6]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {DATA_IO[6]}]
##Sch name = JB7
set_property PACKAGE_PIN A15 [get_ports {DATA_IO[1]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {DATA_IO[1]}]
##Sch name = JB8
set_property PACKAGE_PIN A17 [get_ports {DATA_IO[3]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {DATA_IO[3]}]
##Sch name = JB9
set_property PACKAGE_PIN C15 [get_ports {DATA_IO[5]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {DATA_IO[5]}]
##Sch name = JB10 
set_property PACKAGE_PIN C16 [get_ports {DATA_IO[7]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {DATA_IO[7]}]
 
 
##Pmod Header JC

###Sch name = JC1
set_property PACKAGE_PIN K17 [get_ports {RXFn}]
set_property IOSTANDARD LVCMOS33 [get_ports {RXFn}]

###Sch name = JC2
set_property PACKAGE_PIN M18 [get_ports {RDn}]
set_property IOSTANDARD LVCMOS33 [get_ports {RDn}]

###Sch name = JC3
set_property PACKAGE_PIN N17 [get_ports {SIWUn}]
set_property IOSTANDARD LVCMOS33 [get_ports {SIWUn}]

###Sch name = JC4
#set_property PACKAGE_PIN P18 [get_ports {OEn}]
#set_property IOSTANDARD LVCMOS33 [get_ports {OEn}]

##Sch name = JC7
set_property PACKAGE_PIN L17 [get_ports {TXEn}]
set_property IOSTANDARD LVCMOS33 [get_ports {TXEn}]

##Sch name = JC8
set_property PACKAGE_PIN M19 [get_ports {WRn}]
set_property IOSTANDARD LVCMOS33 [get_ports {WRn}]

###Sch name = JC9
#set_property PACKAGE_PIN P17 [get_ports {CLKOUT}]
#set_property IOSTANDARD LVCMOS33 [get_ports {CLKOUT}]

###Sch name = JC10
set_property PACKAGE_PIN R18 [get_ports {PWRSAVn}]
set_property IOSTANDARD LVCMOS33 [get_ports {PWRSAVn}]




##Pmod Header JC
##Sch name = JC1
##set_property PACKAGE_PIN K17 [get_ports {RXFn}]					
##set_property IOSTANDARD LVCMOS33 [get_ports {RXFn}]
##Sch name = JC2
##set_property PACKAGE_PIN M18 [get_ports {TXEn}]					
##set_property IOSTANDARD LVCMOS33 [get_ports {TXEn}]
##Sch name = JC3
##set_property PACKAGE_PIN N17 [get_ports {RDn}]					
##set_property IOSTANDARD LVCMOS33 [get_ports {RDn}]
##Sch name = JC4
##set_property PACKAGE_PIN P18 [get_ports {WRn}]					
##set_property IOSTANDARD LVCMOS33 [get_ports {WRn}]

##Sch name = JC7
#set_property PACKAGE_PIN L17 [get_ports {RXFn}]					
#set_property IOSTANDARD LVCMOS33 [get_ports {RXFn}]
##Sch name = JC8
#set_property PACKAGE_PIN M19 [get_ports {TXEn}]					
#set_property IOSTANDARD LVCMOS33 [get_ports {TXEn}]
##Sch name = JC9
#set_property PACKAGE_PIN P17 [get_ports {RDn}]					
#set_property IOSTANDARD LVCMOS33 [get_ports {RDn}]
##Sch name = JC10
#set_property PACKAGE_PIN R18 [get_ports {WRn}]					
#set_property IOSTANDARD LVCMOS33 [get_ports {WRn}]


##Pmod Header JXADC
##Sch name = XA1_P
set_property PACKAGE_PIN J3 [get_ports {resetc}]				
set_property IOSTANDARD LVCMOS33 [get_ports {resetc}]
##Sch name = XA2_P
set_property PACKAGE_PIN L3 [get_ports {DATA_CAM[0]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {DATA_CAM[0]}]
##Sch name = XA3_P
set_property PACKAGE_PIN M2 [get_ports {DATA_CAM[2]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {DATA_CAM[2]}]
##Sch name = XA4_P
set_property PACKAGE_PIN N2 [get_ports {DATA_CAM[4]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {DATA_CAM[4]}]
##Sch name = XA1_N
#set_property PACKAGE_PIN K3 [get_ports {JXADC[4]}]				
#set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[4]}]
##Sch name = XA2_N
set_property PACKAGE_PIN M3 [get_ports {DATA_CAM[1]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {DATA_CAM[1]}]
##Sch name = XA3_N
set_property PACKAGE_PIN M1 [get_ports {DATA_CAM[3]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {DATA_CAM[3]}]
##Sch name = XA4_N
set_property PACKAGE_PIN N1 [get_ports {DATA_CAM[5]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {DATA_CAM[5]}]


# Reloj:
set_property PACKAGE_PIN W5 [get_ports CLK]
set_property IOSTANDARD LVCMOS33 [get_ports CLK]

create_clock -period 10.000 -name CLK_PORT -waveform {0.000 5.000} -add [get_ports CLK]
