// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<0> : tensor<1xi32>
    %1:2 = call @inputs() : () -> (tensor<1x2x3xf32>, tensor<2x3xf32>)
    %2 = call @expected() : () -> tensor<1x2x3xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %5 = stablehlo.add %arg0, %arg1 : tensor<f32>
      stablehlo.return %5 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [0], scatter_dims_to_operand_dims = [0]>, unique_indices = true} : (tensor<1x2x3xf32>, tensor<1xi32>, tensor<2x3xf32>) -> tensor<1x2x3xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1x2x3xf32>, tensor<1x2x3xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x2x3xf32>, tensor<2x3xf32>) {
    %0 = stablehlo.constant dense<[[[-3.96708488, 1.78402448, -2.79228497], [-2.64137268, 1.63564384, 0.921623051]]]> : tensor<1x2x3xf32>
    %1 = stablehlo.constant dense<[[4.73736572, 0.848282754, -0.381552637], [7.642620e-01, -1.61280513, -1.4992609]]> : tensor<2x3xf32>
    return %0, %1 : tensor<1x2x3xf32>, tensor<2x3xf32>
  }
  func.func private @expected() -> tensor<1x2x3xf32> {
    %0 = stablehlo.constant dense<[[[0.770280838, 2.63230729, -3.17383766], [-1.87711072, 0.0228387117, -0.577637851]]]> : tensor<1x2x3xf32>
    return %0 : tensor<1x2x3xf32>
  }
}

