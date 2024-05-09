// Necessary imports
// See docs for more info on imports: https://pub.dev/packages
import 'package:flutter/material.dart';
import 'package:flutter_application/auxilliary/network.dart';
import 'package:flutter_application/ui/screens/search_page.dart';
import 'package:flutter_application/ui/screens/saved_flights.dart';
import 'package:flutter_application/ui/screens/account.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_application/ui/screens/sign_in.dart';
import 'package:page_transition/page_transition.dart';

// Class to represent the root page of the app
// This class is the main page of the app and contains the bottom navigation bar
// The bottom navigation bar is used to navigate between different screens
// The bottom navigation bar is implemented using the AnimatedBottomNavigationBar package and docs can be found at https://pub.dev/packages/animated_bottom_navigation_bar
class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  // Keeps track of current bottom navigation bar Index
  int btmNavIdx = 0;

  // Function to return a list of widgets representing different screens
  List<Widget> screens(){
    return [
      const SavedFlights(),
      const Account(),
    ];
  }

  // List to store screen titles for the nav bar
  List<String> titles = [
    'Saved Flights',
    'Account',
  ];


  // List to store icons for the nav bar
  List<IconData> icons = [
    Icons.saved_search,
    Icons.person,
  ];

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      // Start of AppBar
      appBar: AppBar(
        centerTitle: true,
        title: Text(titles[btmNavIdx], style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),),

        // Sign in Button
        actions: [
          IconButton(
            onPressed: (){
              if(supabase.auth.currentUser == null){
                Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: const SignIn()));
              } else {
                setState(() {
                  btmNavIdx = 1;
                });
              }
            },
            icon: const Icon(Icons.login, color: Colors.black54),
          ),
        ],
        
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
      ),
      // End of AppBar

      // Start of main content
      // Main content of the page using IndexedStack to maintain the state of each screen
      body: SafeArea(
        child: IndexedStack(
          index: btmNavIdx,
          children: screens(),
        ),
      ),
      // End of main content
      
      // Start of bottom navigation bar
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: (){
          Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: const SearchPage()));
        },
        backgroundColor: Colors.blue[200],
        child: const Icon(Icons.search),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        splashColor: Colors.blue[200],
        activeColor: Colors.blue[200],
        inactiveColor: Colors.black54,
        icons: icons,
        activeIndex: btmNavIdx,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        onTap: (index){
          setState(() {
            btmNavIdx = index;
          });
        },
      )
      // End of bottom navigation bar

    );
    
  }
}