// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_fun_flat_jax {
  func.func public @main(%arg0: tensor<i64>, %arg1: tensor<?x20x30xbf16> {mhlo.sharding = ""}) -> tensor<?x20x30xbf16> {
    %0 = stablehlo.multiply %arg1, %arg1 : tensor<?x20x30xbf16>
    %1 = stablehlo.multiply %arg1, %0 : tensor<?x20x30xbf16>
    %2 = stablehlo.constant dense<1.000000e+00> : tensor<bf16>
    %3 = stablehlo.convert %arg0 : (tensor<i64>) -> tensor<i32>
    %4 = stablehlo.reshape %3 : (tensor<i32>) -> tensor<1xi32>
    %5 = stablehlo.constant dense<20> : tensor<1xi32>
    %6 = stablehlo.constant dense<30> : tensor<1xi32>
    %7 = stablehlo.concatenate %4, %5, %6, dim = 0 : (tensor<1xi32>, tensor<1xi32>, tensor<1xi32>) -> tensor<3xi32>
    %8 = stablehlo.dynamic_broadcast_in_dim %2, %7, dims = [] : (tensor<bf16>, tensor<3xi32>) -> tensor<?x20x30xbf16>
    %9 = stablehlo.divide %8, %1 : tensor<?x20x30xbf16>
    return %9 : tensor<?x20x30xbf16>
  }
}

