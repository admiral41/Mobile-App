import 'package:bigtalk/config/routes/routes.dart';
import 'package:bigtalk/core/common/snackbar/my_snackbar.dart';
import 'package:bigtalk/features/auth/presentation/auth_viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authState.showMessage! && authState.error != null) {
        showSnackBar(
            message: 'Invalid Credentials',
            color: Colors.red,
            context: context);
        ref.read(authViewModelProvider.notifier).resetMessage();
      }
    });
    return Scaffold(
      backgroundColor: Colors.black, // Set the background color to black
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            // Wrap with SingleChildScrollView
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/Logo.png',
                      // Adjust the image width
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Where Conversations Come Alive!',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                      key: const ValueKey('email'),
                      controller: emailController,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.all(12), // Adjust content padding
                        hintText: 'Enter your email',
                        hintStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Add border radius
                          borderSide: const BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Add border radius
                          borderSide: const BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter email';
                        }
                        return null;
                      },
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16), // Set text color and size
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                      key: const ValueKey('password'),
                      controller: passwordController,
                      obscureText: isObscure,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.all(12), // Adjust content padding
                        hintText: 'Enter your password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            isObscure ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                        ),
                        hintStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Add border radius
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Add border radius
                          borderSide: const BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      validator: ((value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      }),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16), // Set text color and size
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await ref
                              .read(authViewModelProvider.notifier)
                              .loginUser(
                                context,
                                emailController.text,
                                passwordController.text,
                              );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.white, // Set button color to white
                      ),
                      child: const Text("Login",
                          style: TextStyle(color: Colors.black, fontSize: 18)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, AppRoute.forgotPasswordScreenRoute);
                        },
                        child: const Text(
                          'Forgot password ?',
                          style: TextStyle(
                            color: Colors.white, // Set text color to white
                            fontSize: 16, // Set text size
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, AppRoute.singupScreenRoute);
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red, // Set text color to white
                            fontSize: 16, // Set text size
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
