// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<7x3x4xi32>, tensor<7x4xi32>)
    %1 = call @expected() : () -> tensor<7x3xi32>
    %2 = "stablehlo.dot_general"(%0#0, %0#1) {dot_dimension_numbers = #stablehlo.dot<lhs_batching_dimensions = [0], rhs_batching_dimensions = [0], lhs_contracting_dimensions = [2], rhs_contracting_dimensions = [1]>, precision_config = [#stablehlo<precision HIGHEST>, #stablehlo<precision HIGHEST>]} : (tensor<7x3x4xi32>, tensor<7x4xi32>) -> tensor<7x3xi32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<7x3xi32>, tensor<7x3xi32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<7x3x4xi32>, tensor<7x4xi32>) {
    %0 = stablehlo.constant dense<[[[-3, -1, -9, -2], [2, 2, 0, 0], [2, 3, 2, 4]], [[-3, 0, 5, 3], [-1, 0, 2, 1], [-1, -8, -5, -6]], [[0, -2, -1, -5], [2, 0, 4, 0], [1, 0, 4, -4]], [[-4, -4, 0, 2], [0, 0, 0, 2], [0, 5, 2, 0]], [[2, 0, 1, -1], [5, -5, 0, -2], [1, -2, 3, 3]], [[-2, -1, 2, 8], [-1, 0, 0, -5], [3, -4, 1, 0]], [[5, -1, 0, -2], [-3, 3, 0, -3], [2, 0, 0, -1]]]> : tensor<7x3x4xi32>
    %1 = stablehlo.constant dense<[[0, 4, -1, -4], [-3, 0, 1, 1], [0, 1, 0, -2], [-5, -2, -3, 3], [0, 5, 3, 3], [1, -4, -3, 1], [0, 0, -2, 0]]> : tensor<7x4xi32>
    return %0, %1 : tensor<7x3x4xi32>, tensor<7x4xi32>
  }
  func.func private @expected() -> tensor<7x3xi32> {
    %0 = stablehlo.constant dense<[[13, 8, -6], [17, 6, -8], [8, 0, 8], [34, 6, -16], [0, -31, 8], [4, -6, 16], [0, 0, 0]]> : tensor<7x3xi32>
    return %0 : tensor<7x3xi32>
  }
}
