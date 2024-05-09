// Necessary imports
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'all_flight.dart';

final supabase = Supabase.instance.client;

// Function to parse the JSON response from the API into a list of AllFlight objects
List<AllFlight> parseFlight(String responseBody) {
  var lst = json.decode(responseBody)["data"] as List<dynamic>;
  List<AllFlight> flights = lst.map((model) => AllFlight.fromJson(model)).toList();
  return flights;
}

//Fetches a list of flights from the API based on the flight IATA code and the limit of flights to return
Future<List<AllFlight>> fetchFlight(String flightIata, int limit,) async {

  // API key for the aviationstack API goes here
  String link = '';

  if(flightIata != ""){
    link += '&flight_iata=$flightIata';  
  }

  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    return compute(parseFlight, response.body);
  } else {
    throw Exception('Request API Error');
  }
}

//Fetches a list of flights from the API based on the departure IATA code and the limit of flights to return
Future<List<AllFlight>> fetchDepartureAirportFlight(String? depIata, int limit) async {

  // API key for the aviationstack API goes here
  String link = '';


  depIata ??= "";
  if(depIata != ""){
    link += '&dep_iata=$depIata';
  }
  
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    return compute(parseFlight, response.body);
  } else {
    throw Exception('Request API Error');
  }
}

//Fetches a list of flights from the API based on the departure IATA code and the limit of flights to return
Future<List<AllFlight>> fetchArrivalAirportFlight(String? arrIata, int limit) async {

 // API key for the aviationstack API goes here
  String link = '';

  arrIata ??= "";
  if(arrIata != ""){
    link += '&arr_iata=$arrIata';
  }
  
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    return compute(parseFlight, response.body);
  } else {
    throw Exception('Request API Error');
  }
}

getDatabaseImage(String userId) async {
  final Uint8List file =
      await supabase.storage.from('avatars/$userId').download('avatar.png');

  return file;
}
