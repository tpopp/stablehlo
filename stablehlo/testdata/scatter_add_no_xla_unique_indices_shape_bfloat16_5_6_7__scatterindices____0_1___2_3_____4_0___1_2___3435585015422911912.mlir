// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0, 1], [2, 3]], [[4, 0], [1, 2]]]> : tensor<2x2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xbf16>, tensor<5x2x2xbf16>)
    %2 = call @expected() : () -> tensor<5x6x7xbf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<bf16>, %arg1: tensor<bf16>):
      %5 = stablehlo.add %arg0, %arg1 : tensor<bf16>
      stablehlo.return %5 : tensor<bf16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xbf16>, tensor<2x2x2xi32>, tensor<5x2x2xbf16>) -> tensor<5x6x7xbf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xbf16>, tensor<5x6x7xbf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xbf16>, tensor<5x2x2xbf16>) {
    %0 = stablehlo.constant dense<"0x4B40BB3F4740EB3E7FBF02409DBE67C09DC0CD405F404C3FCBBE53BFB84035BEF03E0ABF86C048C09540C53E9ABFADC09EC0A5C088BF1BBF15C09BC0F1BF374034C057C01C4012C05B3F07C08EBFE3BF1440E63E88BF97C0C23FFA3FE13F95407CC0A1C01DC00340E14002401DC07ABFBF3D57BEDABE8D40903E87BF8AC04B3F30BEC03FDEBFE2BE0640C0BF7340523FACBF99404840713F8140F2401C4040C0FC3FBBBF493E87BFE33F663F0B40F2BCACC0A9C0ABC0ECBFE8405A401BBF793F8A400E3F5EC0DDBF88C037C091BF9F3F71C06D3F8B3F3C40A5401440C8BF28404D4035C05CC01A409B3E2CC0BC3EF13FDE3F4E3FC93E724034C0193F0D3F0840E6C02B3E6A3E5840623F2E409140ACC0E8BF6240A8BE2BC0E2BF81BFC3BED73F4FC0B540BC40E23F1B3F97BFBCBFB2BF0D406540B7C0C8C0953F2440B440033F1C3F04400BBF98BF0FC032C05940084075C05EC083BFA1C074C0DF3F3A401C40C84001BEF73E13C01B4042C07B403040214091C0BE40044120C030C0BD3F18409E3EFD3EB6C0BBBDEB3F0DC0753F2140D33FAC3E803E04402BC0E63F8E40983F3240EFBF"> : tensor<5x6x7xbf16>
    %1 = stablehlo.constant dense<[[[2.140630e+00, 1.320310e+00], [6.054690e-01, 1.484380e+00]], [[2.500000e+00, 5.750000e+00], [-9.437500e+00, 1.679690e+00]], [[-2.656250e-01, 2.203130e+00], [-1.242190e+00, -3.234380e+00]], [[6.484380e-01, 1.507810e+00], [-8.671870e-01, 3.625000e+00]], [[-4.570310e-01, -2.531250e+00], [-4.648440e-01, 4.093750e+00]]]> : tensor<5x2x2xbf16>
    return %0, %1 : tensor<5x6x7xbf16>, tensor<5x2x2xbf16>
  }
  func.func private @expected() -> tensor<5x6x7xbf16> {
    %0 = stablehlo.constant dense<"0x4B4066404740EB3E7FBF02409DBE67C09DC0FC405F404C3FCBBE53BFB84035BEF03E483F86C048C09540C53E9ABFADC09EC0A5C088BF1BBFDCBF9BC0F1BF374034C057C01C4012C05B3F07C08EBFE3BF1440E63E88BF0EC0C23FFA3FE13F95407CC0A1C01DC06E40E14002401DC07ABFBF3D57BEDABE2241903E87BF8AC04B3F30BEC03FDEBFE2BE0640C0BFB4C0523FACBF99404840713F8140F2401C4040C0FC3FBBBF493E87BFE33F223F0B40F2BCACC0A9C0ABC0ECBFE840303E1BBF793F8A400E3F5EC0DDBF88C028BF91BF9F3F71C06D3F8B3F3C40A5401440C8BF2840FB3F35C05CC01A409B3E2CC0BC3EF13FDE3F4E3FC93E724034C0193F0D3F3240E6C02B3E6A3E5840623F2E409140E0BFE8BF6240A8BE2BC0E2BF81BFC3BE4C404FC0B540BC40E23F1B3F97BFBCBFB2BF0D406540D3C0C8C0953F2440B440033F1C3F04400BBF98BF0FC032C05940084075C07BC083BFA1C074C0DF3F3A401C40C8407E40F73E13C01B4042C07B4030402140E2C0BE40044120C030C0BD3F18409E3EFD3EB6C0BBBDB03F0DC0753F2140D33FAC3E803E04402BC0E63F8E40983F3240EFBF"> : tensor<5x6x7xbf16>
    return %0 : tensor<5x6x7xbf16>
  }
}

