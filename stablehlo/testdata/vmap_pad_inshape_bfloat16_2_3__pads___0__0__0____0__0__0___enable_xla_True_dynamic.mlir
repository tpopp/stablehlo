// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_fun_flat_jax {
  func.func public @main(%arg0: tensor<i64>, %arg1: tensor<?x2x3xbf16> {mhlo.sharding = ""}, %arg2: tensor<?xbf16> {mhlo.sharding = ""}) -> tensor<?x2x3xbf16> {
    %0 = stablehlo.constant dense<0.000000e+00> : tensor<bf16>
    %1 = stablehlo.pad %arg1, %0, low = [0, 0, 0], high = [0, 0, 0], interior = [0, 0, 0] : (tensor<?x2x3xbf16>, tensor<bf16>) -> tensor<?x2x3xbf16>
    %2 = stablehlo.constant dense<true> : tensor<i1>
    %3 = stablehlo.convert %arg0 : (tensor<i64>) -> tensor<i32>
    %4 = stablehlo.reshape %3 : (tensor<i32>) -> tensor<1xi32>
    %5 = stablehlo.constant dense<2> : tensor<1xi32>
    %6 = stablehlo.constant dense<3> : tensor<1xi32>
    %7 = stablehlo.concatenate %4, %5, %6, dim = 0 : (tensor<1xi32>, tensor<1xi32>, tensor<1xi32>) -> tensor<3xi32>
    %8 = stablehlo.dynamic_broadcast_in_dim %2, %7, dims = [] : (tensor<i1>, tensor<3xi32>) -> tensor<?x2x3xi1>
    %9 = stablehlo.constant dense<false> : tensor<i1>
    %10 = stablehlo.pad %8, %9, low = [0, 0, 0], high = [0, 0, 0], interior = [0, 0, 0] : (tensor<?x2x3xi1>, tensor<i1>) -> tensor<?x2x3xi1>
    %11 = stablehlo.convert %arg0 : (tensor<i64>) -> tensor<i32>
    %12 = stablehlo.reshape %11 : (tensor<i32>) -> tensor<1xi32>
    %13 = stablehlo.constant dense<2> : tensor<1xi32>
    %14 = stablehlo.constant dense<3> : tensor<1xi32>
    %15 = stablehlo.concatenate %12, %13, %14, dim = 0 : (tensor<1xi32>, tensor<1xi32>, tensor<1xi32>) -> tensor<3xi32>
    %16 = stablehlo.dynamic_broadcast_in_dim %arg2, %15, dims = [0] : (tensor<?xbf16>, tensor<3xi32>) -> tensor<?x2x3xbf16>
    %17 = stablehlo.select %10, %1, %16 : tensor<?x2x3xi1>, tensor<?x2x3xbf16>
    return %17 : tensor<?x2x3xbf16>
  }
}

