// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[0, 1], [2, 3]]> : tensor<2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xf16>, tensor<2x7xf16>)
    %2 = call @expected() : () -> tensor<5x6x7xf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f16>, %arg1: tensor<f16>):
      stablehlo.return %arg1 : tensor<f16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [1], inserted_window_dims = [0, 1], scatter_dims_to_operand_dims = [0, 1], index_vector_dim = 1>, unique_indices = true} : (tensor<5x6x7xf16>, tensor<2x2xi32>, tensor<2x7xf16>) -> tensor<5x6x7xf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xf16>, tensor<5x6x7xf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xf16>, tensor<2x7xf16>) {
    %0 = stablehlo.constant dense<"0x1A404E41A4B50DC784C13DC41CB84240F6BA62466DC2E74133427FC171C16B3C50AC72B4F1C0824478B7CDBC8139344236BBAAB581364846F93C0E41723DD3395144BDAA723ED4B2063DA738FB37E8349EC1E4B81AB949BCEB3739402B404F4778B9FD3F2637D6410EBEC238B541A7C08DC1D1B854C54FBC3938A7B36244B9BD20C0444176B9E745AABE7DC25E4227C3DA428EC4D746F8BE1240564726B467C1713835BEA23C3C44783B2AAACABC1DC35F406CBC60C0A9445DB6A743C7B3E9B9C9393EB42FC14C3D6142B7BA143A7434E33F534698BE0CC35D2956B279BEA041F630BD3CAE480DAF5946633CBDC280C41DB9CD3ADC42A8B4BFB014BF833916C095B97439A3C137C4EA402345E7BF74C346C643C4C9C130435C444C3A07C056C3FCAF7DC6E5417A3C8D4451BE2C40C438BC42A14310BF6EC2F2C43DB73EC56FC0763CC9BE8A3883C5CB392BBD6C43D3BEFEB6D144223C2C455EC049C15F3C594240BA3B3E20BD1C48BD438347D5438C4248C3FCC54BBEB7BC9ABF3AC666BC91BEE1B35D3CE5C4634239BE4A40EB3661BD85BEE9405845143D0D3C1843D9423FBF08BCF4C3"> : tensor<5x6x7xf16>
    %1 = stablehlo.constant dense<[[-3.347170e-01, 3.373050e+00, -3.333980e+00, 7.905270e-01, 1.143550e+00, -1.063230e-01, -2.316890e-01], [1.335940e+00, -1.071290e+00, -2.554690e+00, -2.597660e+00, 1.051760e+00, 3.728520e+00, -6.500000e+00]]> : tensor<2x7xf16>
    return %0, %1 : tensor<5x6x7xf16>, tensor<2x7xf16>
  }
  func.func private @expected() -> tensor<5x6x7xf16> {
    %0 = stablehlo.constant dense<"0x1A404E41A4B50DC784C13DC41CB85BB5BF42ABC2533A933CCEAE6AB371C16B3C50AC72B4F1C0824478B7CDBC8139344236BBAAB581364846F93C0E41723DD3395144BDAA723ED4B2063DA738FB37E8349EC1E4B81AB949BCEB3739402B404F4778B9FD3F2637D6410EBEC238B541A7C08DC1D1B854C54FBC3938A7B36244B9BD20C0444176B9E745AABE7DC25E4227C3DA428EC4D746F8BE1240564726B467C1713835BEA23C3C44783B2AAACABC1DC35F406CBC60C0A9445DB6A743C7B3E9B9C9393EB42FC14C3D6142B7BA143A7434E33F583D49BC1CC132C1353C754380C6F630BD3CAE480DAF5946633CBDC280C41DB9CD3ADC42A8B4BFB014BF833916C095B97439A3C137C4EA402345E7BF74C346C643C4C9C130435C444C3A07C056C3FCAF7DC6E5417A3C8D4451BE2C40C438BC42A14310BF6EC2F2C43DB73EC56FC0763CC9BE8A3883C5CB392BBD6C43D3BEFEB6D144223C2C455EC049C15F3C594240BA3B3E20BD1C48BD438347D5438C4248C3FCC54BBEB7BC9ABF3AC666BC91BEE1B35D3CE5C4634239BE4A40EB3661BD85BEE9405845143D0D3C1843D9423FBF08BCF4C3"> : tensor<5x6x7xf16>
    return %0 : tensor<5x6x7xf16>
  }
}

