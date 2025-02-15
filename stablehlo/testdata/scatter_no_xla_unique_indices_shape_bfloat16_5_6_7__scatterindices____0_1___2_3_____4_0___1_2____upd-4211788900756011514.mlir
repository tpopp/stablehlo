// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0, 1], [2, 3]], [[4, 0], [1, 2]]]> : tensor<2x2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xbf16>, tensor<5x2x2xbf16>)
    %2 = call @expected() : () -> tensor<5x6x7xbf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<bf16>, %arg1: tensor<bf16>):
      stablehlo.return %arg1 : tensor<bf16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xbf16>, tensor<2x2x2xi32>, tensor<5x2x2xbf16>) -> tensor<5x6x7xbf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xbf16>, tensor<5x6x7xbf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xbf16>, tensor<5x2x2xbf16>) {
    %0 = stablehlo.constant dense<"0x0A40EA3F413F78BF5AC0E0C0923FB040AE3F9A4083C0393FE8BF5EC05840A4BFD9BE1A40103E8E4022C0D23FD040783F843F5CC0354020C0F9BFA740C33F46BF05408D40F2BE5FC02BC08F403E3D5B40B9BFA3C0013EB83EA93F554003BF8C4050BF9CC083BF7E40E9BEA83F13400440114039BF86BF664005BE96407CC0A2BFE83F083EDBC0B5BF8040A4408FBF923F9840AF40AC3F39C0044170C02EC119C0913FAD3F9D40374051C09EBE124046C005C0223F2040A4BF14C03B3F21C02F409D407F4030C07D4092C05CC04C4031C0593F373F23BFF3C019C02DBF66C08FBF8FC012C08E3FEFBF0B405B4060C0DBC033C001C142C033C07040BCC0ACBE514011C06EC08A3F2E4080C084BF55BFADBFBC3F0840BD3F74C0AB3F6D4088C08B3F9BC09440E5BFF53F91BF0A4049C073BDB43DBCC08CBF80C0A2BFC4402EC0B93ED4C0A4BE933F24C0883EC3BEDF3E1BC0ADBF483E753F12BE68404640C6BFAE3F1CC0BCBF3040AD40A03FFABEBEBEB3400FBFE2BE54C0264094408840A9402CBF4540D0BED13FEC4055C073C01840CCBF3BC056BE9E3D4240053EEBBF38406E3FCD40BFBE"> : tensor<5x6x7xbf16>
    %1 = stablehlo.constant dense<[[[-5.250000e+00, 1.656250e+00], [-1.265630e+00, 3.609380e+00]], [[1.767580e-01, 2.671880e+00], [-5.585940e-01, -1.539060e+00]], [[2.359380e+00, -3.734380e+00], [-2.406250e+00, 3.703130e+00]], [[2.363280e-01, 2.906250e+00], [7.906250e+00, -1.437500e+00]], [[-1.687500e+00, 1.382810e+00], [2.031250e+00, 4.125000e+00]]]> : tensor<5x2x2xbf16>
    return %0, %1 : tensor<5x6x7xbf16>, tensor<5x2x2xbf16>
  }
  func.func private @expected() -> tensor<5x6x7xbf16> {
    %0 = stablehlo.constant dense<"0x0A40A8C0413F78BF5AC0E0C0923FB040AE3F674083C0393FE8BF5EC05840A4BFD9BED43F103E8E4022C0D23FD040783F843F5CC0354020C0A2BFA740C33F46BF05408D40F2BE5FC02BC08F403E3D5B40B9BFA3C0013E353EA93F554003BF8C4050BF9CC083BFC5BFE9BEA83F13400440114039BF86BF2B4005BE96407CC0A2BFE83F083EDBC0B5BF8040A4400FBF923F9840AF40AC3F39C0044170C02EC119C0913FAD3F9D40374051C01740124046C005C0223F2040A4BF14C06D4021C02F409D407F4030C07D4092C06FC04C4031C0593F373F23BFF3C019C02DBF66C08FBF1AC012C08E3FEFBF0B405B4060C0DBC033C001C142C033C07040BCC0ACBE723E11C06EC08A3F2E4080C084BF55BFB8BFBC3F0840BD3F74C0AB3F6D4088C03A409BC09440E5BFF53F91BF0A4049C073BDB43DBCC0FD4080C0A2BFC4402EC0B93ED4C0A4BE933F24C0883EC3BEDF3E1BC0ADBFD8BF753F12BE68404640C6BFAE3F1CC084403040AD40A03FFABEBEBEB3400FBFB13F54C0264094408840A9402CBF4540D0BED13FEC40024073C01840CCBF3BC056BE9E3D4240053EEBBF38406E3FCD40BFBE"> : tensor<5x6x7xbf16>
    return %0 : tensor<5x6x7xbf16>
  }
}

