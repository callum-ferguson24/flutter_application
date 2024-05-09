// Necessary imports
// See docs for more info on imports: https://pub.dev/packages
import 'package:flutter/material.dart';
import 'package:flutter_application/auxilliary/all_flight.dart';
import 'package:flutter_application/auxilliary/network.dart';
import 'package:flutter_application/ui/screens/detail.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_application/auxilliary/airports.dart';

// Class to display search page
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String flightNumber = '';
  String? departureAirportCode = '';
  String? arrivalAirportCode = '';
  @override
  Widget build(BuildContext context) {
    final myController = TextEditingController();
    
    return Scaffold(
      
      // Appbar
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Find Flights", style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 50, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  
                  // Search bar for flight number
                  Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
                      width: 400,
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: (){
                              departureAirportCode = '';
                              arrivalAirportCode = '';
                              flightNumber = myController.text;
                              setState(() {});
                            },
                            icon: const Icon(Icons.search, color: Colors.black54),
                          ),
                          Expanded(
                            child: TextField(
                              controller: myController,
                              showCursor: true,
                              decoration: const InputDecoration(
                                hintText: 'Search Flight Number',
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ]
                      ),
                    ),
                  ),
                
                ]
              ),
            ),

            // Spacing for search bars
            const SizedBox(height: 1),
            
            // Search bar for departure airport code
            // TypeAheadField for arrival airport code
            // TypeAheadField got from pub.dev package at https://pub.dev/packages/flutter_typeahead
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TypeAheadField<String>(
                  builder: (context, controller, focusNode) {
                    return Material(
                      elevation: 1,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
                        width: 400,
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const IconButton(
                              onPressed: null,
                              icon: Icon(Icons.flight_takeoff, color: Colors.black54)
                            ),
                            Expanded(
                              child: TextField(
                                controller: controller,
                                focusNode: focusNode,
                                autofocus: false,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  hintText: 'Search Departure Airport',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ); 
                  },

                  decorationBuilder: (context, child) {
                  return Material(
                      type: MaterialType.card,
                      elevation: 4,
                      borderRadius: BorderRadius.circular(10),
                      child: child,
                    );
                  },

                  suggestionsCallback: (pattern) {
                    return Airports.flippedMap(Airports.airports).keys
                      .where((code) => code.toLowerCase().contains(pattern.toLowerCase()))
                      .toList();
                    },

                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                    );
                  },

                  onSelected: (suggestion) {
                    setState(() {
                    departureAirportCode = Airports.flippedMap(Airports.airports)[suggestion];
                    }); 
                  },
                  offset: const Offset(0, 10),
                  constraints: const BoxConstraints(maxHeight: 300),
                ),
              ],
            ),

            // Spacing for search bars
            const SizedBox(height: 18),

            // Search bar for arrival airport code
            // TypeAheadField for arrival airport code
            // TypeAheadField got from pub.dev package at https://pub.dev/packages/flutter_typeahead
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TypeAheadField<String>(
                  builder: (context, controller, focusNode) {
                    return Material(
                      elevation: 1,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
                        width: 400,
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const IconButton(
                              onPressed: null,
                              icon: Icon(Icons.flight_land, color: Colors.black54)
                            ),
                            Expanded(
                              child: TextField(
                                controller: controller,
                                focusNode: focusNode,
                                autofocus: false,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  hintText: 'Search Arrival Airport',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ); 
                  },

                  decorationBuilder: (context, child) {
                  return Material(
                      type: MaterialType.card,
                      elevation: 4,
                      borderRadius: BorderRadius.circular(10),
                      child: child,
                    );
                  },

                  suggestionsCallback: (pattern) {
                    return Airports.flippedMap(Airports.airports).keys
                      .where((code) => code.toLowerCase().contains(pattern.toLowerCase()))
                      .toList();
                    },

                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                    );
                  },

                  onSelected: (suggestion) {
                    setState(() {
                    arrivalAirportCode = Airports.flippedMap(Airports.airports)[suggestion];
                    }); 
                  },
                  offset: const Offset(0, 10),
                  constraints: const BoxConstraints(maxHeight: 300),
                ),
              ],
            ),
          
            // Spacing after search bars
            const SizedBox(height: 10,),
            
            // Display flight information in list view method call
            flightListView(),

          ]
        ),
      ),
    );
  }

  flightListView(){

    // Search results for searching by departure airport
    if(departureAirportCode != ''){
      return FutureBuilder(
        future: fetchDepartureAirportFlight(departureAirportCode, 100),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {

            var sortList = snapshot.data;
            sortList.sort(sortCompDeparture);

            if(sortList!=null){
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: sortList.length,
                itemBuilder: (BuildContext context, int index) {

                  // Display flight information card
                  return Card(
                    elevation: 1.0,
                    margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.white10),
                      child: ListTile(
                        contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),

                        // Departure time display  
                        leading: Container(
                          padding: const EdgeInsets.only(right: 12.0),
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(width: 1.0, color: Colors.black38))),
                          child: Text(sortList[index].departure.time,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black54,
                            )
                          ),
                        ),

                        // Flight number and status display
                        title: Row(
                          children: [
                            Text(
                              sortList[index].flight.iata,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(width: 15),
                            flightStatusDisplayNotSorted(snapshot, index),
                          ],
                        ),

                        // Arrival airport display
                        subtitle: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Text(sortList[index].arrival.airport,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black54,
                                )),
                            ),
                          ],
                        ),

                        // Departure gate display
                        trailing:
                          Text('Gate ' + sortList[index].departure.gate,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.black54,
                                ),
                              ),

                        // Navigate to flight detail page on tap      
                        onTap: () {
                          String flightNum = sortList[index].flight.iata;
                          Navigator.push(
                          context, PageTransition(child: Detail(flightNum), type: PageTransitionType.bottomToTop));
                        },

                      ),
                    ),
                  );
                }
              );

            }else{
              return Container();
            }

          // Display error message if data fails to load 
          } else if (snapshot.hasError) {
            return const Center(
              child: SizedBox(
                height: 200,
                width: 400,
                child: Center(
                  child: Text(
                    'Data failed to load. Please check your internet connection.',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )
                  ),
                ),
              ),
            );

          // Display loading message 
          } else {
            return const Center(
              child: SizedBox(
                height: 200,
                width: 400,
                child: Center(
                  child: Text(
                    'Loading Flight Information...',
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

    } else if (arrivalAirportCode != ''){
      
      return FutureBuilder(
        future: fetchArrivalAirportFlight(arrivalAirportCode, 100),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {

            var sortedList = snapshot.data;
            sortedList.sort(sortCompArrival);

            if(sortedList!=null){
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: sortedList.length,
                itemBuilder: (BuildContext context, int index) {

                  // Display flight information card
                  return Card(
                    elevation: 1.0,
                    margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.white10),
                      child: ListTile(
                        contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),

                        // Departure time display  
                        leading: Container(
                          padding: const EdgeInsets.only(right: 12.0),
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(width: 1.0, color: Colors.black38))),
                          child: Text(sortedList[index].arrival.time,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black54,
                            )
                          ),
                        ),

                        // Flight number and status display
                        title: Row(
                          children: [
                            Text(
                              sortedList[index].flight.iata,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(width: 15),
                            flightStatusDisplayNotSorted(snapshot, index),
                          ],
                        ),

                        // Arrival airport display
                        subtitle: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Text(sortedList[index].departure.airport,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black54,
                                )),
                            ),
                          ],
                        ),

                        // Departure gate display
                        trailing:
                          Text('Term ${sortedList[index].arrival.terminal}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.black54,
                                ),
                              ),

                        // Navigate to flight detail page on tap      
                        onTap: () {
                          String flightNum = sortedList[index].flight.iata;
                          Navigator.push(
                          context, PageTransition(child: Detail(flightNum), type: PageTransitionType.bottomToTop));
                        },

                      ),
                    ),
                  );
                }
              );

            }else{
              return Container();
            }

          // Display error message if data fails to load 
          } else if (snapshot.hasError) {
            return const Center(
              child: SizedBox(
                height: 200,
                width: 400,
                child: Center(
                  child: Text(
                    'Data failed to load. Please check your internet connection.',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )
                  ),
                ),
              ),
            );

          // Display loading message 
          } else {
            return const Center(
              child: SizedBox(
                height: 200,
                width: 400,
                child: Center(
                  child: Text(
                    'Loading Flight Information...',
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

    } else {
      return FutureBuilder(
        future: fetchFlight(flightNumber, 100),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {

            var sortList = snapshot.data;
            sortList.sort(sortCompDeparture);
          
          // Null check for sortList
          if(sortList!=null){
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: sortList.length,
              itemBuilder: (BuildContext context, int index) {

                // Display flight information card
                return Card(
                  elevation: 1.0,
                  margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.white10),
                    child: ListTile(
                      contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),

                      // Departure time display  
                      leading: Container(
                        padding: const EdgeInsets.only(right: 12.0),
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(width: 1.0, color: Colors.black38)
                          ),
                        ),
                        child: Text(sortList[index].departure.time,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black54,
                          )
                        ),
                      ),

                      // Flight number and status display
                      title: Row(
                        children: [
                          Text(
                            sortList[index].flight.iata,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(width: 15),
                          flightStatusDisplaySorted(sortList, index),
                        ],
                      ),

                      // Arrival airport display
                      subtitle: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text(sortList[index].arrival.airport,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Departure gate display
                      trailing:
                        Text('Gate ' + sortList[index].departure.gate,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),

                      // Navigate to flight detail page on tap  
                      onTap: () {
                        String flightNum = sortList[index].flight.iata;
                        Navigator.push(
                        context, PageTransition(child: Detail(flightNum), type: PageTransitionType.bottomToTop));
                      },
                    
                    ),
                  ),
                );

              }
            );

          }else{
            return Container();
          }

          // Display error message if data fails to load  
          } else if (snapshot.hasError) {
            return const Center(
              child: SizedBox(
                height: 200,
                width: 400,
                child: Center(
                  child: Text(
                    'Data failed to load. Please check your internet connection.',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )
                  ),
                ),
              ),
            );

          // Display loading message  
          } else {
            return const Center(
              child: SizedBox(
                height: 200,
                width: 400,
                child: Center(
                  child: Text(
                    'Loading Flight Information...',
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

  }

  // Method for returning flight status indicator for not sorted flights
  flightStatusDisplayNotSorted(snapshot, index) {

    // Display indicator for delayed flight
    if(snapshot.data[index].departure.delay >= 5){
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

    // Display indicator for on schedule flight  
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

  // Method for returning flight status indicator for sorted flights
  flightStatusDisplaySorted(sortList, index) {
    
    // Display indicator for delayed flight
    if(sortList[index].departure.delay >= 5){
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

    // Display indicator for on schedule flight  
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

  // Method for sorting flight information by departure time
  int sortCompDeparture(AllFlight a, AllFlight b) {
    
    final flightA = a.departure?.scheduled;
      if(flightA == null || flightA == "TBC"){
        return 0;
      }
    
    final flightB = b.departure?.scheduled;
      if(flightB == null || flightB == "TBC"){
        return 0;
      }

    if(a.arrival?.airport == null || b.arrival?.airport == null){
      return 0;
    }else{
      return flightA.compareTo(flightB);
    }

  }

  // Method for sorting flight information by arrival time
  int sortCompArrival(AllFlight a, AllFlight b) {
    
    final flightA = a.arrival?.scheduled;
      if(flightA == null || flightA == "TBC"){
        return 0;
      }
    
    final flightB = b.arrival?.scheduled;
      if(flightB == null || flightB == "TBC"){
        return 0;
      }

    if(a.departure?.airport == null || b.departure?.airport == null){
      return 0;
    }else{
      return flightA.compareTo(flightB);
    }

  }

}