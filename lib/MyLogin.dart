import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'MainScreen.dart';
import 'MySignUp.dart';

class MyLogin extends StatelessWidget {
  const MyLogin({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: const loginStatefulWidget(),
      ),
    );
  }
}

class loginStatefulWidget extends StatefulWidget {
  const loginStatefulWidget({Key? key}) : super(key: key);

  @override
  State<loginStatefulWidget> createState() => _MyLoginState();
}

class _MyLoginState extends State<loginStatefulWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Color myColor = Color(0xff4F1EA6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body:Container(
        padding: EdgeInsets.fromLTRB(10, 220, 10, 0),
        height: 600,

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
                          'Log in',
                          style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                        )),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',

                        ),
                        // autovalidateMode: AutovalidateMode.onUserInteraction,
                        // validator: (emailController) =>
                        // emailController != null && !EmailValidator.validate(emailController)
                        // ? 'Enter a valid email'
                        // :null,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                      ),
                    ),
                    Container(
                        height: 60,
                        padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                        child: ElevatedButton(
                          child: const Text('Login'),
                          onPressed: () async {
                            try {
                              await FirebaseAuth.instance.signInWithEmailAndPassword(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>  MainScreen()));

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
                    Row(
                      children: <Widget>[
                        const Text('Does not have account?'),
                        TextButton(
                          child: const Text(
                            'Sign up',
                            style: TextStyle(fontSize: 17),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>  MySignUp()),
                            );
                          },

                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ],
                )),

          ),
        ),
      ),);
  }
}