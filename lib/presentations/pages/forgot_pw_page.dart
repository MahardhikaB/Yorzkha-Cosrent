import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yorzkha_cos/components/button.dart';
import 'package:yorzkha_cos/components/textfield.dart';
import 'package:yorzkha_cos/helper/helper_functions.dart';

class ForgotPwPage extends StatefulWidget {
  const ForgotPwPage({super.key});



  @override
  State<ForgotPwPage> createState() => _ForgotPwPageState();
}

class _ForgotPwPageState extends State<ForgotPwPage> {

  // Emal Controllers
  final TextEditingController emailController = TextEditingController();

  // Reset Password Function
  void resetPassword() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // try to send password reset email
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text,
      );
      // pop loading circle
      if (context.mounted) {
        Navigator.pop(context);
      }
      // display success message
      displaySuccessMessage("Password reset email sent", context);
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
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: Colors.blueGrey[700],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyTextField(
            hintText: "Email",
            obscureText: false,
            controller: emailController
          ),
          MyButton(
            text: "Reset Now", 
            onTap: resetPassword
          ),
        ],
      ),
    );
  }
}