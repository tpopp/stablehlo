// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<0> : tensor<1xi32>
    %1:2 = call @inputs() : () -> (tensor<1x125xf32>, tensor<1xf32>)
    %2 = call @expected() : () -> tensor<1x125xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<f32>
      stablehlo.return %5 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1]>, unique_indices = true} : (tensor<1x125xf32>, tensor<1xi32>, tensor<1xf32>) -> tensor<1x125xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1x125xf32>, tensor<1x125xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x125xf32>, tensor<1xf32>) {
    %0 = stablehlo.constant dense<"0x2514F140E42103C0A32831C04CA5D9BEFB46F93F7803E8BFBAFA193FA1BD14C01045503F19031A41FA1C99C06235EABFD35096BFC03C3740EFFB69C0D732BABF4BDFA1C07F7EB8C09BED1BC12FF601C1309519C011ED5640C86423C08EA520C0EAF089C0B87C2A4060113B3F9084C7BF8469B7BFBAE687BEBB0EBBBFD7DBC4BF49BAD0BFE1A153C0F02BC9406CF3B7C0A7398A3D8F96A340A83E314008452ABF0CA5AE3DA43759C0077FFA40CDA7993E2A282F3F3ABF41BFA7A5353F21395FC0C4DE71BF17B92A40F3309740B86704403AD12DC0305CD53E39840BC0A96BD0BFDCE81AC06656E73F462F3440D93C95BFBED5873D08D183C0661814BFEA7E6C40B00D763E89640AC03524744010AB554005926BC01BF1A7BF398450C07DBD973FEA8CC540E99D983F34CF2D3FF8ECB13D19EF1FC0B9B639BF20393D3F257E5F40294813C045E3BD3FA53F29BEFFF59240866918402A0DB43E950CD53FF585263F35692340EDB199C0AD4B0B3F703B81C00B166BC02DD588C08D583EC081955140C73C4FC01C7E3540FF59D4408E473B3F0FFE28C0701EE0BF3F8EAE3F0D2483C0EEB6D83F49C34140B8020E40F1D78AC0EB5970BF43F9F5BF3EA3B03D2453B53F92FE15C11BD3D33F0E3F83C0BB9585BF9859E7BF5D2F2BC07106A740D38060C01BA882BF9A96A9BE0AA55B4002241B4067200840"> : tensor<1x125xf32>
    %1 = stablehlo.constant dense<0.705973625> : tensor<1xf32>
    return %0, %1 : tensor<1x125xf32>, tensor<1xf32>
  }
  func.func private @expected() -> tensor<1x125xf32> {
    %0 = stablehlo.constant dense<"0x2514F140E42103C0A32831C04CA5D9BEFB46F93F7803E8BFBAFA193FA1BD14C01045503F19031A41FA1C99C06235EABFD35096BFC03C3740EFFB69C0D732BABF4BDFA1C07F7EB8C09BED1BC12FF601C1309519C011ED5640C86423C08EA520C0EAF089C0B87C2A4060113B3F9084C7BF8469B7BFBAE687BEBB0EBBBFD7DBC4BF49BAD0BFE1A153C0F02BC9406CF3B7C0A7398A3D8F96A340A83E314008452ABF0CA5AE3DA43759C0077FFA40CDA7993E2A282F3F3ABF41BFA7A5353F21395FC0C4DE71BF17B92A40F3309740B86704403AD12DC0305CD53E39840BC0A96BD0BFDCE81AC06656E73F462F3440D93C95BFBED5873D08D183C0661814BFEA7E6C40B00D763E89640AC03524744010AB554005926BC01BF1A7BF398450C07DBD973FEA8CC540E99D983F34CF2D3FF8ECB13D19EF1FC0B9B639BF20393D3F257E5F40294813C045E3BD3FA53F29BEFFF59240866918402A0DB43E950CD53FF585263F35692340EDB199C0AD4B0B3F703B81C00B166BC02DD588C08D583EC081955140C73C4FC01C7E3540FF59D4408E473B3F0FFE28C0701EE0BF3F8EAE3F0D2483C0EEB6D83F49C34140B8020E40F1D78AC0EB5970BF43F9F5BF3EA3B03D2453B53F92FE15C11BD3D33F0E3F83C0BB9585BF9859E7BF5D2F2BC07106A740D38060C01BA882BF9A96A9BE0AA55B4002241B4067200840"> : tensor<1x125xf32>
    return %0 : tensor<1x125xf32>
  }
}

