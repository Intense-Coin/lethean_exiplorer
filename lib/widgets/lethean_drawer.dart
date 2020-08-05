import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/lethean_colors.dart';
import '../screens/providers_list_screen.dart';

class LetheanDrawer extends StatelessWidget {
  const LetheanDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.alphaBlend(
                LetheanColors.guidebluegreen.withAlpha(150),
                LetheanColors.guidedarkgray,
              ),
              Color.alphaBlend(
                LetheanColors.guidebluegreen.withAlpha(10),
                LetheanColors.guidedarkgray,
              ),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(),
              ),
              decoration: BoxDecoration(
                color: LetheanColors.guidedarkgray.withAlpha(190),
                image: DecorationImage(
                    image: AssetImage("assets/splash/lethean-splash.png"),
                    fit: BoxFit.contain),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                color: Theme.of(context).accentColor,
                // color: LetheanColors.lthnblue,
              ),
              title: Text(
                'Home',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              onTap: () {
                // Go to default screen.
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (ctx) => ProviderListScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.info,
                color: Theme.of(context).accentColor,
              ),
              title: Text(
                'About',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              onTap: () async {
                Navigator.pop(context);
                // Information about app.
                PackageInfo packageInfo = await PackageInfo.fromPlatform();
                showAboutDialog(
                  context: context,
                  applicationVersion: packageInfo.version,
                  applicationIcon: Container(
                    alignment: Alignment.topLeft,
                    width: 80.0,
                    child: Image(
                      image:
                          AssetImage('assets/icon/golden-helmet-adaptive.png'),
                      fit: BoxFit.fill,
                      alignment: Alignment.topLeft,
                    ),
                  ),
                  children: <Widget>[
                    FlatButton(
                      textTheme: ButtonTextTheme.accent,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.symmetric(
                        horizontal: 0.0,
                        vertical: 0.0,
                      ),
                      onPressed: () async {
                        const url =
                            'https://github.com/LetheanMovement/lethean_exiplorer';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Text('https://github.com/LetheanMovement/lethean_exiplorer'),
                    ),
                  ],
                );
              },
            ),
            if (!Platform.isIOS)
              ListTile(
                leading: Icon(
                  Icons.exit_to_app,
                  color: Theme.of(context).accentColor,
                ),
                title: Text(
                  'Exit',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                onTap: () {
                  // Not allowed on iOS - app will be rejected by Apple if trying.
                  Navigator.pop(context);
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
              ),
          ],
        ),
      ),
      // ),
    );
  }
}
