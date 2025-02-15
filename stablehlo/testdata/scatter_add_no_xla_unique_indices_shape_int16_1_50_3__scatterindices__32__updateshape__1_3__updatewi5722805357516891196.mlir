// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<32> : tensor<1xi32>
    %1:2 = call @inputs() : () -> (tensor<1x50x3xi16>, tensor<1x3xi16>)
    %2 = call @expected() : () -> tensor<1x50x3xi16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i16>, %arg1: tensor<i16>):
      %5 = stablehlo.add %arg0, %arg1 : tensor<i16>
      stablehlo.return %5 : tensor<i16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1]>, unique_indices = true} : (tensor<1x50x3xi16>, tensor<1xi32>, tensor<1x3xi16>) -> tensor<1x50x3xi16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1x50x3xi16>, tensor<1x50x3xi16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x50x3xi16>, tensor<1x3xi16>) {
    %0 = stablehlo.constant dense<"0x0200FFFF00000000FEFF0300FEFF0000000000000000FDFFFEFFFDFFFEFFFDFFFAFFFEFF00000000FEFF0000FFFF000005000100FEFFFDFF01000300FFFF00000000FFFF01000500FDFFFFFF0300020005000000FDFFFDFFFEFF010006000100FCFFFAFF000000000400FEFF00000200020002000000FEFF0000FEFF010000000200FDFF0100FCFFFEFF020000000000FDFF0000FDFF0000FDFF0100FAFF00000000FCFFFEFFFCFF030003000600FFFF020004000300010001000100FEFFFEFF0300FFFFFEFF0100FFFFFDFF00000200FEFFFFFF040000000500FBFFFFFF0000FDFFFEFF000002000100F7FFFEFF00000800FDFF0000FFFF0300FEFF020004000000FEFF00000400FFFF000003000300FFFF0000FEFFFEFFFDFF00000200FFFF000001000000FFFF0800FEFF"> : tensor<1x50x3xi16>
    %1 = stablehlo.constant dense<[[-1, 0, -8]]> : tensor<1x3xi16>
    return %0, %1 : tensor<1x50x3xi16>, tensor<1x3xi16>
  }
  func.func private @expected() -> tensor<1x50x3xi16> {
    %0 = stablehlo.constant dense<"0x0200FFFF00000000FEFF0300FEFF0000000000000000FDFFFEFFFDFFFEFFFDFFFAFFFEFF00000000FEFF0000FFFF000005000100FEFFFDFF01000300FFFF00000000FFFF01000500FDFFFFFF0300020005000000FDFFFDFFFEFF010006000100FCFFFAFF000000000400FEFF00000200020002000000FEFF0000FEFF010000000200FDFF0100FCFFFEFF020000000000FDFF0000FDFF0000FDFF0100FAFF00000000FCFFFEFFFCFF030003000600FFFF020004000300010001000100FEFFFEFF0200FFFFF6FF0100FFFFFDFF00000200FEFFFFFF040000000500FBFFFFFF0000FDFFFEFF000002000100F7FFFEFF00000800FDFF0000FFFF0300FEFF020004000000FEFF00000400FFFF000003000300FFFF0000FEFFFEFFFDFF00000200FFFF000001000000FFFF0800FEFF"> : tensor<1x50x3xi16>
    return %0 : tensor<1x50x3xi16>
  }
}

