import 'package:bigtalk/core/common/snackbar/my_snackbar.dart';
import 'package:bigtalk/features/auth/domain/entity/auth_entity.dart';
import 'package:bigtalk/features/auth/presentation/auth_viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/routes/routes.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _key = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.watch(authViewModelProvider).showMessage!) {
        showSnackBar(message: 'User Registerd Successfully', context: context);
        ref.read(authViewModelProvider.notifier).resetMessage();
      }
    });
    return Scaffold(
      backgroundColor: Colors.black, // Set the background color to black
      body: Center(
        child: SingleChildScrollView(
          // Wrap with SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _key,
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
                    'Join Us Today!',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.all(12), // Adjust content padding
                        hintText: 'Enter your name',
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
                      validator: ((value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      }),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16), // Set text color and size
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                      controller: userNameController,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.all(12), // Adjust content padding
                        hintText: 'Enter your username',
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
                      validator: ((value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      }),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16), // Set text color and size
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: TextFormField(
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
                      validator: ((value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                        return null;
                      }),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16), // Set text color and size
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: isObscure,

                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.all(12), // Adjust content padding
                        hintText: 'Create a password',
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
                      onPressed: () {
                        if (_key.currentState!.validate()) {
                          final entity = AuthEntity(
                            name: nameController.text,
                            username: nameController.text,
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          // Register user
                          ref
                              .read(authViewModelProvider.notifier)
                              .registerUser(entity);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.white, // Set button color to white
                      ),
                      child: const Text("Sign Up",
                          style: TextStyle(color: Colors.black, fontSize: 18)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, AppRoute.loginScreenRoute);
                        },
                        child: const Text(
                          "Log in",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red, // Set text color to white
                            fontSize: 16, // Set text size
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
      ),
    );
  }
}
