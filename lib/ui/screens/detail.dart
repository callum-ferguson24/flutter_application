// Necessary imports
// See docs for more info on imports: https://pub.dev/packages
import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/auxilliary/network.dart';
import 'package:flutter_application/auxilliary/notification_controller.dart';
import 'package:flutter_application/ui/root_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class Detail extends StatefulWidget {
  String flightNum;
  Detail(this.flightNum, {super.key});
  @override
  State<Detail> createState() => _DetailState(flightNum);
}

class _DetailState extends State<Detail> {

  // Method to initialise the notification listeners
  // This method was created using the awesome_notifications package
  // The docs for the awesome_notifications package can be found at https://pub.dev/packages/awesome_notifications
  @override
  void initState() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: NotificationController.onDismissActionReceivedMethod);
    super.initState();
  }

  String flightNum;
  _DetailState(this.flightNum);

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: fetchFlight(flightNum, 1),
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        // If there is no data, display this screen
        if(flightNum == 'TBC'){
          return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Image.asset("assets/plane.jpeg"),
                  ),
                  buttonBlur(context),
                  infoCardNoFlightNumber(),
                ],
              ),
            )
          );
        
        // If there is data and user is logged in, display this screen
        } else if (snapshot.hasData && supabase.auth.currentUser != null) {
          return FutureBuilder(
            future: getData(flightNum),
            builder: (context2, database) {
              var allData = database.data;
              return SafeArea(
                child: Scaffold(
                body: Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Image.asset("assets/plane.jpeg"),
                    ),
                    buttonBlur(context),
                    infoCardUserData(snapshot, allData.toString()!="[]"),
                  ],
                ),
              ));
            }
          );

        // If there is data and user is not logged in, display this screen
        } else if (snapshot.hasData && supabase.auth.currentUser == null) {
          return SafeArea(
            child: Scaffold(
            body: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Image.asset("assets/plane.jpeg"),
                ),
                buttonBlur(context),
                infoCardData(snapshot),
              ],
            ),
          ));
        
        // Display this screen while data is loading
        } else {
          return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Image.asset("assets/plane.jpeg"),
                  ),
                  buttonBlur(context),
                  infoCardLoading(),
                ],
              ),
            )
          );
        }
      }
    );
  }

  // Method for blurred back button
  // This method was created using the BackdropFilter widget
  // The docs for the BackdropFilter widget can be found at https://api.flutter.dev/flutter/widgets/BackdropFilter-class.html
  buttonBlur(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: InkWell(
        onTap: () {
          Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, 
          child: const RootPage()));
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white70,
                size: 25,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // The below methods are for the information card layout

  // Information card layout for when no flight number is available
  infoCardNoFlightNumber(){
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.8,
      minChildSize: 0.6,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25),
                topLeft: Radius.circular(25)),
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 5,
                        width: 35,
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.all(Radius.circular(40))
                        ),
                      ),
                    ],
                  ),  
                ),
                const SizedBox(
                  height: 400,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Flight Information Not Available",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black38,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  // Information card layout loading screen
  infoCardLoading() {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.8,
      minChildSize: 0.6,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(25),
              topLeft: Radius.circular(25)),
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 5,
                        width: 35,
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.all(Radius.circular(40))
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Departure info layout
                const Row(
                  children: <Widget>[
                    Expanded(
                        flex: 25,
                        child: Text(
                          "Loading...",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black87,
                          ),
                        )),
                    Expanded(
                        flex: 60,
                        child: Text(
                          "",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromARGB(221, 161, 155, 155),
                          ),
                        )),
                    Expanded(
                      flex: 15,
                      child: Icon(
                        Icons.flight_takeoff,
                        color: Colors.black87,
                        size: 35,
                      ),
                    ),
                  ],
                ),

                // Spacing and Divider
                const SizedBox(
                  height: 20,
                ),
                const Divider(height: 2, thickness: 2),
                const SizedBox(
                  height: 20,
                ),

                // Arrival info layout
                const Row(
                  children: <Widget>[
                    Expanded(
                        flex: 25,
                        child: Text(
                          "Loading...",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black87,
                          ),
                        )),
                    Expanded(
                        flex: 60,
                        child: Text(
                          "",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black87,
                          ),
                        )),
                    Expanded(
                      flex: 15,
                      child: Icon(
                        Icons.flight_land,
                        color: Colors.black87,
                        size: 35,
                      ),
                    ),
                  ],
                ),

                // Spacing and Divider
                const SizedBox(
                  height: 20,
                ),
                const Divider(height: 2, thickness: 2),
                const SizedBox(
                  height: 20,
                ),

                // Date and flight number layout
                const IntrinsicHeight(
                  child: Row(
                    children: <Widget>[

                      // Date
                      Expanded(
                        flex: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Date",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "Loading...",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            )
                          ],
                        ),
                      ),

                      // Spacing and Divider
                      SizedBox(
                        height: 120,
                        child: VerticalDivider(
                          width: 10,
                          thickness: 2,
                        ),
                      ),

                      // Flight Number
                      Expanded(
                        flex: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Flight Number",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "Loading...",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            )
                          ],
                        ),
                      ),

                    ],
                  ),
                ),

                // Spacing and Divider
                const SizedBox(
                  height: 20,
                ),
                const Divider(height: 2, thickness: 2),
                const SizedBox(
                  height: 20,
                ),

                // Gate and terminal info layout
                const IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      // Gate
                      Expanded(
                        flex: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Gate",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "Loading...",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            )
                          ],
                        ),
                      ),

                      // Spacing and Divider
                      SizedBox(
                        height: 120,
                        child: VerticalDivider(
                          width: 10,
                          thickness: 2,
                        ),
                      ),

                      // Terminal
                      Expanded(
                        flex: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Terminal",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "Loading...",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Spacing and Divider
                const SizedBox(
                  height: 20,
                ),
                const Divider(height: 2, thickness: 2),
                const SizedBox(
                  height: 40,
                ),

              ],
            ),
          ),
        );
      }
    );
  }

  // Info card layout for when there is data and the user is not logged in
  infoCardData(snapshot) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.8,
      minChildSize: 0.6,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(25), topLeft: Radius.circular(25)),
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Padding and scroll notch
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 5,
                        width: 35,
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                          borderRadius:
                            BorderRadius.all(Radius.circular(40))),
                      ),
                    ],
                  ),
                ),

                // Departure info and layout
                Row(
                  children: <Widget>[
                    Expanded(
                        flex: 20,
                        child: Text(
                          snapshot.data[0].departure.time,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black87,
                          ),
                        )),
                    Expanded(
                      flex: 65,
                      child: Text(
                        snapshot.data[0].departure.airport,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 15,
                      child: Icon(
                        Icons.flight_takeoff,
                        color: Colors.black87,
                        size: 35,
                      ),
                    ),
                  ],
                ),

                // Spacing and Divider
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  height: 2,
                  thickness: 2
                  ),
                const SizedBox(
                  height: 20,
                ),

                // Arrival info and layout
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 20,
                      child: Text(
                        snapshot.data[0].arrival.time,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 65,
                      child: Text(
                        snapshot.data[0].arrival.airport,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 15,
                      child: Icon(
                        Icons.flight_land,
                        color: Colors.black87,
                        size: 35,
                      ),
                    ),
                  ],
                ),

                // Spacing and Divider
                const SizedBox(
                  height: 20,
                ),
                const Divider(height: 2, thickness: 2),
                const SizedBox(
                  height: 20,
                ),

                // Date and flight number information and layout
                IntrinsicHeight(
                  child: Row(
                    children: <Widget>[

                      // Date
                      Expanded(
                        flex: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Date",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              snapshot.data[0].departure.date,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Spacing and Divider
                      const SizedBox(
                        height: 120,
                        child: VerticalDivider(
                          width: 10,
                          thickness: 2,
                        ),
                      ),

                      // Flight Number
                      Expanded(
                        flex: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Flight Number",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              snapshot.data[0].flight.iata,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Spacing and Divider
                const SizedBox(
                  height: 20,
                ),
                const Divider(height: 2, thickness: 2),
                const SizedBox(
                  height: 20,
                ),

                // Gate and terminal information and layout
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      // Gate
                      Expanded(
                        flex: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Gate",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              snapshot.data[0].departure.gate,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Spacing and Divider
                      const SizedBox(
                        height: 120,
                        child: VerticalDivider(
                          width: 10,
                          thickness: 2,
                        ),
                      ),

                      // Terminal
                      Expanded(
                        flex: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Terminal",
                              style: TextStyle(
                                //fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              snapshot.data[0].departure.terminal,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Spacing and Divider
                const SizedBox(
                  height: 20,
                ),
                const Divider(height: 2, thickness: 2),
                const SizedBox(
                  height: 40,
                ),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: 400,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        child: const Center(
                          child: Text(
                            'Log in to Save Flight',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),

                // Delay information
                delayInfo(snapshot),

              ],
            ),
          ),
        );
      }
    );
  }

  // Info card layout for when there is data and the user is logged in
  infoCardUserData(snapshot, bool databaseHasData) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.85,
      minChildSize: 0.6,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(25), topLeft: Radius.circular(25)),
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Padding and scroll notch
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 5,
                        width: 35,
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                          borderRadius:
                            BorderRadius.all(Radius.circular(40))),
                      ),
                    ],
                  ),
                ),

                // Departure info and layout
                Row(
                  children: <Widget>[
                    Expanded(
                        flex: 20,
                        child: Text(
                          snapshot.data[0].departure.time,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black87,
                          ),
                        )),
                    Expanded(
                      flex: 65,
                      child: Text(
                        snapshot.data[0].departure.airport,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 15,
                      child: Icon(
                        Icons.flight_takeoff,
                        color: Colors.black87,
                        size: 35,
                      ),
                    ),
                  ],
                ),

                // Spacing and Divider
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  height: 2,
                  thickness: 2
                  ),
                const SizedBox(
                  height: 20,
                ),

                // Arrival info and layout
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 20,
                      child: Text(
                        snapshot.data[0].arrival.time,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 65,
                      child: Text(
                        snapshot.data[0].arrival.airport,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 15,
                      child: Icon(
                        Icons.flight_land,
                        color: Colors.black87,
                        size: 35,
                      ),
                    ),
                  ],
                ),

                // Spacing and Divider
                const SizedBox(
                  height: 20,
                ),
                const Divider(height: 2, thickness: 2),
                const SizedBox(
                  height: 20,
                ),

                // Date and flight number information and layout
                IntrinsicHeight(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Date",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              snapshot.data[0].departure.date,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Spacing and Divider
                      const SizedBox(
                        height: 120,
                        child: VerticalDivider(
                          width: 10,
                          thickness: 2,
                        ),
                      ),

                      // Flight Number
                      Expanded(
                        flex: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Flight Number",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              snapshot.data[0].flight.iata,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Spacing and Divider
                const SizedBox(
                  height: 20,
                ),
                const Divider(height: 2, thickness: 2),
                const SizedBox(
                  height: 20,
                ),

                // Gate and terminal information and layout
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      // Gate
                      Expanded(
                        flex: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Gate",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              snapshot.data[0].departure.gate,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Spacing and Divider
                      const SizedBox(
                        height: 120,
                        child: VerticalDivider(
                          width: 10,
                          thickness: 2,
                        ),
                      ),

                      // Terminal
                      Expanded(
                        flex: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Terminal",
                              style: TextStyle(
                                //fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              snapshot.data[0].departure.terminal,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Spacing and Divider
                const SizedBox(
                  height: 20,
                ),
                const Divider(height: 2, thickness: 2),
                const SizedBox(
                  height: 40,
                ),

                // Calling button for add/remove from favourites
                Row(
                  children: [
                    Expanded(
                      child: 
                      getButton(databaseHasData), 
                    ),
                  ],
                ),

                // Spacing
                const SizedBox(
                  height: 20,
                ),

                // Delay information
                delayInfo(snapshot),

              ], 
            ),
          ),
        );
      }
    );
  }

  // Method for fetching data from the 'saved' table in Supabase
  getData(String flightNum) {
      var data = Supabase.instance.client
          .from('saved')
          .select('flight_num')
          .eq('account_id', supabase.auth.currentUser!.id)
          .eq('flight_num', flightNum);
          return data;
  }

  // Method for add/remove from favourites button
  getButton(hasData) {
    if(hasData){
      return GestureDetector(
        onTap: () async {
          await supabase
          .from('saved')
          .delete()
          .match({'flight_num': flightNum});

          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 1,
              channelKey: 'basic_channel',
              title: 'Flight Removed',
              body: 'Flight $flightNum has been removed from favourites.',
            ),
          );

          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
              child: const RootPage(),
              type: PageTransitionType.bottomToTop), (route) => false);
        },
        child: Container(
          width: 400,
          decoration: BoxDecoration(
            color: Colors.red[200],
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: const Center(
            child: Text(
              'Remove From Favourites',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () async {
          String userId = supabase.auth.currentUser!.id;
          await supabase
          .from('saved')
          .insert({'account_id': userId, 'flight_num': flightNum});

          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 1,
              channelKey: 'basic_channel',
              title: 'Flight Added',
              body: 'Flight $flightNum has been added to favourites.',
            ),
          );

          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
              child: const RootPage(),
              type: PageTransitionType.bottomToTop), (route) => false);
        },
        child: Container(
          width: 400,
          decoration: BoxDecoration(
            color: Colors.green[200],
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: const Center(
            child: Text(
              'Add to Favourites',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      );
    }
  }

  // Method for displaying delay information
  delayInfo(snapshot) {
    var delay = snapshot.data[0].departure.delay;
    DateTime oldDeparture = DateTime.parse(snapshot.data[0].departure.scheduled);
    DateTime newDeparture = oldDeparture.add(Duration(minutes: delay));
    String formattedNewDepartureTime = DateFormat('HH:mm').format(newDeparture);
    
    if (snapshot.data[0].departure.delay < 5) {
      return const Center(
        child: SizedBox(
          width: 200,
          height: 70,
          child: Center(
            child: Text(
              "Flight on Schedule",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black26,
              ),
            ),
          ),
        ),
      );
    } else {
      return Center(
        child: SizedBox(
          width: 400,
          height: 70,
          child: Center(
            child: Text(
              'Flight delayed to $formattedNewDepartureTime',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color.fromARGB(255, 208, 122, 115),
              ),
            ),
          ),
        ),
      );
    }
  }

}