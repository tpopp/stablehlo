// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<3x4x5xi32>
    %1 = call @expected() : () -> tensor<3x4x5xi32>
    %2 = stablehlo.constant dense<0> : tensor<i32>
    %3 = stablehlo.broadcast_in_dim %2, dims = [] : (tensor<i32>) -> tensor<3x4x5xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %1) : (tensor<3x4x5xi32>, tensor<3x4x5xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> tensor<3x4x5xi32> {
    %0 = stablehlo.constant dense<[[[1, -1, 3, -2, 0], [1, 2, 0, -7, -3], [0, 0, 0, 1, -2], [2, 2, 5, -1, -2]], [[-1, -2, 1, -1, 1], [5, -1, -3, -1, 4], [0, 3, 3, 0, 0], [0, 0, 0, 2, 1]], [[-3, -5, 1, 0, 4], [1, 2, 3, 4, 1], [2, -4, 0, -2, -2], [7, 2, -1, -4, 1]]]> : tensor<3x4x5xi32>
    return %0 : tensor<3x4x5xi32>
  }
  func.func private @expected() -> tensor<3x4x5xi32> {
    %0 = stablehlo.constant dense<0> : tensor<3x4x5xi32>
    return %0 : tensor<3x4x5xi32>
  }
}
