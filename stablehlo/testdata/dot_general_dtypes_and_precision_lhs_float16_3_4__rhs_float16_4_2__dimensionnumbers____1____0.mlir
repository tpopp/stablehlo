// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<3x4xf16>, tensor<4x2xf16>)
    %1 = call @expected() : () -> tensor<3x2xf16>
    %2 = stablehlo.convert %0#0 : (tensor<3x4xf16>) -> tensor<3x4xf32>
    %3 = stablehlo.convert %0#1 : (tensor<4x2xf16>) -> tensor<4x2xf32>
    %4 = "stablehlo.dot_general"(%2, %3) {dot_dimension_numbers = #stablehlo.dot<lhs_contracting_dimensions = [1], rhs_contracting_dimensions = [0]>} : (tensor<3x4xf32>, tensor<4x2xf32>) -> tensor<3x2xf16>
    %5 = stablehlo.custom_call @check.eq(%4, %1) : (tensor<3x2xf16>, tensor<3x2xf16>) -> tensor<i1>
    return %5 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x4xf16>, tensor<4x2xf16>) {
    %0 = stablehlo.constant dense<[[3.625000e+00, -4.324220e+00, 1.510010e-01, -5.922850e-01], [5.664060e-01, -2.623050e+00, 1.547850e+00, 5.054690e+00], [-5.335940e+00, 5.888670e-01, -4.601560e+00, 6.621090e+00]]> : tensor<3x4xf16>
    %1 = stablehlo.constant dense<[[-1.871090e+00, 1.802730e+00], [3.222660e+00, -6.972650e-01], [1.567080e-02, -3.503910e+00], [-1.779300e+00, 3.539060e+00]]> : tensor<4x2xf16>
    return %0, %1 : tensor<3x4xf16>, tensor<4x2xf16>
  }
  func.func private @expected() -> tensor<3x2xf16> {
    %0 = stablehlo.constant dense<[[-1.965630e+01, 6.925780e+00], [-1.848440e+01, 1.531250e+01], [2.874760e-02, 2.953130e+01]]> : tensor<3x2xf16>
    return %0 : tensor<3x2xf16>
  }
}

