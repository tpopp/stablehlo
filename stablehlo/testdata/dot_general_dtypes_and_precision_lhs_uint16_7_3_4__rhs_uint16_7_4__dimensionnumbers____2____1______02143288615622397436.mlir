// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<7x3x4xui16>, tensor<7x4xui16>)
    %1 = call @expected() : () -> tensor<7x3xui16>
    %2 = "stablehlo.dot_general"(%0#0, %0#1) {dot_dimension_numbers = #stablehlo.dot<lhs_batching_dimensions = [0], rhs_batching_dimensions = [0], lhs_contracting_dimensions = [2], rhs_contracting_dimensions = [1]>} : (tensor<7x3x4xui16>, tensor<7x4xui16>) -> tensor<7x3xui16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<7x3xui16>, tensor<7x3xui16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<7x3x4xui16>, tensor<7x4xui16>) {
    %0 = stablehlo.constant dense<[[[2, 1, 5, 2], [4, 6, 2, 0], [3, 1, 2, 0]], [[0, 3, 1, 0], [2, 0, 3, 0], [4, 5, 3, 4]], [[1, 6, 3, 4], [1, 7, 0, 0], [4, 2, 1, 1]], [[3, 4, 3, 6], [0, 3, 1, 0], [1, 0, 3, 2]], [[2, 1, 7, 3], [8, 0, 3, 0], [0, 0, 4, 4]], [[0, 2, 0, 2], [2, 4, 1, 0], [2, 1, 1, 3]], [[4, 1, 3, 4], [4, 0, 0, 0], [1, 1, 8, 0]]]> : tensor<7x3x4xui16>
    %1 = stablehlo.constant dense<[[2, 0, 5, 2], [2, 2, 2, 1], [1, 2, 3, 0], [0, 0, 5, 1], [4, 3, 0, 1], [1, 1, 3, 1], [5, 2, 3, 3]]> : tensor<7x4xui16>
    return %0, %1 : tensor<7x3x4xui16>, tensor<7x4xui16>
  }
  func.func private @expected() -> tensor<7x3xui16> {
    %0 = stablehlo.constant dense<[[33, 18, 16], [8, 10, 28], [22, 15, 11], [21, 5, 17], [14, 32, 4], [4, 9, 9], [43, 20, 31]]> : tensor<7x3xui16>
    return %0 : tensor<7x3xui16>
  }
}

