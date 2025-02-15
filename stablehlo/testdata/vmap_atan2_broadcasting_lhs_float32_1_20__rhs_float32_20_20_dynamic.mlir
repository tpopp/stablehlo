// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_fun_flat_jax {
  func.func public @main(%arg0: tensor<i64>, %arg1: tensor<?x1x20xf32> {mhlo.sharding = ""}, %arg2: tensor<?x20x20xf32> {mhlo.sharding = ""}) -> tensor<?x20x20xf32> {
    %0 = stablehlo.convert %arg0 : (tensor<i64>) -> tensor<i32>
    %1 = stablehlo.reshape %0 : (tensor<i32>) -> tensor<1xi32>
    %2 = stablehlo.constant dense<20> : tensor<1xi32>
    %3 = stablehlo.constant dense<20> : tensor<1xi32>
    %4 = stablehlo.concatenate %1, %2, %3, dim = 0 : (tensor<1xi32>, tensor<1xi32>, tensor<1xi32>) -> tensor<3xi32>
    %5 = stablehlo.dynamic_broadcast_in_dim %arg1, %4, dims = [0, 1, 2] : (tensor<?x1x20xf32>, tensor<3xi32>) -> tensor<?x20x20xf32>
    %6 = stablehlo.atan2 %5, %arg2 : tensor<?x20x20xf32>
    return %6 : tensor<?x20x20xf32>
  }
}

