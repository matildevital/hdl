###############################################################################
## Copyright (C) 2019-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# DAC FMC signals

set_property  -dict {PACKAGE_PIN  H18 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_p[0]]  ; ## D8  FMC_LPC_LA01_CC_P        IO_L16P_T2U_N6_QBC_AD3P_67
set_property  -dict {PACKAGE_PIN  H17 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_n[0]]  ; ## D9  FMC_LPC_LA01_CC_N        IO_L16N_T2U_N7_QBC_AD3N_67
set_property  -dict {PACKAGE_PIN  F17  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sysref_p]  ; ## G6  FMC_LPC_LA00_CC_P        IO_L13P_T2L_N0_GC_QBC_67
set_property  -dict {PACKAGE_PIN  F16  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sysref_n]  ; ## G7  FMC_LPC_LA00_CC_N        IO_L13N_T2L_N1_GC_QBC_67

set_property  -dict {PACKAGE_PIN  L16 IOSTANDARD LVCMOS18} [get_ports spi_csn_dac]                      ; ## H11  FMC_LPC_LA04_N          IO_L24N_T3U_N11_67
set_property  -dict {PACKAGE_PIN  K17 IOSTANDARD LVCMOS18} [get_ports spi_csn_clk]                      ; ## D11  FMC_LPC_LA05_P          IO_L21P_T3L_N4_AD8P_67
set_property  -dict {PACKAGE_PIN  L17 IOSTANDARD LVCMOS18} [get_ports spi_miso]                         ; ## H10  FMC_LPC_LA04_P          IO_L24P_T3U_N10_67
set_property  -dict {PACKAGE_PIN  K18  IOSTANDARD LVCMOS18} [get_ports spi_mosi]                        ; ## G10  FMC_LPC_LA03_N          IO_L23N_T3U_N9_67
set_property  -dict {PACKAGE_PIN  K19  IOSTANDARD LVCMOS18} [get_ports spi_clk]                         ; ## G9   FMC_LPC_LA03_P          IO_L23P_T3U_N8_67
set_property  -dict {PACKAGE_PIN  J17 IOSTANDARD LVCMOS18} [get_ports spi_en]                           ; ## D12  FMC_LPC_LA05_N          IO_L21N_T3L_N5_AD8N_67

# For AD9135-FMC-EBZ, AD9136-FMC-EBZ, AD9144-FMC-EBZ, AD9152-FMC-EBZ, AD9154-FMC-EBZ
set_property  -dict {PACKAGE_PIN  J16  IOSTANDARD LVCMOS18} [get_ports dac_ctrl[0]]                     ; ## H13  FMC_LPC_LA07_P          IO_L20P_T3L_N2_AD1P_67
set_property  -dict {PACKAGE_PIN  J15  IOSTANDARD LVCMOS18} [get_ports dac_ctrl[3]]                     ; ## H14  FMC_LPC_LA07_N          IO_L20N_T3L_N3_AD1N_67

# For AD9171-FMC-EBZ, AD9172-FMC-EBZ, AD9173-FMC-EBZ
set_property  -dict {PACKAGE_PIN  H19 IOSTANDARD LVCMOS18} [get_ports dac_ctrl[1]]                      ; ## C10  FMC_LPC_LA06_P          IO_L15P_T2L_N4_AD11P_67
set_property  -dict {PACKAGE_PIN  G19 IOSTANDARD LVCMOS18} [get_ports dac_ctrl[2]]                      ; ## C11  FMC_LPC_LA06_N          IO_L15N_T2L_N5_AD11N_67

set_property  -dict {PACKAGE_PIN  V8} [get_ports tx_ref_clk_p]                                          ; ## D4  FMC_LPC_GBTCLK0_M2C_C_P  MGTREFCLK0P_226
set_property  -dict {PACKAGE_PIN  V7} [get_ports tx_ref_clk_n]                                          ; ## D5  FMC_LPC_GBTCLK0_M2C_C_N  MGTREFCLK0N_226

set_property  -dict {PACKAGE_PIN  N6} [get_ports tx_data_p[0]]                                          ; ## C2  FMC_LPC_DP0_C2M_P        MGTHTXP3_226
set_property  -dict {PACKAGE_PIN  N5} [get_ports tx_data_n[0]]                                          ; ## C3  FMC_LPC_DP0_C2M_N        MGTHTXN3_226

# PL PMOD 1 header
set_property  -dict {PACKAGE_PIN  G8 IOSTANDARD LVCMOS33} [get_ports pmod_spi_clk]                     ; ## PMOD1_0                        IO_L8N_HDGC_AD4N_47_D20
set_property  -dict {PACKAGE_PIN  H8 IOSTANDARD LVCMOS33} [get_ports pmod_spi_csn]                     ; ## PMOD1_1                        IO_L8P_HDGC_AD4P_47_E20
set_property  -dict {PACKAGE_PIN  G7 IOSTANDARD LVCMOS33} [get_ports pmod_spi_mosi]                    ; ## PMOD1_2                        IO_L7N_HDGC_AD5N_47_D22
set_property  -dict {PACKAGE_PIN  H7 IOSTANDARD LVCMOS33} [get_ports pmod_spi_miso]                    ; ## PMOD1_3                        IO_L7P_HDGC_AD5P_47_E22
set_property  -dict {PACKAGE_PIN  G6 IOSTANDARD LVCMOS33} [get_ports pmod_gpio[0]]                     ; ## PMOD1_4                        IO_L6N_HDGC_AD6N_47_F20
set_property  -dict {PACKAGE_PIN  H6 IOSTANDARD LVCMOS33} [get_ports pmod_gpio[1]]                     ; ## PMOD1_5                        IO_L6P_HDGC_AD6P_47_G20
set_property  -dict {PACKAGE_PIN  J6 IOSTANDARD LVCMOS33} [get_ports pmod_gpio[2]]                     ; ## PMOD1_6                        IO_L4N_AD8N_47_J20
set_property  -dict {PACKAGE_PIN  J7 IOSTANDARD LVCMOS33} [get_ports pmod_gpio[3]]                     ; ## PMOD1_7                        IO_L4P_AD8P_47_J19

# clocks

# Max lane rate of 15.4 Gbps
create_clock -name tx_ref_clk   -period  5.000 [get_ports tx_ref_clk_p]

# Assumption is that REFCLK and SYSREF have similar propagation delay,
# and the SYSREF is a source synchronous Center-Aligned signal to REFCLK
set_input_delay -clock [get_clocks tx_ref_clk] \
  [expr [get_property  PERIOD [get_clocks tx_ref_clk]] / 2] \
  [get_ports {tx_sysref_*}]
