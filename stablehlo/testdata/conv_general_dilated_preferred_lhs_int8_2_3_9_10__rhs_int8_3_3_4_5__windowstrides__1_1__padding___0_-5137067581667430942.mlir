// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<2x3x9x10xi8>, tensor<3x3x4x5xi8>)
    %1 = call @expected() : () -> tensor<2x3x6x6xi16>
    %2 = stablehlo.convolution(%0#0, %0#1) dim_numbers = [b, f, 0, 1]x[o, i, 0, 1]->[b, f, 0, 1], window = {} {batch_group_count = 1 : i64, feature_group_count = 1 : i64} : (tensor<2x3x9x10xi8>, tensor<3x3x4x5xi8>) -> tensor<2x3x6x6xi16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<2x3x6x6xi16>, tensor<2x3x6x6xi16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<2x3x9x10xi8>, tensor<3x3x4x5xi8>) {
    %0 = stablehlo.constant dense<"0x020003040102FFFF03000002FF04FB02FFFA03000000030205FF0203FF0002FFFC00FB02040100FA00000102FD010001020500000005000000000303FE04FD02FC00FB0000FC0001FF00010403FF00FB02FE00FD00FD00000000FC04FE00FBFF0302FE0201FCFE030300FEFF01050106FB0000FB01060200FD05FF0100FE00000601FD00FF0000FE00FEFE0402FC050505020000FD00FEFF05FD010002FF00FE00FE00FF04FFFB04FD0002000000FE0602FF00FBFF00020201010104FE04FC000303FD0200FE00000000FC00000302FC000100FC0100FE04FD01FC000100FD0000FA06FD0000010401FFFF0202FFFE02FD0002F9FA02080206FE0104FF00FD00FB000000FFFF00FB05050203FF040103020100FDF802FEFE00FE0204000301FF04FB010000000000030205000404FC00FE04FB0200FC04010100FFFC030204040000FDFFFFFB0200020100000000030003FE030403FEFF03FE02FCFF01FF000100020504FF00000105FFFC05FF000002FEFDFF00FEFAFB04FFFE06FFFF0402000201000101FE01FD04FDFE00FF01FFFF000100FF000005FE0002020002FFFE0301FB04FF00FF00FEFEFD000200FC000000FE0000030001FBFEFC00FE02030002FF03010900FE00FE02010002FEFAFE000002FB000303FF02FDFDFD0003FF0400000000FD0100FC0100FF000100020002FE00FDFD000007FFF9030105FF00FE02FCFD02010401FF03FE01FAFF00FE01FEFE00FEFB0000FAFEFC020104"> : tensor<2x3x9x10xi8>
    %1 = stablehlo.constant dense<"0xFB02000003FCFF00FF020207030100FE01000304000000FF000000FEFD0404FE0103FF000201FE040106FE0104FF04010102FC01010403FDFD00FB01010402FDFEFF02FFFDFB030300FDFDFFFA040403FEFEFF01FEFB01FFFE030003FD060004FFFCFE02FF00000100FC01F5000601FE0200F902FFFF030307FF01FB000101FF0005FFFF03FFFCFCFFFE000200FF00FF0000FF00FB010003FE0000FC0500FC04FD00040300FC00FE040005FEFDFB00FF03FAFFFE"> : tensor<3x3x4x5xi8>
    return %0, %1 : tensor<2x3x9x10xi8>, tensor<3x3x4x5xi8>
  }
  func.func private @expected() -> tensor<2x3x6x6xi16> {
    %0 = stablehlo.constant dense<"0xE7FF7200280016006900F8FFB7FFE0FF50007EFF4F002100EEFF0A002A00EEFF110012000700F8FF6B00DDFF4600ACFFE8FFA5FF23004300FBFF27000000EDFFE8FFA6FF62003A00CBFFF1FF210069004C00AEFF6200A9FF0600DBFFD5FF8B0002003700CDFFC7FF29000D00C1FFDDFF4D002400A9FF3A00E8FF3C00C1FFF6FF7BFFC7FFE4FF95007800D6FF0C00EDFF2700DDFF2A00BBFF6500ECFF55000E00FAFF65009AFF6A00CCFF13005B00D4FF11006CFFFEFF8800C3FFF0FFABFF4100F6FF2000200006008DFFD6FFA7FF210098FF7C005200A2FFFDFF2400D6FF0B003B00F8FFDFFFB4FFDDFFCBFF6200F4FFE6FF1200C8FFFEFF0800E0FFECFFBCFF0700ECFFFEFFD8FFE5FF24005600E3FF7B002400FDFF3F0066002C0002002000ECFF6F00E7FFF3FF1800E7FF080002005A00EAFFF9FF1C00D8FF140000001B0023001E005200FBFF2C00B6FFB3FFDFFF68FF6400DCFFBFFFE3FF5EFF13001600FAFF25008EFF0C000D009B00EDFF0E002D0096FFD8FFDAFF4C002B0025005300CDFF4A00DDFFC1FF5100D8FF24003A000600D9FF7DFF35003500F6FFFDFFB6FF320072FF50003C00FFFF1D001500C6FF"> : tensor<2x3x6x6xi16>
    return %0 : tensor<2x3x6x6xi16>
  }
}

