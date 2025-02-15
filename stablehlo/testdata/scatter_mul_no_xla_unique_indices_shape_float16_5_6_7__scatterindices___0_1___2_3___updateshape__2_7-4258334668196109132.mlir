// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[0, 1], [2, 3]]> : tensor<2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xf16>, tensor<2x7xf16>)
    %2 = call @expected() : () -> tensor<5x6x7xf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f16>, %arg1: tensor<f16>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<f16>
      stablehlo.return %5 : tensor<f16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [1], inserted_window_dims = [0, 1], scatter_dims_to_operand_dims = [0, 1], index_vector_dim = 1>, unique_indices = true} : (tensor<5x6x7xf16>, tensor<2x2xi32>, tensor<2x7xf16>) -> tensor<5x6x7xf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xf16>, tensor<5x6x7xf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xf16>, tensor<2x7xf16>) {
    %0 = stablehlo.constant dense<"0x2D2609C0353EB6C102BC51473838BD4363C2BB46DCC140BD2342BBC0F33F29C52F450DACBFBADAB84D3ADE3CED34CBB9D9C428C01135C33753C246B979C3B1C216C236400CBF26C5CB3C7E3CD3C31D44C84188419C4453C6B9C56FBA8844A03C74363BC4CD3E263A80446F44C13C47C57DC13A3E9AC3A6C255412444614428B998BD883D23C07F371A437DC500BE27C0B5C6FE3EB5BD67C0B13B92443D43A3C160C27AB704C5F3B24144F3BCE4B4B14038C163BCB443533E3C40A1BAA1AF63BC9530B73DB33EB6C1BF3D0DBD33C2BC1C40C36E4994BA653F47C427B9C5C01FB8B847C644B5C094ACFB44FCC4CEC0163A29406A3A5632614214C47CC03CC1B7B88BC27CB9DDB990C179BBBFC0DCC39643DF416840C1AF37C27E3F8646C8C69F35F9406A411445E6B960BA3ABCF3BBAE457BBC5B43FD3F00BD8AC0A03ECEB049C19F34D5C374BD463C23B47DBDF3B009398934DB385A3D693D4C401CC6D240EAC74145D43CD8C02841A243E0B86AB803C09D428433CC3E4BBEA14030C054C549BEC93CB52798BF23C0B3401BC09E410244B44084BB60BDC4B63CBF85BC209E60C7F8BDDDC4"> : tensor<5x6x7xf16>
    %1 = stablehlo.constant dense<[[8.847650e-01, 4.140630e+00, -1.949220e+00, -3.185550e+00, 3.001950e+00, 5.898440e-01, 1.743160e+00], [2.025390e+00, 1.452150e+00, 2.814450e+00, 1.835940e+00, 6.753900e+00, 3.808590e-01, 1.501950e+00]]> : tensor<2x7xf16>
    return %0, %1 : tensor<5x6x7xf16>, tensor<2x7xf16>
  }
  func.func private @expected() -> tensor<5x6x7xf16> {
    %0 = stablehlo.constant dense<"0x2D2609C0353EB6C102BC51473838D9429CCA8FCAAB48E1C33D3F1FC4F33F29C52F450DACBFBADAB84D3ADE3CED34CBB9D9C428C01135C33753C246B979C3B1C216C236400CBF26C5CB3C7E3CD3C31D44C84188419C4453C6B9C56FBA8844A03C74363BC4CD3E263A80446F44C13C47C57DC13A3E9AC3A6C255412444614428B998BD883D23C07F371A437DC500BE27C0B5C6FE3EB5BD67C0B13B92443D43A3C160C27AB704C5F3B24144F3BCE4B4B14038C163BCB443533E3C40A1BAA1AF63BC9530B73DB33EB6C1BF3D0DBD33C2BC1C40C3804DC7BC3445DAC75AC444BB31BAB847C644B5C094ACFB44FCC4CEC0163A29406A3A5632614214C47CC03CC1B7B88BC27CB9DDB990C179BBBFC0DCC39643DF416840C1AF37C27E3F8646C8C69F35F9406A411445E6B960BA3ABCF3BBAE457BBC5B43FD3F00BD8AC0A03ECEB049C19F34D5C374BD463C23B47DBDF3B009398934DB385A3D693D4C401CC6D240EAC74145D43CD8C02841A243E0B86AB803C09D428433CC3E4BBEA14030C054C549BEC93CB52798BF23C0B3401BC09E410244B44084BB60BDC4B63CBF85BC209E60C7F8BDDDC4"> : tensor<5x6x7xf16>
    return %0 : tensor<5x6x7xf16>
  }
}

