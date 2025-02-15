// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<2x1xf32>
    %1 = call @expected() : () -> tensor<1x1xf32>
    %2 = stablehlo.constant dense<0xFF800000> : tensor<f32>
    %3 = stablehlo.broadcast_in_dim %2, dims = [] : (tensor<f32>) -> tensor<f32>
    %4 = "stablehlo.reduce_window"(%0, %3) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %6 = stablehlo.maximum %arg0, %arg1 : tensor<f32>
      stablehlo.return %6 : tensor<f32>
    }) {window_dimensions = dense<[2, 1]> : tensor<2xi64>} : (tensor<2x1xf32>, tensor<f32>) -> tensor<1x1xf32>
    %5 = stablehlo.custom_call @check.eq(%4, %1) : (tensor<1x1xf32>, tensor<1x1xf32>) -> tensor<i1>
    return %5 : tensor<i1>
  }
  func.func private @inputs() -> tensor<2x1xf32> {
    %0 = stablehlo.constant dense<[[2.92939496], [-2.12473869]]> : tensor<2x1xf32>
    return %0 : tensor<2x1xf32>
  }
  func.func private @expected() -> tensor<1x1xf32> {
    %0 = stablehlo.constant dense<2.92939496> : tensor<1x1xf32>
    return %0 : tensor<1x1xf32>
  }
}

