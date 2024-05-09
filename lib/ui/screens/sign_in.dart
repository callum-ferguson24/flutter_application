// Necessary imports
// See docs for more info on imports: https://pub.dev/packages
import 'package:flutter/material.dart';
import 'package:flutter_application/auxilliary/network.dart';
import 'package:flutter_application/ui/root_page.dart';
import 'package:flutter_application/ui/screens/sign_up.dart';
import 'package:page_transition/page_transition.dart';

// UI for the sign in page
class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    // Check if user is logged in
    if (supabase.auth.currentUser == null) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Image.asset('assets/man_bench_circle.png'),

                      // Sign In Text
                      const Text('Sign In',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      
                      // Spacing
                      const SizedBox(
                        height: 30,
                      ),
                      
                      // Email input field
                      TextField(
                        controller: emailController,
                        style: const TextStyle(
                          color: Colors.black54,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(width: 0, style: BorderStyle.none,)),
                          filled: true,
                          prefixIcon: const Icon(Icons.email_rounded, color: Colors.black54),
                          hintText: 'Enter Email'
                        ),
                      ),
                    
                      // Spacing
                      const SizedBox(
                        height: 10,
                      ),
                    
                      
                      // Password input field
                      TextField(
                        controller: passController,
                        obscureText: true,
                        style: const TextStyle(
                          color: Colors.black54,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(width: 0, style: BorderStyle.none,)),
                          filled: true,
                          prefixIcon: const Icon(Icons.lock, color: Colors.black54),
                          hintText: 'Enter Passwords',
                        ),
                      ),

                      // Spacing
                      const SizedBox(
                        height: 10,
                      ),
                    
                      // Sign In Button
                      GestureDetector(
                        onTap: () async {
                            String email = emailController.text;
                            String pass = passController.text;

                            // Check if email is empty
                            if (email.isEmpty || email.trim() == "") {
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Please enter a valid email'),
                                  action: SnackBarAction(
                                    label: 'Dismiss',
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                    }
                                  ),
                                ),
                              );

                            // Check if password is empty
                            } else if (pass.isEmpty || pass.trim() == "") {
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Must enter a password'),
                                  action: SnackBarAction(
                                    label: 'Dismiss',
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                    }
                                  ),
                                ),
                              );

                            // If both email and password are not empty  
                            } else {

                              // Sign in user
                              try{
                                await supabase.auth.signInWithPassword(
                                  email: email,
                                  password: pass,
                                );

                                // ignore: use_build_context_synchronously
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    PageTransition(
                                        child: const RootPage(),
                                        type: PageTransitionType.bottomToTop), (route) => false);

                              // If there is an error
                              } catch (error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Username or password incorrect'),
                                    action: SnackBarAction(
                                      label: 'Dismiss',
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                      }
                                    ),
                                  ),
                                );
                              }

                            }

                        },

                        // Sign in button
                        child: Center(
                          child: Container(
                            width: 400,
                            decoration: BoxDecoration(
                              color: Colors.blue[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                            child: const Center(
                              child: Text('Sign In', style: TextStyle(
                                color:Colors.white,
                                fontSize: 18,
                              ),),
                            ),
                          ),
                        ),
                      ),
                    
                      // Spacing
                      const SizedBox(
                        height: 10,
                      ),
                    
                      // Register button
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context, PageTransition(child: const SignUp(), type: PageTransitionType.bottomToTop));
                        },
                        child: const Center(
                          child: Text.rich(
                            TextSpan(children: [
                              TextSpan(
                                text: 'New to MyFly? ',
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                              TextSpan(
                                text: 'Create Account',
                                style: TextStyle(
                                  color: Colors.lightBlue,
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ), 
                                   
                    ],
                  ),
                ]
              ),
            ),
          ),
        ),   
      );
    } else {

      // If user is logged in when they visit the page
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: SafeArea(
            child: GestureDetector(
              onTap: () async {
                await supabase.auth.signOut();
                // ignore: use_build_context_synchronously
                Navigator.pushAndRemoveUntil(
                  context,
                  PageTransition(
                    child: const RootPage(),
                    type: PageTransitionType.bottomToTop), (route) => false);
              },
              child: const Center(
                child: Text.rich(
                  TextSpan(children: [
                    TextSpan(
                      text: 'Welcome, ',
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                    TextSpan(
                      text: 'Logout',
                      style: TextStyle(
                        color: Colors.lightBlue,
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          )
        )
      );
    }
  }
}