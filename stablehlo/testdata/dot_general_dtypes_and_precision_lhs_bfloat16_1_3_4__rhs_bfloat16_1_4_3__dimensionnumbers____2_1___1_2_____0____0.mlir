// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<1x3x4xbf16>, tensor<1x4x3xbf16>)
    %1 = call @expected() : () -> tensor<1xbf16>
    %2 = "stablehlo.dot_general"(%0#0, %0#1) {dot_dimension_numbers = #stablehlo.dot<lhs_batching_dimensions = [0], rhs_batching_dimensions = [0], lhs_contracting_dimensions = [2, 1], rhs_contracting_dimensions = [1, 2]>} : (tensor<1x3x4xbf16>, tensor<1x4x3xbf16>) -> tensor<1xbf16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<1xbf16>, tensor<1xbf16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x3x4xbf16>, tensor<1x4x3xbf16>) {
    %0 = stablehlo.constant dense<[[[4.968750e+00, -1.101560e+00, 1.015630e+00, 4.812500e+00], [-3.398440e-01, 2.484380e+00, -5.187500e+00, -1.109380e+00], [-1.328130e+00, 3.312500e+00, -4.937500e+00, -4.281250e+00]]]> : tensor<1x3x4xbf16>
    %1 = stablehlo.constant dense<[[[-1.164060e+00, 1.437500e+00, -4.638670e-02], [-1.945310e+00, -5.187500e+00, -1.414060e+00], [-2.031250e+00, -3.656250e+00, -1.738280e-01], [4.902340e-01, -5.968750e+00, -3.671880e+00]]]> : tensor<1x4x3xbf16>
    return %0, %1 : tensor<1x3x4xbf16>, tensor<1x4x3xbf16>
  }
  func.func private @expected() -> tensor<1xbf16> {
    %0 = stablehlo.constant dense<2.087500e+01> : tensor<1xbf16>
    return %0 : tensor<1xbf16>
  }
}

