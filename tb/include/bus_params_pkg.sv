// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

package bus_params_pkg;

  // Bus address width
  localparam int BUS_AW = 32;

  // Bus data width (must be a multiple of 8)
  localparam int BUS_DW = 32;

  // Bus data mask width (number of byte lanes)
  localparam int BUS_DBW = (BUS_DW >> 3);

  // Bus transfer size width (number of bits needed to select the number of bytes)
  localparam int BUS_SZW = $clog2($clog2(BUS_DBW) + 1);
  
  // Data Size
  localparam int BUS_DS = 3;

  // ID Width
  localparam int BUS_IDW = 4;

endpackage
