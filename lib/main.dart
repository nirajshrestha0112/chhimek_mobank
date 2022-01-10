import 'package:aviation_met_nepal/constant/colors.dart';
import 'package:aviation_met_nepal/constant/routes.dart';
import 'package:aviation_met_nepal/screens/contact_us.dart';
import 'package:aviation_met_nepal/screens/feedback.dart';
import 'package:aviation_met_nepal/screens/home_screen.dart';
import 'package:aviation_met_nepal/screens/login_page.dart';
import 'package:aviation_met_nepal/screens/next_screen.dart';
import 'package:aviation_met_nepal/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Aviation Met Nepal',
          initialRoute: loginScreen,
          routes: {
            homeScreen: (context) => const HomeScreen(),
            nextScreen: (context) => const NextScreen(),
            feedbackScreen: (context) => const FeedBack(),
            contactScreen: (context) => const ContactUs(),
            loginScreen: (context) => const LoginPage()
          },
          theme: ThemeData(),
        );
      });
    });
  }
}
