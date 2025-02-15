// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<2xf16>, tensor<2xf16>)
    %1 = call @expected() : () -> tensor<2xf16>
    %2 = stablehlo.remainder %0#0, %0#1 : tensor<2xf16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<2xf16>, tensor<2xf16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<2xf16>, tensor<2xf16>) {
    %0 = stablehlo.constant dense<[-1.757810e-01, -1.028320e+00]> : tensor<2xf16>
    %1 = stablehlo.constant dense<[7.082030e+00, 6.152340e+00]> : tensor<2xf16>
    return %0, %1 : tensor<2xf16>, tensor<2xf16>
  }
  func.func private @expected() -> tensor<2xf16> {
    %0 = stablehlo.constant dense<[-1.757810e-01, -1.028320e+00]> : tensor<2xf16>
    return %0 : tensor<2xf16>
  }
}
