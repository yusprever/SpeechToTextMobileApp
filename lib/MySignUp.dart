import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'MyLogin.dart';


class MySignUp extends StatelessWidget {
  const MySignUp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: const signUpStatefulWidget(),
      ),
    );
  }
}

class signUpStatefulWidget extends StatefulWidget {
  const signUpStatefulWidget({Key? key}) : super(key: key);

  @override
  State<signUpStatefulWidget> createState() => _MySignUpState();
}

class _MySignUpState extends State<signUpStatefulWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();
  Color myColor = Color(0xff4F1EA6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body:Container(
        padding: EdgeInsets.fromLTRB(10, 220, 10, 0),
        height: 650,

        child:Center(
          child: Card(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: ListView(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          'Sign up',
                          style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                        )),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',

                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: TextField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                      ),
                    ),
                    // Container(
                    //   padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    //   child:Column(
                    //   children: [
                    //     TextField(
                    //       obscureText: true,
                    //       controller: passwordController2,
                    //       decoration: const InputDecoration(
                    //         border: OutlineInputBorder(),
                    //         labelText: 'Confirm Password',
                    //       ),
                    //     ),
                    //
                    //
                    //   ],
                    // )),
                    Container(
                        height: 60,
                        padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                        child: ElevatedButton(
                          child: const Text('Sign Up'),
                          onPressed: () async {
                            try {
                               await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>  MyLogin()));
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                print('The password provided is too weak.');
                              } else if (e.code == 'email-already-in-use') {
                                print('The account already exists for that email.');
                              }
                            } catch (e) {
                              print(e);
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(myColor)),
                        )
                    ),
                  ],
                )),

          ),
        ),
      ),);
  }
}
