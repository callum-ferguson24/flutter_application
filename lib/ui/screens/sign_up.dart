// Necessary imports
// See docs for more info on imports: https://pub.dev/packages
import 'package:flutter/material.dart';
import 'package:flutter_application/auxilliary/network.dart';
import 'package:flutter_application/ui/root_page.dart';
import 'package:flutter_application/ui/screens/sign_in.dart';
import 'package:page_transition/page_transition.dart';


// Class to represent the sign up page
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final passTwoController = TextEditingController();
  final nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                    
                    // Sign Up image and text
                    Image.asset('assets/man_bench_circle.png'),
                    const Text('Sign Up',
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
                        prefixIcon: const Icon(Icons.email, color: Colors.black54),
                        hintText: 'Enter Email'
                      ),
                    ),

                    // Spacing
                    const SizedBox(
                      height: 10,
                    ),

                    // Name input field     
                    TextField(
                      controller: nameController,
                      style: const TextStyle(
                        color: Colors.black54,
                      ),
                      decoration: InputDecoration(
                         border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(width: 0, style: BorderStyle.none,)),
                        filled: true,
                        prefixIcon: const Icon(Icons.email, color: Colors.black54),
                        hintText: 'Enter Name'
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
                        prefixIcon: const Icon(Icons.email, color: Colors.black54),
                        hintText: 'Enter Password'
                      ),
                    ),

                    // Spacing
                    const SizedBox(
                      height: 10,
                    ),
                    
                    // Password check input field
                    TextField(
                      controller: passTwoController,
                      obscureText: true,
                      style: const TextStyle(
                        color: Colors.black54,
                      ),
                      decoration: InputDecoration(
                         border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(width: 0, style: BorderStyle.none,)),
                        filled: true,
                        prefixIcon: const Icon(Icons.email, color: Colors.black54),
                        hintText: 'Re-Enter Password'
                      ),
                    ),
                  
                    // Spacing 
                    const SizedBox(
                      height: 10,
                    ),
                  
                    //Sign up button
                    GestureDetector(

                      onTap: () async {
                          String email = emailController.text;
                          String pass = passController.text;
                          String passTwo = passTwoController.text;
                          String name = nameController.text;

                          // Check if the passwords match
                          if (pass != passTwo) {
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Passwords do not match'),
                                action: SnackBarAction(
                                  label: 'Dismiss',
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  }
                                ),
                              ),
                            );

                          // Check if the email is empty
                          } else if (email.isEmpty || email.trim() == "") {

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Please enter a valid email address'),
                                action: SnackBarAction(
                                  label: 'Dismiss',
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  }
                                ),
                              ),
                            );

                          // Check if the password is long enough
                          } else if (pass.length < 8) {

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Please enter a password with at least 8 characters'),
                                action: SnackBarAction(
                                  label: 'Dismiss',
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  }
                                ),
                              ),
                            );

                          // Check if the name is empty
                          } else if (name.isEmpty || name.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Please enter a valid name'),
                                action: SnackBarAction(
                                  label: 'Dismiss',
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  }
                                ),
                              ),
                            );

                          // Check if the password is strong enough (At least one uppercase, one lowercase, and one number)
                          } else if (!isStrongPassword(pass)) {

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Passwords must contain, at least, one uppercase letter, one lowercase letter and one number'),
                                action: SnackBarAction(
                                  label: 'Dismiss',
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  }
                                ),
                              ),
                            );

                          // If all checks pass, sign up the user
                          } else {

                            await supabase.auth.signUp(
                              email: email,
                              password: pass,
                            );

                            String userId = supabase.auth.currentUser!.id;
                            await supabase
                            .from('profiles')
                            .insert({'id': userId, 'username': name});

                            // ignore: use_build_context_synchronously
                            Navigator.pushAndRemoveUntil(
                                context,
                                PageTransition(
                                    child: const RootPage(),
                                    type: PageTransitionType.bottomToTop), (route) => false);
                            
                          }

                      },
                      child: Container(
                        width: 400,
                        decoration: BoxDecoration(
                          color: Colors.blue[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        child: const Center(
                          child: Text('Sign Up', style: TextStyle(
                            color:Colors.white,
                            fontSize: 18,
                          ),),
                        ),
                      ),
                    ),
                  
                    // Spacing
                    const SizedBox(
                      height: 10,
                    ),
                  
                    // Already have an account? Sign in button
                     GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context, PageTransition(child: const SignIn(), type: PageTransitionType.bottomToTop));
                        },
                        child: const Center(
                          child: Text.rich(
                            TextSpan(children: [
                              TextSpan(
                                text: 'Already have an Account? ',
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                              TextSpan(
                                text: 'Login',
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
  }

  // Function to check if the password is strong enough
    bool isStrongPassword(String password) {
    //Define password requirements to check against
    RegExp upperCase = RegExp(r'[A-Z]');
    RegExp lowerCase = RegExp(r'[a-z]');
    RegExp digit = RegExp(r'[0-9]');

    //Check if the password meets all requirements
    return upperCase.hasMatch(password) &&
          lowerCase.hasMatch(password) &&
          digit.hasMatch(password);
  }

}