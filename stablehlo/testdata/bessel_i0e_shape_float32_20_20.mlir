// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xf32>
    %1 = call @expected() : () -> tensor<20x20xf32>
    %2 = call @bessel_i0e(%0) : (tensor<20x20xf32>) -> tensor<20x20xf32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xf32> {
    %0 = stablehlo.constant dense<"0x2DDB954082D57A4009F1ACC0E36D20BDD84EFD3F39B801407EFE9EC04E4FE0BF6DC158C0FE447540200B6F3FB80101BEC580B8C0E329DABFC5102440311C4240567BA6406026F13FC7547EC0CAAB3EC05EB1A040FB20B3C0138CCB3F16519F3F71B1B33FEB644D40C9DBF0BFE81986403053773D499C01C0E9F5C53F3719ABC07653C440FA591D3E9137E33F047BDA3FC175B23F7D6B473F6CC9EB409B7213C0AE4027C09D9E3D40B6122EBEEEBB103E93BDB5BFAB87E740680A00C08C615BC0D62A13C080CB7ABFC452383EA1739540C47470C097A68C3F03B5D240E4B99E3F540B12C0C4A549C0CE476D403177A13FE2C9D73E702C5FC0D9093C3F00AA5C403EDC59C0150B133EA27818400166D3BF1E5D1FC08C69923FF1A5AE402865E03FA728AB3DDB8E6541572F413FED95DBC04BE4923F270D71BFA0EF83409ECA7A402F8A3BBF6CE27D3F289B19405C03AFC0E89F63406637AE3F63FFDF3F64B4A23EDA482940DE8F97BF815E0240F9EC1DC04FFA4040E98A5E3F68F58440BC12994045FEA73F40407F40C42719407A4D104036ADD7BD33F278BFFE2FA5408C1875C04F6007409BD01C40AD1F9540CF26AF3FC81FCF3F589E044114B1D2BF8C409D4019F73C40CA6160C0190187C0B89CECC0992EF63FC8C8803EA65D13C0EE412FC02ED97BC04C04ED3FADF6A44091620D4031BE46C02AE62740E5760A3EBF2A45409086DD3F60D727BF4A7088C00B4E053FB0E0E8BF9C575B3DB27F8BC0E51D39BDBE681440E0F9913E6AB10C401D171E3FC2A7354091E51B40EB4908C02FBA2240EE88A4C0929D0C40BD624B40851A263EB27E8C3F035A8EC0E45CFBBF0B0D044031977F3F6AA38B4001878240DD3CB93EA5A3AF3E826F9540C6E6E6BE7389BC3F03FFA63E108AB43FEF3CBF40D3030CC0DEBED0BE05A1D7BF4D0B1F40E49782BF92995F3F399A87401C3ECD3F5A1F9DC0A7BD59405F8910C18027C8BFC232F63F11B914C059CFD53FF86E7D3F16F2073E5A5815C00DE91F3F139627BFF34DAABF672607C0A04B61BFD429A74023C1F13FD1FF1040884079C0AEF5C63F57A0F43EABB7EE3F4D3D9BBF202987BEE2CA883FD6AD4CBF768F57BFAECE74BF2E29AA403516FE3F869613C06A6637C054CD0CBFAAB6703FCE6CA2C0126D8D3FEDCB5C3F2A8CABC089F700405D32DD3F0E0F9EBFF1F9813F7EE758BF0E7DD03DEFDD92409A3924C05D9CA93F54A34FBFC8B056BF2AA203C09C93BE3E550DEC3FE21A1640F705D93F45C933C0EAB0C43ED13010404EF8B63FFB56F2C06AD270BFCCB442BFC92AFFBFBE5210C014965D40A5CDCFBFBD162BC04225D4BEE5D9CABF2F9D853F83B12ABF86B31340B01B894079BD18402684624058F1203FEF50A140FCBE2FC0013395C0DA4E7F40F4D870C08F38DEBF7FFA18C0556274C0C4FD81C0374E0AC03EEEB240650ABBBEF04B66BF7A298A40F226A63E2B855140E42F11BF6527624009D672C0FE9CAEC05F278FC00F9AD3BF2C88CDC0927292BF5B49BBBDFEC76DBF50B391BFED4001BF6ADBF83F99BC53C035A4BC40A82037C03EE96140CD523B40432187BF1244BEC0435AD5BF09778940F1BD8E3F773297BFC73487BF34CB21400B23CCBE78A10DC0160F964008B678BFA4FEC9C096104D40F05F33407F52803E7C851E4019508E404F9C993ECD6EE8BF57861EC04D7903C0F77FE73FEB31B13FC5AA5BBF11DF853F306E60C0F44729BED2B3A340C8A06D3F7CF38FBF30169C3FE71DF73F2D3EBC3EC780BB3FB0ED1FC0A8F279C03C985CBE4F374FBFAA93E9BF6F3E544042B472408147BCBF4E1E85BFBE8D023EF07125C0D11CF6BED133BCC09E853FBEAFAFF0BF3D0FEC3F877E65C07E03303F7101F5BFBB3348BC7F50803EC41A1940A979454061E92B4003F302BF906667406478B2BF9DA501BF139C9E3EFEE31BBFA56E3EBF65B506403BCE06BF57E546403BCB4E3FFA63CC3F8DAE743F887F67C077F2AB3E5DA04340D4F4A13E96474ABF46E60E40191B0540EFD0B4C05B4943C0452062400506B53F97A55EC00F881FBF4ECDC5BEB6CF1CC085460FC02A789140A9706AC0E041ADC0636825BECE8194C017CF7D40B0D2FC3E92E998C057C0C74089C300C0B8401540747A8EBF01513A3F3CDC064040EAB840F576FDBF456ECBBE40C0203F28182ABFC85B2F40D99E94BF87FEDCC0A314C940012E83C04D340DBF750E39402261E540004C1C40D6D2B4BFB30FE23E25B61CC0863CB03F"> : tensor<20x20xf32>
    return %0 : tensor<20x20xf32>
  }
  func.func private @expected() -> tensor<20x20xf32> {
    %0 = stablehlo.constant dense<"0xF0A4423E6358563E2B56343EEC42763F23F89E3E20B09C3E33943C3E6626AB3EBC5E683E56FF583E1C92F73EFA97623F22462E3ED411AE3E963E883EC849773EF403383EA2C7A33E7EBA543EF2D1793E73833B3EA003313ED292B53ECA5DD23ED9CDC33EEC7F6F3E6CE6A33E2EAA4E3E2838713F84C49C3E7FABB83E095D353EB8AB283E55D55C3F52D0A93E76EAAD3EDA9DC43EC0FA073FAE47193E0C1B913EB6B8863E329C7A3EF88A593F625E5F3F1A79C23E58BD1A3E0BED9D3E23D0663E1E45913EA42FF13E6890573F3CED423EE55F5B3E8727E23E7689223EC6D3D23E10EF913E8400723EC8FC5C3E8EB5D03E04802F3F8A9E643E9CF10B3F4C10663E02B6673EB9E65E3FFC3F8E3EB870B13E83968A3ECFFFDC3EBD66333E401CAB3EDDE26B3F27A9D93D901F0A3FF6111F3E0295DC3E5D74F63E2880503E7C5D563E691F0C3FB990EF3E98A08D3E0834333EDE1F623E0A7AC73E8E4BAB3E4B0A3F3FDCC6853E5A9CD83E61379C3E37548B3EFA1C783E9494003F9CA04F3E1871403EBCDBCB3E334F543EA7DF8D3E21FB923EFA0C673FD22AF23EC4C7383EEE14593ED3B5983ED2E88B3E1528433E76D6C63EEAA8B33E0934103E67CDB13EDAB03D3E0A1B7B3E04EF633EDBE94D3E7400193E92BDA13E9E3A4A3F5227913E5F1C833E59DF553E3082A53EE4E9383EF6C8943E78FF733E376B863E46A5603F261A753ED174AC3E1290133FBEBC4C3EB892223F614AA73E62D3723F844B4A3E0CD0743FCE8B903E256D443FEA38953E2688173FFE6C803E0B658C3E5418983E42E6883E702B393E8445953ECCD4703EF0195B3F324CE23EB818483E6DB69F3E70039B3E26AEEE3E8C2F4A3EE2B8513ED22A383F020B3B3F1EF0423E76782B3FD135BE3EBAB23D3F5340C33EB6032B3E8CA7953E526F313F0A50AF3E6AC08A3E82D3EB3EF942003FA56B4D3EF0A8B43E3FC63D3E30C8673E06EF093E2270B73EEABBA13E685D903E2138B03EE9CCEF3E6E29613FE601903E9BC6163F01AA133F4834CA3E26DD983EF081FF3ED29D373EF687A33E3C8F923ED016573E331BB83E3EF3273F8DCAA43EC898D53E560B483F84C2E53ED638063F22BA023F1865F43E85E4353EA3AC9E3E0B06913EA1717F3EB8141F3F41A4F63E17723A3EEE71E13E431C013F931C353E563D9D3EC89CAC3ED159D33EFF72EC3EE84E023F2FD2673FE2C2443EC22A883E84B2CA3ECA40053FEBFF023F434F9B3EA799363F54EBA53E0A938F3E40A0AE3E6531813E53D5343F8C0C933E3AAFC13EAA1C173EE094F63E1498093F8B449E3EEEF7923E9687653E674DB33E51F4843E0A7F303FB9F3B53EB7D3E83E5A70123F1BF5903EFB314C3E081A8E3EEABC623EA059163F8A203B3E5AE6823E841A433E9248543EA72D5B3EAA20AC3E7CF88D3EC26D593E6231523E94C2963E241E313EB5A2373F458FFC3ED2594B3EFBF53D3F6AD56C3EEB191D3F88F0623E73305A3E9B6B333ECB7D473E2456B13E7CAA243EF0F7DC3ED01D6A3F2447F83E2E9FDD3EBF84243F40AFA03E3C706B3ECA3F2C3E85A97F3E3413633EB45C7C3E5F5AE73E3E792B3EFB72B03E7CE84B3E9840E03E46EAD83E8A47E73EA65C893E94B8323F6EA1943ED180423EE94AF23EA82B263E70B76F3E1C5D813E89634A3F42058B3E3C20483EEEEF413F367CA73ED2048B3E5B6C9B3E36E5A73E6C75C53EA774013F4893E83E03E8633E507A5A3F82AB393E2E5DF83E352BDF3E82EAD43E8D5EA13E4B48373FFDD7BE3ED44C8A3ED0C2563ED4C9503FF063053F64FCA63E691F6B3E25415A3E1B5EBE3E3950E93EF045623F3894873E9F93273FEA752C3E0731563FA6F8A33E85EAA53EE819613EB862103F0436A23E79E67C3F38644A3FC8E68D3E8CE2743E9595843EFFB2233F8212603E1A9CC43EEE53243FF055403F8174183F5A170B3F362A993EEDDC213F40E4733E2F87053F1A1EB53E9176F43E2005603E642B3C3F4B32763E9E463F3FA604073F33D7933EAC459A3ECB23303E9C70763E81F4623ECAEFC23E90EB643EBDEE163FF283343F4AE98B3EDE9B933E80C6453E15765E3E9529343EFD3C5B3F5297433EB1F7543E93E8253FD28C403E8425273EAF639D3E6F0F903E787DE03E42900C3FAD0F993EB1112E3EE9E89E3E64EB323FD36D163F70AC123F2E11833EC317DB3E568A1E3EEF90263E5D27513EBEE51E3F00217E3E3D7E1B3EBF2E8C3E0211C33E47BE2C3FBEF68B3E4A1AC63E"> : tensor<20x20xf32>
    return %0 : tensor<20x20xf32>
  }
  func.func private @bessel_i0e(%arg0: tensor<20x20xf32>) -> tensor<20x20xf32> {
    %0 = call @xla_fallback_bessel_i0e(%arg0) : (tensor<20x20xf32>) -> tensor<20x20xf32>
    return %0 : tensor<20x20xf32>
  }
  func.func private @xla_fallback_bessel_i0e(%arg0: tensor<20x20xf32>) -> tensor<20x20xf32> {
    %0 = stablehlo.constant dense<0.000000e+00> : tensor<f32>
    %1 = stablehlo.constant dense<0.000000e+00> : tensor<f32>
    %2 = stablehlo.abs %arg0 : tensor<20x20xf32>
    %3 = stablehlo.constant dense<8.000000e+00> : tensor<f32>
    %4 = stablehlo.constant dense<8.000000e+00> : tensor<20x20xf32>
    %5 = stablehlo.compare  LE, %2, %4 : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<20x20xi1>
    %6 = stablehlo.constant dense<5.000000e-01> : tensor<f32>
    %7 = stablehlo.constant dense<5.000000e-01> : tensor<20x20xf32>
    %8 = stablehlo.constant dense<5.000000e-01> : tensor<f32>
    %9 = stablehlo.constant dense<5.000000e-01> : tensor<20x20xf32>
    %10 = stablehlo.multiply %9, %2 : tensor<20x20xf32>
    %11 = stablehlo.constant dense<2.000000e+00> : tensor<f32>
    %12 = stablehlo.constant dense<2.000000e+00> : tensor<20x20xf32>
    %13 = stablehlo.subtract %10, %12 : tensor<20x20xf32>
    %14 = stablehlo.constant dense<0.000000e+00> : tensor<f32>
    %15 = stablehlo.constant dense<0.000000e+00> : tensor<20x20xf32>
    %16 = stablehlo.multiply %13, %15 : tensor<20x20xf32>
    %17 = stablehlo.constant dense<0.000000e+00> : tensor<f32>
    %18 = stablehlo.constant dense<0.000000e+00> : tensor<20x20xf32>
    %19 = stablehlo.subtract %16, %18 : tensor<20x20xf32>
    %20 = stablehlo.constant dense<-1.30002498E-8> : tensor<f32>
    %21 = stablehlo.constant dense<-1.30002498E-8> : tensor<20x20xf32>
    %22 = stablehlo.add %19, %21 : tensor<20x20xf32>
    %23 = stablehlo.multiply %13, %22 : tensor<20x20xf32>
    %24 = stablehlo.constant dense<0.000000e+00> : tensor<20x20xf32>
    %25 = stablehlo.subtract %23, %24 : tensor<20x20xf32>
    %26 = stablehlo.constant dense<6.04699508E-8> : tensor<f32>
    %27 = stablehlo.constant dense<6.04699508E-8> : tensor<20x20xf32>
    %28 = stablehlo.add %25, %27 : tensor<20x20xf32>
    %29 = stablehlo.multiply %13, %28 : tensor<20x20xf32>
    %30 = stablehlo.subtract %29, %22 : tensor<20x20xf32>
    %31 = stablehlo.constant dense<-2.67079372E-7> : tensor<f32>
    %32 = stablehlo.constant dense<-2.67079372E-7> : tensor<20x20xf32>
    %33 = stablehlo.add %30, %32 : tensor<20x20xf32>
    %34 = stablehlo.multiply %13, %33 : tensor<20x20xf32>
    %35 = stablehlo.subtract %34, %28 : tensor<20x20xf32>
    %36 = stablehlo.constant dense<1.11738757E-6> : tensor<f32>
    %37 = stablehlo.constant dense<1.11738757E-6> : tensor<20x20xf32>
    %38 = stablehlo.add %35, %37 : tensor<20x20xf32>
    %39 = stablehlo.multiply %13, %38 : tensor<20x20xf32>
    %40 = stablehlo.subtract %39, %33 : tensor<20x20xf32>
    %41 = stablehlo.constant dense<-4.41673819E-6> : tensor<f32>
    %42 = stablehlo.constant dense<-4.41673819E-6> : tensor<20x20xf32>
    %43 = stablehlo.add %40, %42 : tensor<20x20xf32>
    %44 = stablehlo.multiply %13, %43 : tensor<20x20xf32>
    %45 = stablehlo.subtract %44, %38 : tensor<20x20xf32>
    %46 = stablehlo.constant dense<1.64484482E-5> : tensor<f32>
    %47 = stablehlo.constant dense<1.64484482E-5> : tensor<20x20xf32>
    %48 = stablehlo.add %45, %47 : tensor<20x20xf32>
    %49 = stablehlo.multiply %13, %48 : tensor<20x20xf32>
    %50 = stablehlo.subtract %49, %43 : tensor<20x20xf32>
    %51 = stablehlo.constant dense<-5.75419508E-5> : tensor<f32>
    %52 = stablehlo.constant dense<-5.75419508E-5> : tensor<20x20xf32>
    %53 = stablehlo.add %50, %52 : tensor<20x20xf32>
    %54 = stablehlo.multiply %13, %53 : tensor<20x20xf32>
    %55 = stablehlo.subtract %54, %48 : tensor<20x20xf32>
    %56 = stablehlo.constant dense<1.88502891E-4> : tensor<f32>
    %57 = stablehlo.constant dense<1.88502891E-4> : tensor<20x20xf32>
    %58 = stablehlo.add %55, %57 : tensor<20x20xf32>
    %59 = stablehlo.multiply %13, %58 : tensor<20x20xf32>
    %60 = stablehlo.subtract %59, %53 : tensor<20x20xf32>
    %61 = stablehlo.constant dense<-5.76375576E-4> : tensor<f32>
    %62 = stablehlo.constant dense<-5.76375576E-4> : tensor<20x20xf32>
    %63 = stablehlo.add %60, %62 : tensor<20x20xf32>
    %64 = stablehlo.multiply %13, %63 : tensor<20x20xf32>
    %65 = stablehlo.subtract %64, %58 : tensor<20x20xf32>
    %66 = stablehlo.constant dense<0.00163947558> : tensor<f32>
    %67 = stablehlo.constant dense<0.00163947558> : tensor<20x20xf32>
    %68 = stablehlo.add %65, %67 : tensor<20x20xf32>
    %69 = stablehlo.multiply %13, %68 : tensor<20x20xf32>
    %70 = stablehlo.subtract %69, %63 : tensor<20x20xf32>
    %71 = stablehlo.constant dense<-4.324310e-03> : tensor<f32>
    %72 = stablehlo.constant dense<-4.324310e-03> : tensor<20x20xf32>
    %73 = stablehlo.add %70, %72 : tensor<20x20xf32>
    %74 = stablehlo.multiply %13, %73 : tensor<20x20xf32>
    %75 = stablehlo.subtract %74, %68 : tensor<20x20xf32>
    %76 = stablehlo.constant dense<0.0105464607> : tensor<f32>
    %77 = stablehlo.constant dense<0.0105464607> : tensor<20x20xf32>
    %78 = stablehlo.add %75, %77 : tensor<20x20xf32>
    %79 = stablehlo.multiply %13, %78 : tensor<20x20xf32>
    %80 = stablehlo.subtract %79, %73 : tensor<20x20xf32>
    %81 = stablehlo.constant dense<-0.0237374157> : tensor<f32>
    %82 = stablehlo.constant dense<-0.0237374157> : tensor<20x20xf32>
    %83 = stablehlo.add %80, %82 : tensor<20x20xf32>
    %84 = stablehlo.multiply %13, %83 : tensor<20x20xf32>
    %85 = stablehlo.subtract %84, %78 : tensor<20x20xf32>
    %86 = stablehlo.constant dense<0.0493052825> : tensor<f32>
    %87 = stablehlo.constant dense<0.0493052825> : tensor<20x20xf32>
    %88 = stablehlo.add %85, %87 : tensor<20x20xf32>
    %89 = stablehlo.multiply %13, %88 : tensor<20x20xf32>
    %90 = stablehlo.subtract %89, %83 : tensor<20x20xf32>
    %91 = stablehlo.constant dense<-9.490110e-02> : tensor<f32>
    %92 = stablehlo.constant dense<-9.490110e-02> : tensor<20x20xf32>
    %93 = stablehlo.add %90, %92 : tensor<20x20xf32>
    %94 = stablehlo.multiply %13, %93 : tensor<20x20xf32>
    %95 = stablehlo.subtract %94, %88 : tensor<20x20xf32>
    %96 = stablehlo.constant dense<0.171620905> : tensor<f32>
    %97 = stablehlo.constant dense<0.171620905> : tensor<20x20xf32>
    %98 = stablehlo.add %95, %97 : tensor<20x20xf32>
    %99 = stablehlo.multiply %13, %98 : tensor<20x20xf32>
    %100 = stablehlo.subtract %99, %93 : tensor<20x20xf32>
    %101 = stablehlo.constant dense<-0.304682672> : tensor<f32>
    %102 = stablehlo.constant dense<-0.304682672> : tensor<20x20xf32>
    %103 = stablehlo.add %100, %102 : tensor<20x20xf32>
    %104 = stablehlo.multiply %13, %103 : tensor<20x20xf32>
    %105 = stablehlo.subtract %104, %98 : tensor<20x20xf32>
    %106 = stablehlo.constant dense<0.676795303> : tensor<f32>
    %107 = stablehlo.constant dense<0.676795303> : tensor<20x20xf32>
    %108 = stablehlo.add %105, %107 : tensor<20x20xf32>
    %109 = stablehlo.subtract %108, %98 : tensor<20x20xf32>
    %110 = stablehlo.multiply %7, %109 : tensor<20x20xf32>
    %111 = stablehlo.constant dense<5.000000e-01> : tensor<f32>
    %112 = stablehlo.constant dense<5.000000e-01> : tensor<20x20xf32>
    %113 = stablehlo.constant dense<3.200000e+01> : tensor<f32>
    %114 = stablehlo.constant dense<3.200000e+01> : tensor<20x20xf32>
    %115 = stablehlo.divide %114, %2 : tensor<20x20xf32>
    %116 = stablehlo.constant dense<2.000000e+00> : tensor<20x20xf32>
    %117 = stablehlo.subtract %115, %116 : tensor<20x20xf32>
    %118 = stablehlo.constant dense<0.000000e+00> : tensor<f32>
    %119 = stablehlo.constant dense<0.000000e+00> : tensor<20x20xf32>
    %120 = stablehlo.multiply %117, %119 : tensor<20x20xf32>
    %121 = stablehlo.constant dense<0.000000e+00> : tensor<f32>
    %122 = stablehlo.constant dense<0.000000e+00> : tensor<20x20xf32>
    %123 = stablehlo.subtract %120, %122 : tensor<20x20xf32>
    %124 = stablehlo.constant dense<3.39623196E-9> : tensor<f32>
    %125 = stablehlo.constant dense<3.39623196E-9> : tensor<20x20xf32>
    %126 = stablehlo.add %123, %125 : tensor<20x20xf32>
    %127 = stablehlo.multiply %117, %126 : tensor<20x20xf32>
    %128 = stablehlo.constant dense<0.000000e+00> : tensor<20x20xf32>
    %129 = stablehlo.subtract %127, %128 : tensor<20x20xf32>
    %130 = stablehlo.constant dense<2.26666899E-8> : tensor<f32>
    %131 = stablehlo.constant dense<2.26666899E-8> : tensor<20x20xf32>
    %132 = stablehlo.add %129, %131 : tensor<20x20xf32>
    %133 = stablehlo.multiply %117, %132 : tensor<20x20xf32>
    %134 = stablehlo.subtract %133, %126 : tensor<20x20xf32>
    %135 = stablehlo.constant dense<2.04891862E-7> : tensor<f32>
    %136 = stablehlo.constant dense<2.04891862E-7> : tensor<20x20xf32>
    %137 = stablehlo.add %134, %136 : tensor<20x20xf32>
    %138 = stablehlo.multiply %117, %137 : tensor<20x20xf32>
    %139 = stablehlo.subtract %138, %132 : tensor<20x20xf32>
    %140 = stablehlo.constant dense<2.89137051E-6> : tensor<f32>
    %141 = stablehlo.constant dense<2.89137051E-6> : tensor<20x20xf32>
    %142 = stablehlo.add %139, %141 : tensor<20x20xf32>
    %143 = stablehlo.multiply %117, %142 : tensor<20x20xf32>
    %144 = stablehlo.subtract %143, %137 : tensor<20x20xf32>
    %145 = stablehlo.constant dense<6.88975852E-5> : tensor<f32>
    %146 = stablehlo.constant dense<6.88975852E-5> : tensor<20x20xf32>
    %147 = stablehlo.add %144, %146 : tensor<20x20xf32>
    %148 = stablehlo.multiply %117, %147 : tensor<20x20xf32>
    %149 = stablehlo.subtract %148, %142 : tensor<20x20xf32>
    %150 = stablehlo.constant dense<0.00336911646> : tensor<f32>
    %151 = stablehlo.constant dense<0.00336911646> : tensor<20x20xf32>
    %152 = stablehlo.add %149, %151 : tensor<20x20xf32>
    %153 = stablehlo.multiply %117, %152 : tensor<20x20xf32>
    %154 = stablehlo.subtract %153, %147 : tensor<20x20xf32>
    %155 = stablehlo.constant dense<0.804490387> : tensor<f32>
    %156 = stablehlo.constant dense<0.804490387> : tensor<20x20xf32>
    %157 = stablehlo.add %154, %156 : tensor<20x20xf32>
    %158 = stablehlo.subtract %157, %147 : tensor<20x20xf32>
    %159 = stablehlo.multiply %112, %158 : tensor<20x20xf32>
    %160 = stablehlo.sqrt %2 : tensor<20x20xf32>
    %161 = stablehlo.divide %159, %160 : tensor<20x20xf32>
    %162 = stablehlo.select %5, %110, %161 : tensor<20x20xi1>, tensor<20x20xf32>
    return %162 : tensor<20x20xf32>
  }
}
