// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<2> : tensor<1x3x1xi32>
    %1:2 = call @inputs() : () -> (tensor<2x3xbf16>, tensor<2x1x3xbf16>)
    %2 = call @expected() : () -> tensor<2x3xbf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<bf16>, %arg1: tensor<bf16>):
      %5 = stablehlo.add %arg0, %arg1 : tensor<bf16>
      stablehlo.return %5 : tensor<bf16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 2>} : (tensor<2x3xbf16>, tensor<1x3x1xi32>, tensor<2x1x3xbf16>) -> tensor<2x3xbf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<2x3xbf16>, tensor<2x3xbf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<2x3xbf16>, tensor<2x1x3xbf16>) {
    %0 = stablehlo.constant dense<[[-6.250000e+00, 2.187500e+00, -2.203130e+00], [-5.125000e+00, -2.734380e+00, -1.171880e+00]]> : tensor<2x3xbf16>
    %1 = stablehlo.constant dense<[[[-3.750000e+00, 9.296870e-01, -2.078130e+00]], [[-4.093750e+00, 5.718750e+00, 2.531250e+00]]]> : tensor<2x1x3xbf16>
    return %0, %1 : tensor<2x3xbf16>, tensor<2x1x3xbf16>
  }
  func.func private @expected() -> tensor<2x3xbf16> {
    %0 = stablehlo.constant dense<[[-6.250000e+00, 2.187500e+00, -7.062500e+00], [-5.125000e+00, -2.734380e+00, 3.000000e+00]]> : tensor<2x3xbf16>
    return %0 : tensor<2x3xbf16>
  }
}

