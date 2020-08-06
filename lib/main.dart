/* Copyright (c) 2020, Lethean Community developers
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree. */

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import './providers/exit_node_providers.dart';
import './screens/providers_list_screen.dart';
import './screens/services_list_screen.dart';
import './screens/vpn_instruction_screen.dart';
import './widgets/lethean_colors.dart';

void main() {
  LicenseRegistry.addLicense(() async* {
    final license =
        await rootBundle.loadString('assets/google_fonts/Nunito_Sans/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    systemNavigationBarColor: Colors.black,
    statusBarColor: Color.alphaBlend(
      LetheanColors.guidebluegreen.withAlpha(30),
      LetheanColors.guidedarkgray,
    ),
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExitNodeProviders(),
      child: MaterialApp(
        title: 'Lethean Exiplorer',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            shadowColor: Color.alphaBlend(
              LetheanColors.guidebluegreen.withAlpha(30),
              LetheanColors.guidedarkgray,
            ),
            actionsIconTheme: IconThemeData(color: Colors.white),
            iconTheme: IconThemeData(
              color: Colors.white,
              opacity: 1.0,
            ),
            brightness: Brightness.dark,
            color: Color.alphaBlend(
              LetheanColors.guidebluegreen.withAlpha(30),
              LetheanColors.guidedarkgray,
            ),
          ),
          scaffoldBackgroundColor: Color.alphaBlend(
            LetheanColors.guidebluegreen.withAlpha(30),
            LetheanColors.guidedarkgray,
          ),
          primarySwatch: LetheanColors.lthnbluegreen,
          accentColor: LetheanColors.guidebluegreen,
          cardColor: LetheanColors.guidedarkgray[400],
          canvasColor: LetheanColors.guidedarkgray[350],
          brightness: Brightness.dark,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.white70),
            bodyText2: TextStyle(color: Colors.white),
          ),
          fontFamily: GoogleFonts.nunitoSans().fontFamily,
        ),
        home: ProviderListScreen(),
        routes: {
          ProviderListScreen.routeName: (ctx) => ProviderListScreen(),
          ServicesListScreen.routeName: (ctx) => ServicesListScreen(),
          VpnInstructionScreen.routeName: (ctx) => VpnInstructionScreen(),
        },
      ),
    );
  }
}
