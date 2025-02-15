// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[0, 4]> : tensor<2xi32>
    %1:2 = call @inputs() : () -> (tensor<4x2x3x5xi8>, tensor<4x3xi8>)
    %2 = call @expected() : () -> tensor<4x2x3x5xi8>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i8>, %arg1: tensor<i8>):
      %5 = stablehlo.minimum %arg0, %arg1 : tensor<i8>
      stablehlo.return %5 : tensor<i8>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [1, 3], scatter_dims_to_operand_dims = [1, 3]>, unique_indices = true} : (tensor<4x2x3x5xi8>, tensor<2xi32>, tensor<4x3xi8>) -> tensor<4x2x3x5xi8>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<4x2x3x5xi8>, tensor<4x2x3x5xi8>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<4x2x3x5xi8>, tensor<4x3xi8>) {
    %0 = stablehlo.constant dense<"0x000402FBFF00FE01FDFD04FEFF01000003010002050000FD00FC00FD020004FB0004FF020601FFFD02FB00FF0303FCFD0000FE000000FD0100FA00FF0107000001FF0004FEFEFE05FD0005030401FB02FCFFFEFEFAFFFC0100020000FF0001FF02FB00FB03FDFF00FFFDFF020301000000FC030200FE0000"> : tensor<4x2x3x5xi8>
    %1 = stablehlo.constant dense<[[0, 0, 3], [0, 3, -2], [0, -1, 4], [-2, -1, 0]]> : tensor<4x3xi8>
    return %0, %1 : tensor<4x2x3x5xi8>, tensor<4x3xi8>
  }
  func.func private @expected() -> tensor<4x2x3x5xi8> {
    %0 = stablehlo.constant dense<"0x000402FBFF00FE01FDFD04FEFF01000003010002050000FD00FC00FD020004FB0004FF020601FFFD02FB00FFFE03FCFD0000FE000000FD0100FA00FF0107000000FF0004FEFEFE05FD0004030401FB02FCFFFEFEFAFFFC0100020000FF00FEFF02FB00FB03FDFF00FFFDFF020301000000FC030200FE0000"> : tensor<4x2x3x5xi8>
    return %0 : tensor<4x2x3x5xi8>
  }
}

