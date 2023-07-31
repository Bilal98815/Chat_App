import 'package:chat_app/login/bloc/login_bloc.dart';
import 'package:chat_app/login/bloc/login_bloc_state.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/shared_preferences/shared_preferences.dart';
import 'package:chat_app/signup/signup_view.dart';
import 'package:chat_app/users/users_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();
  final Preferences prefs = Preferences();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: width,
                  height: height * 0.3,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40)),
                    color: Color(0xFF1D1A3D),
                  ),
                  child: Center(
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: font * 30,
                      ),
                    ),
                  ),),
                SizedBox(
                  height: height * 0.07,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                  child: TextFormField(
                    controller: emailController,
                    validator: (val) => val!.isEmpty ? "Enter email!" : null,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.email_outlined),
                      labelText: 'Email',
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(35)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                BlocBuilder<LoginBloc, LoginBlocState>(
                  builder: (context, state) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                      child: TextFormField(
                        obscureText: !state.showPassword,
                        controller: passwordController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Enter password!";
                          } else if (val.length < 6) {
                            return "please enter more than 6 digits";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          icon: InkWell(
                              onTap: () {
                                context.read<LoginBloc>().showPassword();
                              },
                              child: const Icon(Icons.lock)),
                          labelText: 'Password',
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(35)),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Row(
                    children: [
                      BlocBuilder<LoginBloc, LoginBlocState>(
                        builder: (context, state){
                          return Checkbox(value: state.keepLoggedIn, onChanged: (value) {
                            debugPrint('-------->>>>>>>IN CHECKBOX');
                            emailId = emailController.text;
                            debugPrint('-------->>>>>>> BEFORE: $value');
                            context.read<LoginBloc>().keepLoggedIn();
                            value = state.keepLoggedIn;
                            debugPrint('-------->>>>>>> AFTER: $value');
                            if(!value){
                              debugPrint('-------->>>>>>>IN IF OF CHECKBOX');
                              prefs.setUserDetails();
                            }
                          },
                            activeColor: const Color(0xFF1D1A3D),
                          );
                        },
                      ),
                      const Text('Keep me logged in', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.12,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                  child: SizedBox(
                    width: width,
                    child: BlocConsumer<LoginBloc, LoginBlocState>(
                      listener: (context, state) {
                        if (state.authApiState == APIState.error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                state.errorMessage,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        } else if (state.authApiState == APIState.done) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UsersView(
                                  email: emailController.text.trim()),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        return FloatingActionButton(
                          onPressed: () {
                            if (!formKey.currentState!.validate()) {
                              context
                                  .read<LoginBloc>()
                                  .updateError('Enter correct credentials');
                            } else {
                              context.read<LoginBloc>().login(
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                  );
                            }
                          },
                          backgroundColor: const Color(0xFF1D1A3D),
                          child: Center(
                            child: state.authApiState == APIState.loading
                                ? const CircularProgressIndicator()
                                : const Text(
                                    'Login',
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have account?'),
                      SizedBox(
                        width: width * 0.04,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpView(),
                            ),
                          );
                        },
                        child: const Text(
                          'Signup',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.08,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
