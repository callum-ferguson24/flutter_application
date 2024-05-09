// Necessary imports
// See docs for more info on imports: https://pub.dev/packages
import 'package:flutter/material.dart';
import 'package:flutter_application/auxilliary/network.dart';
import 'package:flutter_application/ui/screens/detail.dart';
import 'package:page_transition/page_transition.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Class to display saved flights
class SavedFlights extends StatefulWidget {
  const SavedFlights({super.key});

  @override
  State<SavedFlights> createState() => _SavedFlightsState();
}

class _SavedFlightsState extends State<SavedFlights> {
  final _future = Supabase.instance.client
      .from('saved')
      .select('account_id, flight_num');

  @override
  Widget build(BuildContext context) {
    final User? user = supabase.auth.currentUser;
    return Scaffold(

      // Body
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
              padding: const EdgeInsets.only(top: 30),
              height: 700,
                child: FutureBuilder(
                  future: _future,
                  builder: (context, snapshot) {

                    // Circular progress indicator
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final savedFlights = <dynamic>[];
                    final allData = snapshot.data!;

                    // Iterate through allData, check if the account_id matches current user id, if so, add to savedFlights list
                    for (var a in allData) {
                      if (a['account_id'] == user?.id) {
                        savedFlights.add(a);
                      }
                    }

                    // If no saved flights, display message
                    if(savedFlights.isEmpty){
                      return const Center(
                        child: Text(
                        'No Flights Saved',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black38,
                          ),
                        ),
                      );

                    // If saved flights are found, return ListView to display data
                    }else{
                      return ListView.builder(
                        itemCount: savedFlights.length,
                        itemBuilder: ((context, index) {
                          final entry = savedFlights[index];
            
                          return FutureBuilder(
                            future: fetchFlight(entry['flight_num'], 1),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {

                                // Info card for each saved flight
                                return Card(
                                  elevation: 1.0,
                                  margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                                  child: Container(
                                    decoration:
                                      const BoxDecoration(color: Colors.white10),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),

                                      // Departure time
                                      leading: Container(
                                        padding: const EdgeInsets.only(right: 12.0),
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                right: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.black38))),
                                        child: Text(snapshot.data[0].departure.time,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.black54,
                                            )),
                                      ),

                                      // Flight number and arrival airport
                                      title: Row(
                                        children: [
                                          Text(
                                            snapshot.data[0].flight.iata,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          flightStatus(snapshot),
                                        ],
                                      ),
                                      subtitle: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                                snapshot.data[0].arrival.airport,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.black54,
                                                )),
                                          ),
                                        ],
                                      ),

                                      // Gate Information
                                      trailing: Text(
                                        'Gate ' + snapshot.data[0].departure.gate,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.black54,
                                        ),
                                      ),

                                      // onTap function
                                      onTap: () async {
                                        String flight_num = snapshot.data[0].flight.iata;
                                        Navigator.push(context,
                                          PageTransition(child: Detail(flight_num), type: PageTransitionType.bottomToTop),
                                        );
                                        setState(() {});
                                      },

                                    ),
                                  ),
                                );

                              // Loading case
                              } else {
                                return const ListTile(
                                  title: Text("Loading"),
                                );
                              }

                            }
                          );
                        }),
                      );
                    }
                  }
                )
              ),
            ),
          ]
        ),
      )
    );
  }

  flightStatus(snapshot) {
    if(snapshot.data[0].departure.delay >= 5){
      return Container(
        height: 20,
        width: 50,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 208, 122, 115),
          borderRadius:
            BorderRadius.all(Radius.circular(40))),
        child: const Center(
          child: Text(
            'Delay',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white
            ),
          ),
        ),
      );
    } else {
      return Container(
        height: 20,
        width: 100,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 148, 208, 115),
          borderRadius:
            BorderRadius.all(Radius.circular(40))),
        child: const Center(
          child: Text(
            'On Schedule',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white
            ),
          ),
        ),
      );
    }
  }

}
