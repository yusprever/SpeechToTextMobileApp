import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'MyLogin.dart';
import 'firebase_options.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AnimatedSplashScreen(
            duration: 3000,
            splash: Center(
                child:Column(
                  children:[
                    Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Image.asset('assets/voice.png'),
                        SizedBox(width: 15),
                        Text(
                            "Sauti",
                            style: TextStyle(color: Colors.white, letterSpacing: .5,fontSize: 32,fontFamily: 'OdibeeSans-Regular.tff'),



                        ),
                    ],
            ),),

                  Text(
                    "As you speak. So shall it be.",
                    style: TextStyle(fontSize: 12,color: Colors.white),
                  ),
              ],
            ),
            ),
            nextScreen: MyLogin(),
            splashTransition: SplashTransition.fadeTransition,
            pageTransitionType: PageTransitionType.fade,
            backgroundColor: Colors.purple),);
  }
}
