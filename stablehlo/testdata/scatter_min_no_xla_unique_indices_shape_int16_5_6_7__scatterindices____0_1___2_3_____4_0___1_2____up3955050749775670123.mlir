// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0, 1], [2, 3]], [[4, 0], [1, 2]]]> : tensor<2x2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xi16>, tensor<5x2x2xi16>)
    %2 = call @expected() : () -> tensor<5x6x7xi16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i16>, %arg1: tensor<i16>):
      %5 = stablehlo.minimum %arg0, %arg1 : tensor<i16>
      stablehlo.return %5 : tensor<i16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xi16>, tensor<2x2x2xi32>, tensor<5x2x2xi16>) -> tensor<5x6x7xi16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xi16>, tensor<5x6x7xi16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xi16>, tensor<5x2x2xi16>) {
    %0 = stablehlo.constant dense<"0x02000400FEFF0000050005000200FEFFFCFFFBFF000003000100030004000000FDFFFEFFFBFF01000300FBFFFEFFFBFFFFFFFBFF000003000100FBFF0000000005000800FEFF01000100010003000300FFFFFDFF000003000000FEFF01000000FFFF01000600FDFF04000200FFFFFFFF00000000FEFF0000FFFF0200FFFF000001000800FDFF01000100FFFFFEFF00000000FCFFFDFF0300000005000000FBFFFFFFFFFF0000FDFF0100000001000100000000000500FFFF01000100FCFF0000FFFF0100010000000600010005000000FCFF00000000FDFF030001000000000001000000FBFFFFFFFFFF000001000000FFFFFFFF00000000FFFF0300FFFF0100FCFF00000000FEFF0300020002000200FCFF00000200FBFFFCFFFEFF000001000300FDFFFBFFFFFF020000000000000000000300FFFF000000000200FDFFFEFF01000100000000000300010000000300FFFFFFFF04000000050001000200FEFFFFFF0000FFFFFDFF000000000200FFFFFCFFFCFF05000200020000000200FDFF0000010005000400FFFF0100030004000100FEFFFEFF01000300FEFFFFFFFEFFFEFF0200"> : tensor<5x6x7xi16>
    %1 = stablehlo.constant dense<[[[0, 2], [-1, 0]], [[-6, 0], [-2, 3]], [[5, 0], [1, -1]], [[5, 2], [2, 0]], [[-1, 0], [2, -2]]]> : tensor<5x2x2xi16>
    return %0, %1 : tensor<5x6x7xi16>, tensor<5x2x2xi16>
  }
  func.func private @expected() -> tensor<5x6x7xi16> {
    %0 = stablehlo.constant dense<"0x02000000FEFF0000050005000200FEFFFCFFFBFF000003000100030004000000FDFFFEFFFBFF01000300FBFFFEFFFBFFFFFFFBFF00000300FFFFFBFF0000000005000800FEFF01000100010003000300FFFFFDFF0000FAFF0000FEFF01000000FFFF01000600FDFF04000200FFFFFFFF00000000FEFF0000FFFF0200FFFF000001000800FDFF01000100FFFFFEFF00000000FCFFFDFF0300000005000000FBFFFFFFFFFF0000FDFF0100000001000100000000000500FFFF0100FFFFFCFF0000FFFF0100010000000600000005000000FCFF00000000FDFF030001000000000001000000FBFFFFFFFFFF000001000000FFFFFFFF00000000FFFF0300FFFF0100FCFF00000000FEFF0300020002000000FCFF00000200FBFFFCFFFEFF000001000300FDFFFBFFFFFF020000000000000000000300FFFF000000000200FDFFFEFF01000100000000000300010000000300FFFFFFFF04000000050001000200FEFFFFFFFEFFFFFFFDFF000000000200FFFFFCFFFCFF05000200020000000200FDFF0000010005000400FFFF0100030004000100FEFFFEFF01000300FEFFFFFFFEFFFEFF0200"> : tensor<5x6x7xi16>
    return %0 : tensor<5x6x7xi16>
  }
}

