// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<1x2xf32>, tensor<3x2xf32>)
    %1 = call @expected() : () -> tensor<3x2xi1>
    %2 = stablehlo.broadcast_in_dim %0#0, dims = [0, 1] : (tensor<1x2xf32>) -> tensor<3x2xf32>
    %3 = stablehlo.compare  NE, %2, %0#1,  FLOAT : (tensor<3x2xf32>, tensor<3x2xf32>) -> tensor<3x2xi1>
    %4 = stablehlo.custom_call @check.eq(%3, %1) : (tensor<3x2xi1>, tensor<3x2xi1>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x2xf32>, tensor<3x2xf32>) {
    %0 = stablehlo.constant dense<[[-1.0598619, -2.24708295]]> : tensor<1x2xf32>
    %1 = stablehlo.constant dense<[[3.729070e-01, -6.29054164], [2.85044837, 1.81287277], [-2.00303841, 2.67510462]]> : tensor<3x2xf32>
    return %0, %1 : tensor<1x2xf32>, tensor<3x2xf32>
  }
  func.func private @expected() -> tensor<3x2xi1> {
    %0 = stablehlo.constant dense<true> : tensor<3x2xi1>
    return %0 : tensor<3x2xi1>
  }
}
