// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<2x3xf16>
    %1 = call @expected() : () -> tensor<3x2xf16>
    %2 = stablehlo.reshape %0 : (tensor<2x3xf16>) -> tensor<3x2xf16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<3x2xf16>, tensor<3x2xf16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<2x3xf16> {
    %0 = stablehlo.constant dense<[[8.378900e-01, -3.742190e+00, -1.749020e+00], [8.203130e-02, -4.890630e+00, 1.177730e+00]]> : tensor<2x3xf16>
    return %0 : tensor<2x3xf16>
  }
  func.func private @expected() -> tensor<3x2xf16> {
    %0 = stablehlo.constant dense<[[8.378900e-01, -3.742190e+00], [-1.749020e+00, 8.203130e-02], [-4.890630e+00, 1.177730e+00]]> : tensor<3x2xf16>
    return %0 : tensor<3x2xf16>
  }
}
