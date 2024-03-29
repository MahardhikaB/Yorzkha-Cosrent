import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yorzkha_cos/components/button.dart';
import 'package:yorzkha_cos/components/textfield.dart';
import 'package:yorzkha_cos/helper/helper_functions.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Text Controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();


  // Register Function
  void registerUser() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Make sure Password and Confirm Password match
    if (passwordController.text != confirmPwController.text) {
      // pop loading circle
      Navigator.pop(context);

      // show error message
      displayErrorMessage("Passwords do not match", context);


      // if password and confirm password match
    } else {
      // Try to register user
      try {
        // create user
        UserCredential? userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // pop loading circle
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        // pop loading circle
        Navigator.pop(context);
        // display error message
        displayErrorMessage(e.code, context);
        // set button to not pressed
      }
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

                // Username TextField
                MyTextField(
                  hintText: "Username",
                  obscureText: false,
                  controller: usernameController,
                  keyboardType: TextInputType.text,
                ),

                const SizedBox(height: 10),

                // Email TextField
                MyTextField(
                  hintText: "Email",
                  obscureText: false,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress
                ),

                const SizedBox(height: 10),

                // Password TextField
                MyTextField(
                  hintText: "Password",
                  obscureText: true,
                  controller: passwordController,
                  keyboardType: TextInputType.text
                ),

                const SizedBox(height: 10),

                // Confirm Password TextField
                MyTextField(
                  hintText: "Confirm Password",
                  obscureText: true,
                  controller: confirmPwController,
                  keyboardType: TextInputType.text
                ),

                const SizedBox(height: 25),

                // register Button
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
                        registerUser();
                      },
                      child: const SizedBox(
                        height: 50, 
                        child: Center(
                          child: Text(
                            'R E G I S T E R',
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

                // Already have an account? Login here
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Login Here",
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
