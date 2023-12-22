import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yorzkha_cos/components/textfield.dart';
import 'package:yorzkha_cos/helper/helper_functions.dart';
import 'package:yorzkha_cos/presentations/pages/forgot_pw_page.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Login Function
  void login() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // pop loading circle
      if (context.mounted) {
        Navigator.pop(context);
      }
      // display error message
    } on FirebaseAuthException catch (e) {
      // pop loading circle
      Navigator.pop(context);
      displayErrorMessage(e.code, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 70),
                // Logo
                Icon(
                  Icons.person,
                  size: 80,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),

                const SizedBox(height: 25),

                // App Name
                const Text(
                  'Y O R Z K H A   C O S R E N T',
                  style: TextStyle(fontSize: 20),
                ),

                const SizedBox(height: 50),

                // Email TextField
                MyTextField(
                  hintText: "Email",
                  obscureText: false,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 10),

                // Password TextField
                MyTextField(
                  hintText: "Password",
                  obscureText: true,
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                ),

                // Forgot Password
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const ForgotPwPage();
                        }));
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: Material(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.secondary,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      splashFactory: InkRipple.splashFactory,
                      splashColor: Theme.of(context).colorScheme.inversePrimary,
                      onTap: () {
                        login();
                      },
                      child: const SizedBox(
                        height: 50, 
                        child: Center(
                          child: Text(
                            'L O G I N',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          )
                        )
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // dont have an account? Register here
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Register Here",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
