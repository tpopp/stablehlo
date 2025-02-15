// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<0> : tensor<1xi32>
    %1:2 = call @inputs() : () -> (tensor<1x125xi8>, tensor<1xi8>)
    %2 = call @expected() : () -> tensor<1x125xi8>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i8>, %arg1: tensor<i8>):
      stablehlo.return %arg1 : tensor<i8>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1]>, unique_indices = true} : (tensor<1x125xi8>, tensor<1xi32>, tensor<1xi8>) -> tensor<1x125xi8>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1x125xi8>, tensor<1x125xi8>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x125xi8>, tensor<1xi8>) {
    %0 = stablehlo.constant dense<"0x03FE03FD00FF02000200FEFD01FB0300000006000102FE01FF00FE0000FEFF000203FEFC0000FD0001FBFCFF030103FD00010501FD00010101020402FD00FF0000FB0404FD0202FC00060401010005FF00FCFD0001FFFE00FC0200000404FE0003000200FCFF000001FF0000FEFF000000FDFF03FE04FE000601FEFC00"> : tensor<1x125xi8>
    %1 = stablehlo.constant dense<3> : tensor<1xi8>
    return %0, %1 : tensor<1x125xi8>, tensor<1xi8>
  }
  func.func private @expected() -> tensor<1x125xi8> {
    %0 = stablehlo.constant dense<"0x03FE03FD00FF02000200FEFD01FB0300000006000102FE01FF00FE0000FEFF000203FEFC0000FD0001FBFCFF030103FD00010501FD00010101020402FD00FF0000FB0404FD0202FC00060401010005FF00FCFD0001FFFE00FC0200000404FE0003000200FCFF000001FF0000FEFF000000FDFF03FE04FE000601FEFC00"> : tensor<1x125xi8>
    return %0 : tensor<1x125xi8>
  }
}

