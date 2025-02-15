// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_fun_flat_jax {
  func.func public @main(%arg0: tensor<i64>, %arg1: tensor<?x5x6x7xf32> {mhlo.sharding = ""}, %arg2: tensor<?x5x2x2xf32> {mhlo.sharding = ""}) -> tensor<?x5x6x7xf32> {
    %0 = stablehlo.constant dense<[[[0, 1], [2, 3]], [[4, 0], [1, 2]]]> : tensor<2x2x2xi64>
    %1 = "stablehlo.scatter"(%arg1, %0, %arg2) ({
    ^bb0(%arg3: tensor<f32>, %arg4: tensor<f32>):
      stablehlo.return %arg4 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [2, 3], scatter_dims_to_operand_dims = [2, 3], index_vector_dim = 2>, unique_indices = true} : (tensor<?x5x6x7xf32>, tensor<2x2x2xi64>, tensor<?x5x2x2xf32>) -> tensor<?x5x6x7xf32>
    return %1 : tensor<?x5x6x7xf32>
  }
}

