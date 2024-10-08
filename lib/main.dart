import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:listen/login/onboard.dart';
import 'package:listen/homepage_app.dart';
import 'package:listen/login/login.dart';
import 'package:listen/models/user_app.dart';
import 'package:listen/modules/color_mode.dart';
import 'package:listen/services/auth.dart';
import 'package:listen/services/db.dart';
import 'package:listen/services/navbar_logic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp();
  await FirebaseAppCheck.instanceFor(app: app).activate(
    androidProvider:
        !kDebugMode ? AndroidProvider.playIntegrity : AndroidProvider.debug,
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<Auth>(create: (ctx) => Auth()),
    ChangeNotifierProvider<ColorMode>(create: (ctx) => ColorMode()),
    ChangeNotifierProvider<NavbarLogic>(create: (ctx) => NavbarLogic())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Consumer<Auth>(builder: (context, auth, _) {
      return StreamBuilder<User?>(
          stream: auth.authState(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (ctx) => Database(
                        phoneNum: auth.phoneNumber.text,
                        currentUseruid: snapshot.data!.uid),
                  ),
                ],
                child: Consumer<Database>(builder: (context, db, _) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: ThemeData(
                      textTheme:
                          GoogleFonts.ptSansTextTheme(textTheme).copyWith(
                        bodyLarge:
                            GoogleFonts.ptSerif(textStyle: textTheme.bodyLarge),
                        headlineLarge: GoogleFonts.ptSerif(
                            textStyle: textTheme.headlineLarge),
                        headlineMedium: GoogleFonts.ptSerif(
                            textStyle: textTheme.headlineMedium),
                        displayLarge: GoogleFonts.ptSerif(
                            textStyle: textTheme.displayLarge),
                        displaySmall: GoogleFonts.ptSerif(
                            textStyle: textTheme.displaySmall),
                        bodyMedium: GoogleFonts.ptSerif(
                            textStyle: textTheme.bodyMedium),
                      ),
                      colorScheme: ColorScheme.fromSeed(
                          seedColor: Colors.greenAccent,
                          primary: Colors.green,
                          brightness: Brightness.light),
                      useMaterial3: true,
                    ),
                    home: StreamBuilder<FUsers>(
                      stream: db.getUser(
                          db.currentUseruid), // The stream from Firebase
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Scaffold(
                            body: Center(child: CircularProgressIndicator()),
                          );
                        } else if (snapshot.hasData) {
                          return snapshot.data!.uid.isEmpty
                              ? const Onboard()
                              : Provider<FUsers>.value(
                                  value: snapshot.data!,
                                  child: const HomePage());
                        } else {
                          return const Scaffold(
                            body:
                                Center(child: Text("Something Went Wrong :(")),
                          );
                        }
                      },
                    ),
                  );
                }),
              );
            } else {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  textTheme: GoogleFonts.ptSansTextTheme(textTheme).copyWith(
                    bodyLarge:
                        GoogleFonts.ptSerif(textStyle: textTheme.bodyLarge),
                    headlineLarge:
                        GoogleFonts.ptSerif(textStyle: textTheme.headlineLarge),
                    headlineMedium: GoogleFonts.ptSerif(
                        textStyle: textTheme.headlineMedium),
                    displayLarge:
                        GoogleFonts.ptSerif(textStyle: textTheme.displayLarge),
                    displaySmall:
                        GoogleFonts.ptSerif(textStyle: textTheme.displaySmall),
                    bodyMedium:
                        GoogleFonts.ptSerif(textStyle: textTheme.bodyMedium),
                  ),
                  colorScheme: ColorScheme.fromSeed(
                      seedColor: Colors.green.shade900,
                      brightness: Brightness.light),
                  useMaterial3: true,
                ),
                home: const HelloScreen(),
              );
            }
          });
    });
  }
}
