// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<3xi32>, tensor<3x6xi32>)
    %1 = call @expected() : () -> tensor<6xi32>
    %2 = "stablehlo.dot_general"(%0#0, %0#1) {dot_dimension_numbers = #stablehlo.dot<lhs_contracting_dimensions = [0], rhs_contracting_dimensions = [0]>} : (tensor<3xi32>, tensor<3x6xi32>) -> tensor<6xi32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<6xi32>, tensor<6xi32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3xi32>, tensor<3x6xi32>) {
    %0 = stablehlo.constant dense<[2, -5, 0]> : tensor<3xi32>
    %1 = stablehlo.constant dense<[[-1, 1, -3, 4, 2, 2], [-5, -4, 0, -3, -1, 0], [0, 0, -1, 0, 1, 0]]> : tensor<3x6xi32>
    return %0, %1 : tensor<3xi32>, tensor<3x6xi32>
  }
  func.func private @expected() -> tensor<6xi32> {
    %0 = stablehlo.constant dense<[23, 22, -6, 23, 9, 4]> : tensor<6xi32>
    return %0 : tensor<6xi32>
  }
}

