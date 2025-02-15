// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<32> : tensor<1xi32>
    %1:2 = call @inputs() : () -> (tensor<1x50x3xi32>, tensor<1x3xi32>)
    %2 = call @expected() : () -> tensor<1x50x3xi32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<i32>
      stablehlo.return %5 : tensor<i32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1]>, unique_indices = true} : (tensor<1x50x3xi32>, tensor<1xi32>, tensor<1x3xi32>) -> tensor<1x50x3xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1x50x3xi32>, tensor<1x50x3xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x50x3xi32>, tensor<1x3xi32>) {
    %0 = stablehlo.constant dense<"0x00000000000000000300000002000000F8FFFFFF00000000010000000000000005000000000000000400000002000000F9FFFFFF01000000020000000000000002000000FEFFFFFF0200000001000000FCFFFFFF0000000001000000FEFFFFFFFEFFFFFF040000000300000001000000040000000000000000000000FFFFFFFF0100000005000000FCFFFFFFFFFFFFFF03000000FDFFFFFFFFFFFFFFFEFFFFFF030000000000000000000000FDFFFFFFFFFFFFFF000000000600000001000000FBFFFFFF00000000FDFFFFFF010000000100000000000000000000000500000003000000FFFFFFFF00000000FFFFFFFF030000000000000003000000FEFFFFFF0100000001000000FFFFFFFFFAFFFFFF02000000FBFFFFFF0400000000000000FEFFFFFF010000000200000002000000FCFFFFFFFCFFFFFFFDFFFFFF02000000FFFFFFFFFEFFFFFF04000000FCFFFFFF00000000FFFFFFFFFEFFFFFF00000000FEFFFFFF0000000000000000FBFFFFFF01000000030000000100000003000000020000000500000000000000FBFFFFFF0000000001000000FFFFFFFFFDFFFFFFFEFFFFFFFEFFFFFF0000000003000000000000000100000001000000FFFFFFFF00000000FFFFFFFFFEFFFFFFFCFFFFFF010000000400000003000000FBFFFFFF02000000FAFFFFFFFCFFFFFF00000000FDFFFFFF010000000200000000000000FDFFFFFF000000000500000004000000FEFFFFFF020000000000000003000000FFFFFFFF00000000FDFFFFFF0000000001000000FDFFFFFF01000000FDFFFFFFFBFFFFFF010000000000000002000000FFFFFFFF03000000"> : tensor<1x50x3xi32>
    %1 = stablehlo.constant dense<[[0, 0, 1]]> : tensor<1x3xi32>
    return %0, %1 : tensor<1x50x3xi32>, tensor<1x3xi32>
  }
  func.func private @expected() -> tensor<1x50x3xi32> {
    %0 = stablehlo.constant dense<"0x00000000000000000300000002000000F8FFFFFF00000000010000000000000005000000000000000400000002000000F9FFFFFF01000000020000000000000002000000FEFFFFFF0200000001000000FCFFFFFF0000000001000000FEFFFFFFFEFFFFFF040000000300000001000000040000000000000000000000FFFFFFFF0100000005000000FCFFFFFFFFFFFFFF03000000FDFFFFFFFFFFFFFFFEFFFFFF030000000000000000000000FDFFFFFFFFFFFFFF000000000600000001000000FBFFFFFF00000000FDFFFFFF010000000100000000000000000000000500000003000000FFFFFFFF00000000FFFFFFFF030000000000000003000000FEFFFFFF0100000001000000FFFFFFFFFAFFFFFF02000000FBFFFFFF0400000000000000FEFFFFFF010000000200000002000000FCFFFFFFFCFFFFFFFDFFFFFF02000000FFFFFFFFFEFFFFFF04000000FCFFFFFF00000000FFFFFFFFFEFFFFFF00000000FEFFFFFF0000000000000000FBFFFFFF01000000030000000100000003000000020000000500000001000000FBFFFFFF0000000001000000FFFFFFFFFDFFFFFFFEFFFFFFFEFFFFFF0000000003000000000000000100000001000000FFFFFFFF00000000FFFFFFFFFEFFFFFFFCFFFFFF010000000400000003000000FBFFFFFF02000000FAFFFFFFFCFFFFFF00000000FDFFFFFF010000000200000000000000FDFFFFFF000000000500000004000000FEFFFFFF020000000000000003000000FFFFFFFF00000000FDFFFFFF0000000001000000FDFFFFFF01000000FDFFFFFFFBFFFFFF010000000000000002000000FFFFFFFF03000000"> : tensor<1x50x3xi32>
    return %0 : tensor<1x50x3xi32>
  }
}

