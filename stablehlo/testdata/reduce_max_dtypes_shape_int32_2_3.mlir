// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<2x3xi32>
    %1 = call @expected() : () -> tensor<3xi32>
    %2 = stablehlo.constant dense<-2147483648> : tensor<i32>
    %3 = stablehlo.reduce(%0 init: %2) across dimensions = [0] : (tensor<2x3xi32>, tensor<i32>) -> tensor<3xi32>
     reducer(%arg0: tensor<i32>, %arg1: tensor<i32>)  {
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<i32>
      stablehlo.return %5 : tensor<i32>
    }
    %4 = stablehlo.custom_call @check.eq(%3, %1) : (tensor<3xi32>, tensor<3xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> tensor<2x3xi32> {
    %0 = stablehlo.constant dense<[[0, -4, 2], [-1, 2, -1]]> : tensor<2x3xi32>
    return %0 : tensor<2x3xi32>
  }
  func.func private @expected() -> tensor<3xi32> {
    %0 = stablehlo.constant dense<[0, 2, 2]> : tensor<3xi32>
    return %0 : tensor<3xi32>
  }
}
