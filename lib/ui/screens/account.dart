// Necessary imports
// See docs for more info on imports: https://pub.dev/packages
import 'package:flutter/material.dart';
import 'package:flutter_application/auxilliary/network.dart';
import 'package:flutter_application/ui/root_page.dart';
import 'package:flutter_application/ui/screens/edit_info.dart';
import 'package:flutter_application/ui/screens/sign_in.dart';
import 'package:flutter_application/ui/screens/sign_up.dart';
import 'package:page_transition/page_transition.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Class to represent the Account page
// This class is used to display the user's account information and appropriate options
class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  // Instance of supabase client initialized

  @override
  Widget build(BuildContext context) {
    // Fetch the screen size for responsive layout purposes.
    Size screenSize = MediaQuery.of(context).size;

    // Check if a user is logged in and display appropriate UI
    if(supabase.auth.currentUser != null) {
      return accountLoggedIn(context, screenSize);
    } else {
      return accountNotLoggedIn(context, screenSize); 
    }

  }
}

// Asynchronous method to fetch 'username' from 'profiles' table in Supabase filtered by 'id' field.
getData (String userId) async {
  var data = await Supabase.instance.client
    .from('profiles')
    .select('username')
    .eq('id', userId);
    return data;
}

// UI for when the user is logged in
accountLoggedIn(context, Size size) {
  String userId = supabase.auth.currentUser!.id;
  final User? user = supabase.auth.currentUser;
  
  return FutureBuilder(
    future: getData(userId),
    builder: (context, userData) {
      if(userData.hasData){
      var output = userData.data as List<dynamic>;
      String name = output[0]['username']; //Current user's username
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // Display current user's profile picture
              Container(
                width: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey,
                    width: 5.0,
                  ),
                ),
                child: FutureBuilder(
                  future: getDatabaseImage(user!.id),
                  builder: (BuildContext context, AsyncSnapshot imageSnapshot) {
                    if(imageSnapshot.hasData) {
                      return CircleAvatar(
                        radius: 60,
                        backgroundImage: MemoryImage(imageSnapshot.data),
                      );
                    } else {
                      return const CircleAvatar(
                        radius: 60,
                        backgroundImage: ExactAssetImage('assets/blank_profile.png'),
                      );
                    }
                  },
                ),
              ),

              // Spacing
              const SizedBox(
                height: 15,
              ),

              // Display current user's name
              SizedBox(
                width: size.width * 0.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),

              // Display current user's email
              Text(
                user.userMetadata?['email'],
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),

              // Spacing
              const SizedBox(
                height: 30,
              ),

              // Display list of account options
              SizedBox(
                height: size.height * 0.8,
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    
                    // Option to edit profile
                    GestureDetector(
                      onTap: () {
                          Navigator.push(
                          context, PageTransition(child: EditInfo(name), type: PageTransitionType.rightToLeft));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 25),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Colors.black87,
                                  size: 24,
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  'My Profile',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black87,
                              size: 18,
                            )
                          ],
                        ),
                      ),
                    ),
        
                    // Option to logout
                    GestureDetector(
                      onTap: () async {
                        await supabase.auth.signOut();
                          // ignore: use_build_context_synchronously
                          Navigator.pushAndRemoveUntil(
                            context, PageTransition(child: const RootPage(), type: PageTransitionType.bottomToTop), (route) => false
                          );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 25),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: Colors.black87,
                                  size: 24,
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  'Log Out',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black87,
                              size: 18,
                            )
                          ],
                        ),
                      ),
                    ),
        
                  ],
                ),
              ),


            ],
          ),
        ),
      );
      } else {
        return const Center(
          child: SizedBox(
            height: 200,
            width: 400,
            child: Center(
              child: Text(
                'Something went wrong. Please try again.',
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                )
              ),
            ),
          ),
        );
      }

    }
  );
}

// UI for when the user is not logged in
accountNotLoggedIn(context, Size size) {
  
  return Scaffold(
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          // Display default profile picture
          Container(
            width: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey,
                width: 5.0,
              ),
            ),
            child: const CircleAvatar(
              radius: 60,
              backgroundImage: ExactAssetImage('assets/blank_profile.png'),
            ),
          ),

          // Spacing
          const SizedBox(
            height: 15,
          ),

          // Display login or sign up message
          SizedBox(
            width: size.width * 0.5,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Login or Sign Up ',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),

          // Spacing
          const SizedBox(
            height: 30,
          ),

          // Display list of default options
          SizedBox(
            height: size.height * 0.8,
            width: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
    
                // Option to sign in
                GestureDetector(
                  onTap: () {
                      Navigator.push(
                        context, PageTransition(child: const SignIn(), type: PageTransitionType.bottomToTop)
                      );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 25),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.login,
                              color: Colors.black87,
                              size: 24,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black87,
                          size: 18,
                        )
                      ],
                    ),
                  ),
                ),

                // Option to sign up
                GestureDetector(
                  onTap: () {
                      Navigator.push(
                        context, PageTransition(child: const SignUp(), type: PageTransitionType.bottomToTop)
                      );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 25),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.person_add_alt_1,
                              color: Colors.black87,
                              size: 24,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black87,
                          size: 18,
                        )
                      ],
                    ),
                  ),
                ),
    
              ],
            ),
          ),
          
        ],
      ),
    ),
  );
}