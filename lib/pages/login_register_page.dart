import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:futsal_management/authentication/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isObscure = true;

  bool isForgetPasswordClicked = false;

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> sendPasswordResetEmail() async {
    try {
      await Auth().sendPasswordResetEmail(
        email: confirmPasswordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
    IconData? icon,
    bool isPassword,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? isObscure : false,
        decoration: InputDecoration(
          labelText: title,
          prefixIcon: Icon(icon),
          suffixIcon: isPassword
              ? IconButton(
                  icon:
                      Icon(isObscure ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }

  Widget _errorMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        errorMessage ?? 'Error',
        style: TextStyle(
          color: Colors.red,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: () {
        if (isLogin) {
          signInWithEmailAndPassword();
        } else {
          createUserWithEmailAndPassword();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        isLogin ? 'Login' : 'Register',
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(
        isLogin ? 'Register Instead' : 'Login Instead',
        style: TextStyle(
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Futsal Management',
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isForgetPasswordClicked) ...[
              if (!isLogin)
                _entryField(
                  'Name',
                  nameController,
                  Icons.person,
                  false,
                ),
              _entryField(
                'Email',
                emailController,
                Icons.email,
                false,
              ),
              _entryField(
                'Password',
                passwordController,
                Icons.lock,
                true,
              ),
              _errorMessage(),
              _submitButton(),
              const SizedBox(height: 10),
              _loginOrRegisterButton(),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  setState(() {
                    isForgetPasswordClicked = true;
                  });
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ],
            if (isForgetPasswordClicked) ...[
              _entryField(
                'Email',
                confirmPasswordController,
                Icons.email,
                false,
              ),
              _errorMessage(),
              ElevatedButton(
                onPressed: () {
                  sendPasswordResetEmail().then((value) {
                    SnackBar snackBar = const SnackBar(
                        content: Text('Password reset email sent!'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Send Password Reset Email',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  setState(() {
                    isForgetPasswordClicked = false;
                  });
                },
                child: const Text(
                  'Back to Login',
                  style: TextStyle(
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
