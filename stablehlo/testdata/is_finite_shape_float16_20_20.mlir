// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xf16>
    %1 = call @expected() : () -> tensor<20x20xi1>
    %2 = stablehlo.is_finite %0 : (tensor<20x20xf16>) -> tensor<20x20xi1>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xi1>, tensor<20x20xi1>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xf16> {
    %0 = stablehlo.constant dense<"0x83B3AFBEB5BDFFC4DB433346AF3F923E76BD144100B1D338D7C0F33EDC444A3C61C4C24425BF444123C2EABC96C0FC3BE4450A443DB00D39E7C1F82EA4C408C0C1BCAAC163AE8CBFD543C6375F4086B342B2184459C281BFAA3232B92EB56BB07EC10743BE4518444C385DC0ABBAD7C7CA41954026C074C1C32C563E74C50F45D4411CA57B42A7442F3FC43CBFC3F530154613C1EF420E42B34218C5D0377CBDDCBC47C6A43E6144EA3FB6B71943A9421EB96BC3E8C3EDC4D64247C55E41CF3BC93F2DB7AB3B7D4556C3EB432C3EBCC300B3D641E0BE77C18DC081C141400CBF26C31539FF24A1C5CF3AD9C0B93DD5356945B34051BE6CBE2FBFF3BD48C719C1BDC1EDB451C5A53C5E393844F6C0E437F9B647B524B9C4C0D53B9DB3EC401144AB4114C6FD36D1C743B665BCE6C295B99A32ECBE12BB50C145BC0CBD70C323BCC6C44E41AB43C8358B3EAC3CB3C13DC163C0C3400BBDF341FB3CEBC068C0B6C1FA3F81BCF4BA6147CF41864239B991C3EE3C4B41243BBA446AC202BF52C3EB41EC3F7A3DE6C06846C6C006BCC4C4C1C060BDF3402D38EBC3E9BEC74321C6F142F944053D32351BC03442BDC31046C7BE62C4A43CF3C77443D53D623057B85FBC3BBAEB4340434237BBBAB5BA9BC6BFBF81BCB0B67B3EB6BCF2B73945BF3E78AE32B988C177434FC8432C633F7F423840A5C06ABBEA3397C76BC0F3406746F742603C91BDA4402CB8C9C4F5C5AB3E814247B557322DB8D3C6C23F493A913F60AD26C0F446E23FAD46F0422742843F192CFB3889BC0D3F89C631BBD0B2BBBDEB441BC518C0C038054449C205BE263CE73586C152458B39DCC564C239C3FAC1233D8EC63BBAD32C21BCEF35EFC4D3B8A437CDB98BB25445A9BE694147BC35C00DC456C4913FE8B0FAC3544272422BC359BD0EBD09C0F6B8C8BABBC0D9BD103DBF4326B840C0E7BB1B382CC2633E493F8143A2C4924210C23333C841653CE9C4ABC4243B553B1FB7E6A5833208BCF33662398C4558C368C46744DAC20D45D3B06AC66742AE43D341163D2D44823308BB0C4546C0DEB8F9C0D4BE41C01CC10EBE7AC3B1C0D4427DB455BA2EBE86395D3D814358B4E93B954122C424B94CB0CDBC75C4"> : tensor<20x20xf16>
    return %0 : tensor<20x20xf16>
  }
  func.func private @expected() -> tensor<20x20xi1> {
    %0 = stablehlo.constant dense<true> : tensor<20x20xi1>
    return %0 : tensor<20x20xi1>
  }
}
