// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<1x3x4xi16>, tensor<1x4x3xi16>)
    %1 = call @expected() : () -> tensor<1xi16>
    %2 = "stablehlo.dot_general"(%0#0, %0#1) {dot_dimension_numbers = #stablehlo.dot<lhs_batching_dimensions = [0], rhs_batching_dimensions = [0], lhs_contracting_dimensions = [2, 1], rhs_contracting_dimensions = [1, 2]>} : (tensor<1x3x4xi16>, tensor<1x4x3xi16>) -> tensor<1xi16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<1xi16>, tensor<1xi16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x3x4xi16>, tensor<1x4x3xi16>) {
    %0 = stablehlo.constant dense<[[[2, -3, 0, 6], [0, -1, 3, 3], [-1, -9, 3, 0]]]> : tensor<1x3x4xi16>
    %1 = stablehlo.constant dense<[[[-1, 1, 0], [4, 1, 0], [-5, 1, 3], [0, -2, 0]]]> : tensor<1x4x3xi16>
    return %0, %1 : tensor<1x3x4xi16>, tensor<1x4x3xi16>
  }
  func.func private @expected() -> tensor<1xi16> {
    %0 = stablehlo.constant dense<-9> : tensor<1xi16>
    return %0 : tensor<1xi16>
  }
}

