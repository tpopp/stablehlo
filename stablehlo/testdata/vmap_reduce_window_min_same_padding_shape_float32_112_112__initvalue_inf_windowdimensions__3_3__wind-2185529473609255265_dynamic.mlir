// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_fun_flat_jax {
  func.func public @main(%arg0: tensor<i64>, %arg1: tensor<?x112x112xf32> {mhlo.sharding = ""}) -> tensor<?x56x56xf32> {
    %0 = stablehlo.constant dense<0x7F800000> : tensor<f32>
    %1 = stablehlo.broadcast_in_dim %0, dims = [] : (tensor<f32>) -> tensor<f32>
    %2 = "stablehlo.reduce_window"(%arg1, %1) ({
    ^bb0(%arg2: tensor<f32>, %arg3: tensor<f32>):
      %3 = stablehlo.minimum %arg2, %arg3 : tensor<f32>
      stablehlo.return %3 : tensor<f32>
    }) {padding = dense<[[0, 0], [0, 1], [0, 1]]> : tensor<3x2xi64>, window_dimensions = dense<[1, 3, 3]> : tensor<3xi64>, window_strides = dense<[1, 2, 2]> : tensor<3xi64>} : (tensor<?x112x112xf32>, tensor<f32>) -> tensor<?x56x56xf32>
    return %2 : tensor<?x56x56xf32>
  }
}

