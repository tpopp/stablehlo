// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0, 1], [2, 3]], [[4, 0], [1, 2]]]> : tensor<2x2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xf16>, tensor<5x2x2xf16>)
    %2 = call @expected() : () -> tensor<5x6x7xf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f16>, %arg1: tensor<f16>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<f16>
      stablehlo.return %5 : tensor<f16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xf16>, tensor<2x2x2xi32>, tensor<5x2x2xf16>) -> tensor<5x6x7xf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xf16>, tensor<5x6x7xf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xf16>, tensor<5x2x2xf16>) {
    %0 = stablehlo.constant dense<"0x53416740EF3D32C466C3F1B9F544B03861C44CC3E3BC50C1743635B9AE3CC7B9BBC0CFBF2642D839D5B9A9459AB2092E13412A42C23FA7BC0340BF3F002AADC03B4295428C2A80C49D44AD423FC0143B0AC312BD40BC13433DC3473BFDBFA53B5F36B0C254BDC9C1CDC3904120402244DABF91426FC1BFBB95C0A04871BF8EBC91C13040813D9D40B9384E4271C51DC0E74122B949317FC056C127C18B37063D733A6EC47EBA47BEFDC2813AB141C338F3C1CEC06841B33FC82DD72F2D32AA366F3F1ABA893549C57E44C5C03CA2DAC14EC717C48BB63EC265448BC27D41923CDDB980BC95C22C4538BD91354644C53948C3D7C0D34486439C4150B752C387408B2C37C5FE3E6EC297C684C12E41A0C3603D01417142C5B832AC52B9E7C4A53C2D3DFAC25E4725B7CFC77AB807472D3849BFCD3BF341A432C1B9CC407B4059BFF9BB413D7E38C9C13EABB5409FBAFDC0A8BCECC3CDACAE4234A846B20AC5114159C4D4B95D3D0B41F244E7C0A2C1AF3852455141C3BD37C7A8BE7B44483D2340C03E40C4734458416DBFB84012C5164148AE4A409CC047C634C5CAC0F7BA444440C41BB9"> : tensor<5x6x7xf16>
    %1 = stablehlo.constant dense<[[[4.274900e-01, -2.228520e+00], [3.865230e+00, 2.175780e+00]], [[1.015630e+00, 6.073000e-02], [-4.367190e+00, -4.689940e-01]], [[-2.494140e+00, -5.302730e-01], [2.177730e+00, 6.847650e+00]], [[-4.742190e+00, -4.206540e-01], [3.492190e+00, -2.126460e-01]], [[-1.707760e-01, -4.210940e+00], [-1.917720e-01, 2.566410e+00]]]> : tensor<5x2x2xf16>
    return %0, %1 : tensor<5x6x7xf16>, tensor<5x2x2xf16>
  }
  func.func private @expected() -> tensor<5x6x7xf16> {
    %0 = stablehlo.constant dense<"0x53416740EF3D32C466C3F1B9F544B03861C45A40E3BC50C1743635B9AE3CC7B9BBC0CFBF2642D839D5B9A9459AB2092E13412A42C23FA7BCBB43BF3F002AADC03B4295428C2A80C49D44AD423FC0143B0AC312BD40BC13433DC3473BFDBFA53B5F36B0C254BD81B7CDC3904120402244DABF91426FC1C62B95C0A04871BF8EBC91C13040813D9D40B9384E425EC41DC0E74122B949317FC056C127C18B37063D733A6EC47EBA47BEFDC2813AB141C338F3C1CEC06841B33FC82DD9462D32AA366F3F1ABA893549C57E443EB83CA2DAC14EC717C48BB63EC265448BC27D41923C5B4080BC95C22C4538BD91354644C53948C3D7C0D34486439C4150B752C387408B2C37C5FE3E6EC297C684C12E41CEB2603D01417142C5B832AC52B9E7C4A53C2D3DFAC25E4725B7CFC77AB807472D3849BFCD3BFC42A432C1B9CC407B4059BFF9BB413D7E38C9C13EABB5409FBAFDC0A8BC77B1CDACAE4234A846B20AC5114159C422415D3D0B41F244E7C0A2C1AF3852455141C3BD37C7A8BE7B44483D2340C03E40C47344584123B2B84012C5164148AE4A409CC047C634C5CAC0F7BA444440C41BB9"> : tensor<5x6x7xf16>
    return %0 : tensor<5x6x7xf16>
  }
}

