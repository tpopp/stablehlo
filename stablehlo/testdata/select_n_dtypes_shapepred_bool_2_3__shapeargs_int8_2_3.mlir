// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:3 = call @inputs() : () -> (tensor<2x3xi1>, tensor<2x3xi8>, tensor<2x3xi8>)
    %1 = call @expected() : () -> tensor<2x3xi8>
    %2 = stablehlo.select %0#0, %0#2, %0#1 : tensor<2x3xi1>, tensor<2x3xi8>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<2x3xi8>, tensor<2x3xi8>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<2x3xi1>, tensor<2x3xi8>, tensor<2x3xi8>) {
    %0 = stablehlo.constant dense<true> : tensor<2x3xi1>
    %1 = stablehlo.constant dense<[[0, 5, 1], [-3, -2, 4]]> : tensor<2x3xi8>
    %2 = stablehlo.constant dense<[[0, 0, -2], [4, 0, -1]]> : tensor<2x3xi8>
    return %0, %1, %2 : tensor<2x3xi1>, tensor<2x3xi8>, tensor<2x3xi8>
  }
  func.func private @expected() -> tensor<2x3xi8> {
    %0 = stablehlo.constant dense<[[0, 0, -2], [4, 0, -1]]> : tensor<2x3xi8>
    return %0 : tensor<2x3xi8>
  }
}
