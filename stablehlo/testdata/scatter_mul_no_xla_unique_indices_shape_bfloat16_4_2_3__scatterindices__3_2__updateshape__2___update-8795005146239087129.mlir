// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[3, 2]> : tensor<2xi32>
    %1:2 = call @inputs() : () -> (tensor<4x2x3xbf16>, tensor<2xbf16>)
    %2 = call @expected() : () -> tensor<4x2x3xbf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<bf16>, %arg1: tensor<bf16>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<bf16>
      stablehlo.return %5 : tensor<bf16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [0, 2], scatter_dims_to_operand_dims = [0, 2]>, unique_indices = true} : (tensor<4x2x3xbf16>, tensor<2xi32>, tensor<2xbf16>) -> tensor<4x2x3xbf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<4x2x3xbf16>, tensor<4x2x3xbf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<4x2x3xbf16>, tensor<2xbf16>) {
    %0 = stablehlo.constant dense<[[[-1.437500e+00, -2.687500e+00, -2.000000e+00], [1.726560e+00, 1.601560e+00, -3.906250e-01]], [[-2.531250e+00, -8.320310e-01, 5.937500e+00], [2.988280e-01, 2.765630e+00, -8.085930e-01]], [[1.328130e+00, -1.757810e+00, -1.140630e+00], [-3.890630e+00, -4.750000e+00, 3.187500e+00]], [[-3.500000e+00, 3.984380e+00, 1.515630e+00], [-3.125000e-01, 4.125000e+00, 1.664060e+00]]]> : tensor<4x2x3xbf16>
    %1 = stablehlo.constant dense<[1.453130e+00, 3.406250e+00]> : tensor<2xbf16>
    return %0, %1 : tensor<4x2x3xbf16>, tensor<2xbf16>
  }
  func.func private @expected() -> tensor<4x2x3xbf16> {
    %0 = stablehlo.constant dense<[[[-1.437500e+00, -2.687500e+00, -2.000000e+00], [1.726560e+00, 1.601560e+00, -3.906250e-01]], [[-2.531250e+00, -8.320310e-01, 5.937500e+00], [2.988280e-01, 2.765630e+00, -8.085930e-01]], [[1.328130e+00, -1.757810e+00, -1.140630e+00], [-3.890630e+00, -4.750000e+00, 3.187500e+00]], [[-3.500000e+00, 3.984380e+00, 2.203130e+00], [-3.125000e-01, 4.125000e+00, 5.656250e+00]]]> : tensor<4x2x3xbf16>
    return %0 : tensor<4x2x3xbf16>
  }
}

