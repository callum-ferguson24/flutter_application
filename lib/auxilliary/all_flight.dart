// A class representing all relevant information about a flight, gathered from the Aviationstack API
class AllFlight {
  String? flightDate;
  String? flightStatus;
  Departure? departure;
  Arrival? arrival;
  Airline? airline;
  Flight? flight;
  String? aircraft;
  String? live;

  // Constructor for creating an instance of AllFlight
  AllFlight(
      {this.flightDate,
      this.flightStatus,
      this.departure,
      this.arrival,
      this.airline,
      this.flight,
      this.aircraft,
      this.live});

  // Constructor for creating an instance of AllFlight from a JSON object
  AllFlight.fromJson(Map<String, dynamic> json) {
    departure = json['departure'] != null
        ? new Departure.fromJson(json['departure'])
        : null;
    arrival =
        json['arrival'] != null ? new Arrival.fromJson(json['arrival']) 
        : null;
    flight =
        json['flight'] != null ? new Flight.fromJson(json['flight']) 
        : null;

    // Setting attributes that aren't used to null intentionally
    flightStatus = null;
    airline = null;
    aircraft = null;
    live = null;

  }

  // Converts an AllFlight instance into a JSON map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flight_date'] = this.flightDate;
    data['flight_status'] = this.flightStatus;
    if (this.departure != null) {
      data['departure'] = this.departure!.toJson();
    }
    if (this.arrival != null) {
      data['arrival'] = this.arrival!.toJson();
    }
    if (this.airline != null) {
      data['airline'] = this.airline!.toJson();
    }
    if (this.flight != null) {
      data['flight'] = this.flight!.toJson();
    }
    data['aircraft'] = this.aircraft;
    data['live'] = this.live;
    return data;
  }
}

// Class representing departure details for a flight
class Departure {
  String? airport;
  String? timezone;
  String? iata;
  String? icao;
  String? terminal;
  String? gate;
  int? delay;
  String? scheduled;
  String? estimated;
  String? actual;
  String? estimatedRunway;
  String? actualRunway;
  String? date;
  String? time;

  // Constructor for creating an instance of Departure
  Departure(
      {this.airport,
      this.timezone,
      this.iata,
      this.icao,
      this.terminal,
      this.gate,
      this.delay,
      this.scheduled,
      this.estimated,
      this.actual,
      this.estimatedRunway,
      this.actualRunway,
      this.date,
      this.time});

  // Constructor for creating an instance of Departure from a JSON object
  Departure.fromJson(Map<String, dynamic> json) {
    airport = json['airport'] ?? "TBC";
    gate = json['gate'] ?? "TBC";
    terminal = json['terminal'] ?? "TBC";
    delay = json['delay'] ?? 0;

    //Formatted Date and Time
    if (json['scheduled'] != null) {
      scheduled = json['scheduled'];
      date = scheduled?.split('T')[0];
      time = removeSeconds(scheduled!.split('T')[1].split('+')[0]);
    } else {
      scheduled = "TBC";
      date = "TBC";
      time = "TBC";
    }
    /*
    timezone = json['timezone'];
    iata = json['iata'];
    icao = json['icao'];
    terminal = json['terminal'];
    delay = json['delay'];
    estimated = json['estimated'];
    actual = json['actual'];
    estimatedRunway = json['estimated_runway'];
    actualRunway = json['actual_runway'];
    */
  }

  // Converts a Departure instance into a JSON map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['airport'] = this.airport;
    data['timezone'] = this.timezone;
    data['iata'] = this.iata;
    data['icao'] = this.icao;
    data['terminal'] = this.terminal;
    data['gate'] = this.gate;
    data['delay'] = this.delay;
    data['scheduled'] = this.scheduled;
    data['estimated'] = this.estimated;
    data['actual'] = this.actual;
    data['estimated_runway'] = this.estimatedRunway;
    data['actual_runway'] = this.actualRunway;
    return data;
  }
}

// Class representing arrival details for a flight
class Arrival {
  String? airport;
  String? timezone;
  String? iata;
  String? icao;
  String? terminal;
  String? gate;
  String? baggage;
  String? delay;
  String? scheduled;
  String? estimated;
  String? actual;
  String? estimatedRunway;
  String? actualRunway;
  String? date;
  String? time;

  // Constructor for creating an instance of Arrival
  Arrival(
      {this.airport,
      this.timezone,
      this.iata,
      this.icao,
      this.terminal,
      this.gate,
      this.baggage,
      this.delay,
      this.scheduled,
      this.estimated,
      this.actual,
      this.estimatedRunway,
      this.actualRunway,
      this.date,
      this.time});

  // Constructor for creating an instance of Arrival from a JSON object
  Arrival.fromJson(Map<String, dynamic> json) {
    airport = json['airport'] ?? "TBC";
    gate = json['gate'] ?? "TBC";
    terminal = json['terminal'] ?? "TBC";

    //Formatted Date and Time
    if (json['scheduled'] != null) {
      scheduled = json['scheduled'];
      date = scheduled?.split('T')[0];
      time = removeSeconds(scheduled!.split('T')[1].split('+')[0]);
    } else {
      scheduled = "TBC";
      date = "TBC";
      time = "TBC";
    }
    /*
    timezone = json['timezone'];
    iata = json['iata'];
    icao = json['icao'];
    terminal = json['terminal'];
    gate = json['gate'];
    baggage = json['baggage'];
    delay = json['delay'];
    scheduled = json['scheduled'];
    estimated = json['estimated'];
    actual = json['actual'];
    estimatedRunway = json['estimated_runway'];
    actualRunway = json['actual_runway'];
    */
  }

  // Converts an Arrival instance into a JSON map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['airport'] = this.airport;
    data['timezone'] = this.timezone;
    data['iata'] = this.iata;
    data['icao'] = this.icao;
    data['terminal'] = this.terminal;
    data['gate'] = this.gate;
    data['baggage'] = this.baggage;
    data['delay'] = this.delay;
    data['scheduled'] = this.scheduled;
    data['estimated'] = this.estimated;
    data['actual'] = this.actual;
    data['estimated_runway'] = this.estimatedRunway;
    data['actual_runway'] = this.actualRunway;
    return data;
  }
}

// Class representing an airline
class Airline {
  String? name;
  String? iata;
  String? icao;

  // Constructor for creating an instance of Airline
  Airline({this.name, this.iata, this.icao});

  // Constructor for creating an instance of Airline from a JSON object
  Airline.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "TBC";
    iata = json['iata'] ?? "TBC";
    icao = json['icao'] ?? "TBC";
  }

  // Converts an Airline instance into a JSON map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['iata'] = this.iata;
    data['icao'] = this.icao;
    return data;
  }
}

// Class representing a flight
class Flight {
  String? number;
  String? iata;
  String? icao;
  Codeshared? codeshared;

  // Constructor for creating an instance of Flight
  Flight({this.number, this.iata, this.icao, this.codeshared});

  // Constructor for creating an instance of Flight from a JSON object
  Flight.fromJson(Map<String, dynamic> json) {
    iata = json['iata'] ?? "TBC";

    // Setting attributes that aren't used to null intentionally
    number = null;
    icao = null;
    codeshared = null;

  }

  // Converts a Flight instance into a JSON map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['iata'] = this.iata;
    data['icao'] = this.icao;
    if (this.codeshared != null) {
      data['codeshared'] = this.codeshared!.toJson();
    }
    return data;
  }
}

// Class representing a codeshared flight
class Codeshared {
  String? airlineName;
  String? airlineIata;
  String? airlineIcao;
  String? flightNumber;
  String? flightIata;
  String? flightIcao;

  // Constructor for creating an instance of Codeshared
  Codeshared(
      {this.airlineName,
      this.airlineIata,
      this.airlineIcao,
      this.flightNumber,
      this.flightIata,
      this.flightIcao});

  // Constructor for creating an instance of Codeshared from a JSON object
  Codeshared.fromJson(Map<String, dynamic> json) {
    airlineName = json['airline_name'];
    airlineIata = json['airline_iata'];
    airlineIcao = json['airline_icao'];
    flightNumber = json['flight_number'];
    flightIata = json['flight_iata'];
    flightIcao = json['flight_icao'];
  }

  // Converts a Codeshared instance into a JSON map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['airline_name'] = this.airlineName;
    data['airline_iata'] = this.airlineIata;
    data['airline_icao'] = this.airlineIcao;
    data['flight_number'] = this.flightNumber;
    data['flight_iata'] = this.flightIata;
    data['flight_icao'] = this.flightIcao;
    return data;
  }
}

// Function to remove seconds from a time string currently formatted as "HH:mm:ss"
String removeSeconds(String time) {
  // Split the input time string into components based on the colon delimiter ':'
  List<String> components = time.split(':');
  // Extract the hours component from the split string
  String hours = components[0];
  // Extract the minutes component from the split string
  String minutes = components[1];
  // Concatenate hours and minutes with a colon and return the result
  return '$hours:$minutes';
}
