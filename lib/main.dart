import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:listen/login/onboard.dart';
import 'package:listen/homepage_app.dart';
import 'package:listen/login/login.dart';
import 'package:listen/models/user_app.dart';
import 'package:listen/modules/color_mode.dart';
import 'package:listen/services/auth.dart';
import 'package:listen/services/dashboard_logic.dart';
import 'package:listen/services/db.dart';
import 'package:listen/services/navbar_logic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBH--jnHQUTu4hWUV_l9Zv9UZ0P-7Kzhcw",
        appId: "1:875975776708:android:7f18a6b4bf026ec4756c91",
        messagingSenderId: "875975776708",
        storageBucket: "listen-57bf4.appspot.com",
        projectId: "listen-57bf4"),
  );
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider:
        kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
  );

  final navkey = GlobalKey<NavigatorState>();
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navkey);
  ZegoUIKit().initLog().then((value) {
    ZegoUIKitPrebuiltCallInvitationService()
        .useSystemCallingUI([ZegoUIKitSignalingPlugin()]);

    runApp(MultiProvider(providers: [
      ChangeNotifierProvider<Auth>(create: (ctx) => Auth()),
      ChangeNotifierProvider<ColorMode>(create: (ctx) => ColorMode()),
      ChangeNotifierProvider<NavbarLogic>(create: (ctx) => NavbarLogic())
    ], child: MyApp(navKey: navkey)));
  });
}
//android folderj
class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navKey;
  const MyApp({super.key, required this.navKey});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Database(
            phoneNum: "9999780803",
            currentUseruid: "EWaa6QEIrggJWzihp8oIcQnDFNE3",
          ),
        ),
      ],
      child: Consumer<Database>(builder: (context, db, _) {
        return MaterialApp(
          navigatorKey: navKey,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: GoogleFonts.ptSansTextTheme(textTheme).copyWith(
              bodyLarge: GoogleFonts.ptSerif(textStyle: textTheme.bodyLarge),
              headlineLarge:
                  GoogleFonts.ptSerif(textStyle: textTheme.headlineLarge),
              headlineMedium:
                  GoogleFonts.ptSerif(textStyle: textTheme.headlineMedium),
              displayLarge:
                  GoogleFonts.ptSerif(textStyle: textTheme.displayLarge),
              displaySmall:
                  GoogleFonts.ptSerif(textStyle: textTheme.displaySmall),
              bodyMedium: GoogleFonts.ptSerif(textStyle: textTheme.bodyMedium),
            ),
            colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.greenAccent,
                primary: Colors.green,
                brightness: Brightness.light),
            useMaterial3: true,
          ),
          home: StreamBuilder<FUsers>(
            stream: db.getUser(db.currentUseruid), // The stream from Firebase
            builder: (context, dbsnapshot) {
              if (dbsnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (dbsnapshot.hasData) {
                if (dbsnapshot.data!.uid.isEmpty) {
                  return const Onboard();
                } else {
                  ZegoUIKitPrebuiltCallInvitationService().init(
                      appID: 296367504 /*input your AppID*/,
                      appSign:
                          "a097d1afc5e36a299e4696425be48d8dd6731851d37f451cd30d980f8cb5b2ef" /*input your AppSign*/,
                      userID: dbsnapshot.data!.uid,
                      userName: dbsnapshot.data!.name,
                      plugins: [ZegoUIKitSignalingPlugin()],
                      innerText: ZegoCallInvitationInnerText(
                          systemAlertWindowConfirmDialogSubTitle: ""),
                      config: ZegoCallInvitationConfig(
                        permissions: [
                          ZegoCallInvitationPermission.camera,
                          ZegoCallInvitationPermission.microphone,
                        ],
                      ),
                      uiConfig: ZegoCallInvitationUIConfig(
                        prebuiltWithSafeArea: true,
                      ));
                  return Provider<FUsers>.value(
                    value: dbsnapshot.data!,
                    child: ChangeNotifierProvider(
                        create: (ctx) => DailyTipsNotifier(db: db),
                        child: const HomePage()),
                  );
                }
              } else {
                return const Scaffold(
                  body: Center(child: Text("Something Went Wrong :(")),
                );
              }
            },
          ),
        );
      }),
    );
    // return Consumer<Auth>(builder: (context, auth, _) {
    //   return StreamBuilder<User?>(
    //       stream: auth.authState(),
    //       builder: (context, snapshot) {
    //         if (snapshot.hasData) {
    //           return MultiProvider(
    //             providers: [
    //               ChangeNotifierProvider(
    //                 create: (ctx) => Database(
    //                   phoneNum: snapshot.data!.phoneNumber == null
    //                       ? ""
    //                       : snapshot.data!.phoneNumber!,
    //                   currentUseruid: snapshot.data!.uid,
    //                 ),
    //               ),
    //             ],
    //             child: Consumer<Database>(builder: (context, db, _) {
    //               return MaterialApp(
    //                 navigatorKey: navKey,
    //                 debugShowCheckedModeBanner: false,
    //                 theme: ThemeData(
    //                   textTheme:
    //                       GoogleFonts.ptSansTextTheme(textTheme).copyWith(
    //                     bodyLarge:
    //                         GoogleFonts.ptSerif(textStyle: textTheme.bodyLarge),
    //                     headlineLarge: GoogleFonts.ptSerif(
    //                         textStyle: textTheme.headlineLarge),
    //                     headlineMedium: GoogleFonts.ptSerif(
    //                         textStyle: textTheme.headlineMedium),
    //                     displayLarge: GoogleFonts.ptSerif(
    //                         textStyle: textTheme.displayLarge),
    //                     displaySmall: GoogleFonts.ptSerif(
    //                         textStyle: textTheme.displaySmall),
    //                     bodyMedium: GoogleFonts.ptSerif(
    //                         textStyle: textTheme.bodyMedium),
    //                   ),
    //                   colorScheme: ColorScheme.fromSeed(
    //                       seedColor: Colors.greenAccent,
    //                       primary: Colors.green,
    //                       brightness: Brightness.light),
    //                   useMaterial3: true,
    //                 ),
    //                 home: StreamBuilder<FUsers>(
    //                   stream: db.getUser(
    //                       db.currentUseruid), // The stream from Firebase
    //                   builder: (context, dbsnapshot) {
    //                     if (dbsnapshot.connectionState ==
    //                         ConnectionState.waiting) {
    //                       return const Scaffold(
    //                         body: Center(child: CircularProgressIndicator()),
    //                       );
    //                     } else if (dbsnapshot.hasData) {
    //                       if (dbsnapshot.data!.uid.isEmpty) {
    //                         return const Onboard();
    //                       } else {
    //                         ZegoUIKitPrebuiltCallInvitationService().init(
    //                             appID: 1491639421 /*input your AppID*/,
    //                             appSign:
    //                                 "f6b11adcf1935b18e25836bc428e3e48e7f89cf49e5d7092f2c9bf2d2df97572" /*input your AppSign*/,
    //                             userID: dbsnapshot.data!.uid,
    //                             userName: dbsnapshot.data!.name,
    //                             plugins: [ZegoUIKitSignalingPlugin()],
    //                             uiConfig: ZegoCallInvitationUIConfig(
    //                               prebuiltWithSafeArea: true,
    //                             ));
    //                         return Provider<FUsers>.value(
    //                           value: dbsnapshot.data!,
    //                           child: const HomePage(),
    //                         );
    //                       }
    //                     } else {
    //                       return const Scaffold(
    //                         body:
    //                             Center(child: Text("Something Went Wrong :(")),
    //                       );
    //                     }
    //                   },
    //                 ),
    //               );
    //             }),
    //           );
    //         } else {
    //           return MaterialApp(
    //             debugShowCheckedModeBanner: false,
    //             theme: ThemeData(
    //               textTheme: GoogleFonts.ptSansTextTheme(textTheme).copyWith(
    //                 bodyLarge:
    //                     GoogleFonts.ptSerif(textStyle: textTheme.bodyLarge),
    //                 headlineLarge:
    //                     GoogleFonts.ptSerif(textStyle: textTheme.headlineLarge),
    //                 headlineMedium: GoogleFonts.ptSerif(
    //                     textStyle: textTheme.headlineMedium),
    //                 displayLarge:
    //                     GoogleFonts.ptSerif(textStyle: textTheme.displayLarge),
    //                 displaySmall:
    //                     GoogleFonts.ptSerif(textStyle: textTheme.displaySmall),
    //                 bodyMedium:
    //                     GoogleFonts.ptSerif(textStyle: textTheme.bodyMedium),
    //               ),
    //               colorScheme: ColorScheme.fromSeed(
    //                   seedColor: Colors.green.shade900,
    //                   brightness: Brightness.light),
    //               useMaterial3: true,
    //             ),
    //             home: const HelloScreen(),
    //           );
    //         }
    //       });
    // });
  }
}
