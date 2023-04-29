import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const List<Widget> kUsers = <Widget>[
  Icon(Icons.person),
  Icon(Icons.admin_panel_settings),
];

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = "";
  String password = "";
  String confirmPassword = "";
  bool isLoading = false;
  bool isLoginScreen = true;
  final List<bool> _selectedUser = <bool>[true, false];

  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      isLoading = true;
    });

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Passwords do not match!"),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );

      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      if (isLoginScreen) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
    } on FirebaseAuthException catch (error) {
      var message = "An error occurred, please check your credentials!";

      if (error.message != null) {
        message = error.message!;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  setState(() {
                    isLoginScreen = !isLoginScreen;
                  });
                },
                child: Text(isLoginScreen ? "Sign Up" : "Sign In"),
              ),
            ),
            if (isLoginScreen)
              Text(
                _selectedUser[0] ? "Login" : "Admin Login",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
              )
            else
              Text(
                "Register",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
              ),
            if (isLoginScreen)
              ToggleButtons(
                  onPressed: (int index) {
                    setState(() {
                      // The button that is tapped is set to true, and the others to false.
                      for (int i = 0; i < _selectedUser.length; i++) {
                        _selectedUser[i] = i == index;
                      }
                    });
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: Colors.blue[700],
                  selectedColor: Colors.white,
                  fillColor: Colors.blue[200],
                  color: Colors.blue[400],
                  isSelected: _selectedUser,
                  children: const <Widget>[
                    Icon(Icons.person),
                    Icon(Icons.admin_panel_settings),
                  ]),
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter an email";
                        }
                        if (!value.contains("@")) {
                          return "Please enter a valid email";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        email = value!;
                      },
                      decoration: const InputDecoration(
                        labelText: "Email",
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a password";
                        }
                        if (value.length < 8) {
                          return "Password must be at least 8 characters long";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        password = value!;
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                      ),
                    ),
                    if (!isLoginScreen)
                      const SizedBox(height: 10),
                    if (!isLoginScreen)
                      TextFormField(
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a password";
                          }
                          if (value.length < 8) {
                            return "Password must be at least 8 characters long";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          confirmPassword = value!;
                        },
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Confirm Password",
                        ),
                      )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                    side: const BorderSide(width: 4),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    )),
                child: Text(
                  isLoginScreen ? "Login" : "Register",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                ),
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
