// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2019-2025 Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

/*
Interface to FMC connector overview

system_top    FMC_EBZ         FMC                            FPGA
              -------------|--------------------------------|-------------------------------------
tx_ref_clk_n  BR40_N          D5  FMC_LPC_GBTCLK0_M2C_C_N    V7     MGTREFCLK0N_226
tx_ref_clk_p  BR40_P          D4  FMC_LPC_GBTCLK0_M2C_C_P    V8     MGTREFCLK0P_226
spi_csn_dac   FMC_CS1         H11  FMC_LPC_LA04_N            L16    IO_L24N_T3U_N11_67
spi_csn_clk   FMC_CS2         D11  FMC_LPC_LA05_P            K17    IO_L21P_T3L_N4_AD8P_67
spi_miso      FMC_MISO        H10  FMC_LPC_LA04_P            L17    IO_L24P_T3U_N10_67
spi_mosi      FMC_MOSI        G10  FMC_LPC_LA03_N            K18    IO_L23N_T3U_N9_67
spi_clk       FMC_SCK         G9   FMC_LPC_LA03_P            K19    IO_L23P_T3U_N8_67
spi_en        FMC_SPI_EN      D12  FMC_LPC_LA05_N            J17    IO_L21N_T3L_N5_AD8N_67

pe_ctrl       FMC_PE_CTRL     H13  FMC_LPC_LA07_P            J16    IO_L20P_T3L_N2_AD1P_67
txen[0]       FMC_TXEN_0      C10  FMC_LPC_LA06_P            H19    IO_L15P_T2L_N4_AD11P_67
txen[1]       FMC_TXEN_1      C11  FMC_LPC_LA06_N            G19    IO_L15N_T2L_N5_AD11N_67

tx_data_p[0]  SERDIN7_P       C2   FMC_LPC_DP0_C2M_P         N6     MGTHTXP3_226
tx_data_n[0]  SERDIN7_N       C3   FMC_LPC_DP0_C2M_N         N5     MGTHTXN3_226
tx_sync_p[0]  SYNC0_P         D8   FMC_LPC_LA01_CC_P         H18    IO_L16P_T2U_N6_QBC_AD3P_67
tx_sync_n[0]  SYNC0_N         D9   FMC_LPC_LA01_CC_N         H17    IO_L16N_T2U_N7_QBC_AD3N_67
tx_sysref_n   SYSREF2_N       G7   FMC_LPC_LA00_CC_N         F16    IO_L13N_T2L_N1_GC_QBC_67
tx_sysref_p   SYSREF2_P       G6   FMC_LPC_LA00_CC_P         F17    IO_L13P_T2L_N0_GC_QBC_67
*/

module system_top #(
  parameter NUM_LINKS = 1,
  parameter DEVICE_CODE = 0
) (
  input   [ 7:0]  gpio_bd_i, /* 8 switches/buttons */
  output  [ 3:0]  gpio_bd_o, /* 4 LEDS */

  input           tx_ref_clk_p,
  input           tx_ref_clk_n,
  input           tx_sysref_p,
  input           tx_sysref_n,
  input   [ 0:0]  tx_sync_p,
  input   [ 0:0]  tx_sync_n,
  output  [ 0:0]  tx_data_p,
  output  [ 0:0]  tx_data_n,

  output          spi_csn_dac,
  output          spi_csn_clk,
  input           spi_miso,
  output          spi_mosi,
  output          spi_clk,
  output          spi_en,

  inout   [ 3:0]  dac_ctrl,

  output          pmod_spi_clk,
  output          pmod_spi_csn,
  output          pmod_spi_mosi,
  input           pmod_spi_miso,
  inout   [ 3:0]  pmod_gpio
);

  // internal signals

  wire    [94:0]  gpio_i;
  wire    [94:0]  gpio_o;
  wire    [94:0]  gpio_t;
  wire    [ 2:0]  spi0_csn;
  wire    [ 2:0]  spi1_csn;
  wire            tx_ref_clk;
  wire            tx_sysref;
  wire    [ 0:0]  tx_sync;
  // spi

  // spi_en is active ...
  //   ... high for AD9135-FMC-EBZ, AD9136-FMC-EBZ, AD9144-FMC-EBZ,
  //   ... low for AD9171-FMC-EBZ, AD9172-FMC-EBZ, AD9173-FMC-EBZ
  // If you are planning to build a bitstream for just one of those boards you
  // can hardwire the logic level here.
  //
  assign spi_en = (DEVICE_CODE <= 2);

  //                                        9135/9144/9172
  assign spi_csn_dac  = spi0_csn[1];
  assign spi_csn_clk  = spi0_csn[0];    //   HMC7044

  /* JESD204 clocks and control signals */
  IBUFDS_GTE4 i_ibufds_tx_ref_clk (
    .CEB (1'd0),
    .I (tx_ref_clk_p),
    .IB (tx_ref_clk_n),
    .O (tx_ref_clk),
    .ODIV2 ());

  IBUFDS i_ibufds_tx_sysref (
    .I (tx_sysref_p),
    .IB (tx_sysref_n),
    .O (tx_sysref));

  IBUFDS i_ibufds_tx_sync_0 (
    .I (tx_sync_p[0]),
    .IB (tx_sync_n[0]),
    .O (tx_sync[0]));

  /* FMC GPIOs */
  ad_iobuf #(
    .DATA_WIDTH(4)
  ) i_iobuf (
    .dio_t (gpio_t[21+:4]),
    .dio_i (gpio_o[21+:4]),
    .dio_o (gpio_i[21+:4]),
    .dio_p ({
      dac_ctrl           /* 24 - 21 */
    }));

  /*
  * Control signals for different FMC boards:
  *
  * dac_ctrl  FMC   9144 like    9172 like
  *        0  H13   FMC_TXEN_0   FMC_PE_CTRL
  *        1  C10   NC           FMC_TXEN_0
  *        2  C11   NC           FMC_TXEN_1
  *        3  H14   FMC_TXEN_1   NC
  */

  /* PMOD GPIOs 48-51 */
  ad_iobuf #(
    .DATA_WIDTH(4)
  ) i_iobuf_pmod (
    .dio_t (gpio_t[48+:4]),
    .dio_i (gpio_o[48+:4]),
    .dio_o (gpio_i[48+:4]),
    .dio_p (pmod_gpio));

  /* PMOD SPI */
  assign pmod_spi_csn = spi1_csn[0];

  /* Board GPIOS. Buttons, LEDs, etc... */
  assign gpio_i[15: 8] = gpio_bd_i;  /* modifyied here */
  assign gpio_bd_o = gpio_o[3:0];

  assign gpio_i[94:52] = gpio_o[94:52];
  assign gpio_i[47:32] = gpio_o[47:32];
  assign gpio_i[31:26] = gpio_o[31:26];
  assign gpio_i[ 7: 0] = gpio_o[7:0];

  system_wrapper i_system_wrapper (
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
    .spi0_csn (spi0_csn),
    .spi0_miso (spi_miso),
    .spi0_mosi (spi_mosi),
    .spi0_sclk (spi_clk),
    .spi1_csn (spi1_csn),
    .spi1_miso (pmod_spi_miso),
    .spi1_mosi (pmod_spi_mosi),
    .spi1_sclk (pmod_spi_clk),
    .tx_data_0_n (tx_data_n[0]),
    .tx_data_0_p (tx_data_p[0]),
    .tx_ref_clk_0 (tx_ref_clk),
    .tx_sync_0 (tx_sync[NUM_LINKS-1:0]),
    .tx_sysref_0 (tx_sysref));

endmodule
