// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<2x3xui32>, tensor<ui32>)
    %1 = call @expected() : () -> tensor<2x0xui32>
    %2 = stablehlo.pad %0#0, %0#1, low = [0, -2], high = [0, -3], interior = [0, 1] : (tensor<2x3xui32>, tensor<ui32>) -> tensor<2x0xui32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<2x0xui32>, tensor<2x0xui32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<2x3xui32>, tensor<ui32>) {
    %0 = stablehlo.constant dense<0> : tensor<2x3xui32>
    %1 = stablehlo.constant dense<0> : tensor<ui32>
    return %0, %1 : tensor<2x3xui32>, tensor<ui32>
  }
  func.func private @expected() -> tensor<2x0xui32> {
    %0 = stablehlo.constant dense<> : tensor<2x0xui32>
    return %0 : tensor<2x0xui32>
  }
}
